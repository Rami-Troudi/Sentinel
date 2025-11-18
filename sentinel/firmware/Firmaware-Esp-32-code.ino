#include <Arduino.h>
#include <Wire.h>
#include "MPU6050.h"
#include "BLEDevice.h"
#include "BLEServer.h"
#include "BLEUtils.h"
#include "BLE2902.h"

// ======================= CONFIG HARDWARE =======================

// I2C IMU
#define I2C_SDA_PIN 21
#define I2C_SCL_PIN 22

// GPS sur UART2
#define GPS_RX_PIN 16  // RX du module GPS -> TX2 de l'ESP32
#define GPS_TX_PIN 17  // TX du module GPS -> RX2 de l'ESP32
HardwareSerial GPS_Serial(2);

// LED / Buzzer
#define LED_PIN    2
#define BUZZER_PIN 4

// ======================= CONFIG BLE ============================

// UUIDs générés au hasard (tu peux les changer si tu veux)
#define SERVICE_UUID            "a7b4f2c0-1e2f-11ef-9b3c-325096b39f47"
#define TELEMETRY_CHAR_UUID     "a7b4f5a0-1e2f-11ef-9b3c-325096b39f47"
#define CONFIG_CHAR_UUID        "a7b4f7de-1e2f-11ef-9b3c-325096b39f47"

BLEServer* pServer = nullptr;
BLECharacteristic* pTelemetryChar = nullptr;
BLECharacteristic* pConfigChar = nullptr;

bool deviceConnected = false;

// ======================= IMU / MPU6050 =========================

MPU6050 mpu;

struct IMUData {
  float ax, ay, az;
  float gx, gy, gz;
};

IMUData imuData;

// ======================= GPS DATA ==============================

struct GPSData {
  bool fix;
  double latitude;
  double longitude;
  float speedKmh;
};

GPSData gpsData;

// ======================= DRIVING EVENTS ========================

// Seuils simplifiés pour détecter des événements de conduite
float ACCEL_HARSH_THRESHOLD = 3.0f;   // m/s^2 approximatif
float BRAKE_HARSH_THRESHOLD = -3.0f;  // m/s^2
bool lastHarshEvent = false;

// ======================= TIMERS ================================

unsigned long lastImuReadMs = 0;
unsigned long lastGpsReadMs = 0;
unsigned long lastBleSendMs = 0;

const unsigned long IMU_PERIOD_MS = 100;   // 10 Hz
const unsigned long GPS_PERIOD_MS = 500;   // 2 Hz (lecture/parsing)
const unsigned long BLE_PERIOD_MS = 200;   // 5 Hz (envoi télémétrie)

// ======================= BLE CALLBACKS =========================

class SentinelBLEServerCallbacks : public BLEServerCallbacks {
  void onConnect(BLEServer* pServer) override {
    deviceConnected = true;
    digitalWrite(LED_PIN, HIGH); // LED ON quand mobile connecté
  }

  void onDisconnect(BLEServer* pServer) override {
    deviceConnected = false;
    digitalWrite(LED_PIN, LOW);
    pServer->getAdvertising()->start();
  }
};

class ConfigCallbacks : public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic* pCharacteristic) override {
    std::string value = pCharacteristic->getValue();
    if (value.length() == 0) return;

    // On attend un JSON léger du type:
    // {"accel_harsh":3.5,"brake_harsh":-3.5}
    // Pour hackathon, on parse très simple, sans JSON lib.
    String configStr = String(value.c_str());

    int idxAccel = configStr.indexOf("accel_harsh");
    int idxBrake = configStr.indexOf("brake_harsh");

    if (idxAccel != -1) {
      int colon = configStr.indexOf(":", idxAccel);
      int comma = configStr.indexOf(",", idxAccel);
      if (colon != -1) {
        String val = configStr.substring(colon + 1, (comma != -1 ? comma : configStr.length()));
        ACCEL_HARSH_THRESHOLD = val.toFloat();
      }
    }

    if (idxBrake != -1) {
      int colon = configStr.indexOf(":", idxBrake);
      int comma = configStr.indexOf(",", idxBrake);
      if (colon != -1) {
        String val = configStr.substring(colon + 1, (comma != -1 ? comma : configStr.length()));
        BRAKE_HARSH_THRESHOLD = val.toFloat();
      }
    }

    // Petit bip pour confirmer config
    tone(BUZZER_PIN, 2000, 150); // nécessite analogWrite compatible, sinon utilise ledc
  }
};

// ======================= INIT IMU ==============================

bool initIMU() {
  Wire.begin(I2C_SDA_PIN, I2C_SCL_PIN);
  mpu.initialize();

  if (!mpu.testConnection()) {
    Serial.println("[IMU] Échec de connexion au MPU6050");
    return false;
  }

  Serial.println("[IMU] MPU6050 OK");
  return true;
}

void readIMU() {
  int16_t ax, ay, az, gx, gy, gz;
  mpu.getMotion6(&ax, &ay, &az, &gx, &gy, &gz);

  // Conversion brute -> valeurs "raisonnables"
  imuData.ax = ax / 16384.0f * 9.81f; // ~m/s^2 (approx)
  imuData.ay = ay / 16384.0f * 9.81f;
  imuData.az = az / 16384.0f * 9.81f;

  imuData.gx = gx / 131.0f; // deg/s approx
  imuData.gy = gy / 131.0f;
  imuData.gz = gz / 131.0f;
}

// ======================= INIT GPS ==============================

void initGPS() {
  GPS_Serial.begin(9600, SERIAL_8N1, GPS_RX_PIN, GPS_TX_PIN);
  gpsData.fix = false;
  gpsData.latitude = 0.0;
  gpsData.longitude = 0.0;
  gpsData.speedKmh = 0.0;
  Serial.println("[GPS] Initialisation UART2 9600 baud");
}

