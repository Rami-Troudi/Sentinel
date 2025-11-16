# Firmware – Module embarqué Sentinel (ESP32)

Ce module contient le code embarqué exécuté sur le microcontrôleur  
(**ESP32** ou équivalent). Son rôle :

- lire en continu les données de l’**IMU** (accéléromètre + gyroscope) ;
- détecter les événements pertinents (freinages, virages, accélérations) ;
- formater les données en paquets ;
- les transmettre au **mobile** (BLE/WiFi/Serial selon configuration).

---

## Structure

- `platformio.ini` : configuration PlatformIO pour la cible ESP32.

- `src/main.cpp` :
  - initialisation du microcontrôleur ;
  - initialisation du capteur IMU ;
  - boucle principale : acquisition + envoi périodique.

- `src/imu.cpp` / `src/imu.h` :
  - interface avec le capteur (ex. MPU6050) ;
  - fonctions `imu_init()`, `imu_read()`.

- `src/connectivity.cpp` / `src/connectivity.h` :
  - gestion du canal de communication (ex. BLE ou WiFi) ;
  - fonctions `send_packet(...)` utilisant un format simple (JSON ou binaire).

- `src/packet_format.cpp` / `src/packet_format.h` :
  - définition du format de paquet envoyé au mobile  
    (timestamp, ax, ay, az, gx, gy, gz).

---

## Mode démo

En phase initiale, le firmware peut :

- soit lire un vrai IMU si disponible ;
- soit **générer des données simulées** (sinus, pattern de freinage…) pour démontrer le flux complet.

L’important pour le hackathon est de montrer :

1. la structure du code,
2. le format de données,
3. le lien clair avec la chaîne IA → scores.