// Parser ultra simplifié : on lit les trames et on garde les dernières
// Pour le hackathon, tu peux te contenter de renvoyer le raw NMEA si besoin.
// Là, on fait juste un "mock" minimaliste pour garder l’idée.
void readGPS() {
  // On lit tout ce qui arrive, mais on ne fait pas un vrai parsing NMEA complet
  while (GPS_Serial.available()) {
    String nmea = GPS_Serial.readStringUntil('\n');

    // Exemple : si trame contient "GPRMC" on pourrait en extraire vitesse etc.
    // Pour le moment, on ne fait qu'un pseudo-parse indicatif.
    if (nmea.startsWith("$GPRMC")) {
      // TODO : parsing réel si tu veux une vraie vitesse / lat / lon.
      // Pour le hackathon, simplifions :
      gpsData.fix = true;  // On suppose fix OK si on reçoit GPRMC
      // L’IA/mobile peut traiter le NMEA brut si tu lui envoies séparément.
    }
  }
}

// ======================= DETECTION DES EVENEMENTS ==============

bool detectHarshEvent() {
  // Magnitude approximative sur l'axe X (longitudinal) pour freinage/accel
  float ax = imuData.ax; // m/s^2

  if (ax > ACCEL_HARSH_THRESHOLD) {
    return true;
  }

  if (ax < BRAKE_HARSH_THRESHOLD) {
    return true;
  }

  return false;
}

void handleFeedback(bool harshEvent) {
  if (harshEvent && !lastHarshEvent) {
    // Début d'un événement harsh -> bip + flash LED
    digitalWrite(LED_PIN, HIGH);
    tone(BUZZER_PIN, 2500, 200);
  } else if (!harshEvent && lastHarshEvent) {
    // Fin d'événement
    digitalWrite(LED_PIN, deviceConnected ? HIGH : LOW);
  }

  lastHarshEvent = harshEvent;
}

// ======================= BLE INIT ==============================

void initBLE() {
  BLEDevice::init("Sentinel Pod"); // Nom qui apparaitra côté mobile

  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new SentinelBLEServerCallbacks());

  BLEService* pService = pServer->createService(SERVICE_UUID);

  pTelemetryChar = pService->createCharacteristic(
      TELEMETRY_CHAR_UUID,
      BLECharacteristic::PROPERTY_NOTIFY
  );
  pTelemetryChar->addDescriptor(new BLE2902());

  pConfigChar = pService->createCharacteristic(
      CONFIG_CHAR_UUID,
      BLECharacteristic::PROPERTY_WRITE
  );
  pConfigChar->setCallbacks(new ConfigCallbacks());

  pService->start();
  pServer->getAdvertising()->start();

  Serial.println("[BLE] Service 'Sentinel Pod' démarré, en attente de connexion...");
}

// ======================= ENVOI TELEMETRIE =======================

void sendTelemetry() {
  if (!deviceConnected) return;

  // Event harsh ?
  bool harshEvent = detectHarshEvent();
  handleFeedback(harshEvent);

  // Construction d'un JSON léger
  // NOTE : pour le hackathon c'est suffisant. Pour la prod, utiliser une lib JSON.
  String payload = "{";
  payload += "\"imu\":{";
  payload += "\"ax\":" + String(imuData.ax, 3) + ",";
  payload += "\"ay\":" + String(imuData.ay, 3) + ",";
  payload += "\"az\":" + String(imuData.az, 3) + ",";
  payload += "\"gx\":" + String(imuData.gx, 3) + ",";
  payload += "\"gy\":" + String(imuData.gy, 3) + ",";
  payload += "\"gz\":" + String(imuData.gz, 3) + "},";
  payload += "\"gps\":{";
  payload += "\"fix\":" + String(gpsData.fix ? "true" : "false") + ",";
  payload += "\"lat\":" + String(gpsData.latitude, 6) + ",";
  payload += "\"lon\":" + String(gpsData.longitude, 6) + ",";
  payload += "\"speed_kmh\":" + String(gpsData.speedKmh, 2) + "},";
  payload += "\"events\":{";
  payload += "\"harsh\":" + String(harshEvent ? "true" : "false");
  payload += "}";
  payload += "}";

  pTelemetryChar->setValue(payload.c_str());
  pTelemetryChar->notify();
}

// ======================= SETUP / LOOP ==========================

void setup() {
  Serial.begin(115200);
  delay(1000);
  Serial.println("=== Sentinel Pod Firmware Boot ===");

  pinMode(LED_PIN, OUTPUT);
  pinMode(BUZZER_PIN, OUTPUT);
  digitalWrite(LED_PIN, LOW);
  digitalWrite(BUZZER_PIN, LOW);

  // IMU
  if (!initIMU()) {
    Serial.println("[WARN] IMU non disponible. Continuer sans?");
  }

  // GPS
  initGPS();

  // BLE
  initBLE();

  lastImuReadMs = millis();
  lastGpsReadMs = millis();
  lastBleSendMs = millis();
}

void loop() {
  unsigned long now = millis();

  // Lecture IMU
  if (now - lastImuReadMs >= IMU_PERIOD_MS) {
    readIMU();
    lastImuReadMs = now;
  }

  // Lecture GPS
  if (now - lastGpsReadMs >= GPS_PERIOD_MS) {
    readGPS();
    lastGpsReadMs = now;
  }

  // Envoi télémétrie BLE
  if (now - lastBleSendMs >= BLE_PERIOD_MS) {
    sendTelemetry();
    lastBleSendMs = now;
  }

  // Petite pause pour éviter de surcharger le CPU
  delay(5);
}
