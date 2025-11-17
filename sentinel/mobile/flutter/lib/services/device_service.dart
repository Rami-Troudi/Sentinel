import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceService {
  BluetoothDevice? _connectedDevice;
  BluetoothDevice? get connectedDevice => _connectedDevice;

  static const String sentinelNameFilter = "Sentinel";

  /// Scanne et connecte automatiquement au module Sentinel BLE
  Future<bool> scanAndConnectToSentinel({
    Duration timeout = const Duration(seconds: 8),
  }) async {
    if (kIsWeb) {
      debugPrint("❌ BLE non supporté sur le web");
      return false;
    }

    // Vérifier disponibilité du Bluetooth
    if (await FlutterBluePlus.isAvailable == false) {
      debugPrint("❌ Bluetooth non disponible sur cet appareil");
      return false;
    }

    // Android : demander d’activer Bluetooth
    if (Platform.isAndroid) {
      await FlutterBluePlus.turnOn();
    }

    BluetoothDevice? found;

    debugPrint("🔍 Début du scan BLE...");

    // Écouter les résultats de scan
    final StreamSubscription<List<ScanResult>> scanSub =
        FlutterBluePlus.scanResults.listen((results) {
      for (final r in results) {
        final name = r.device.localName;

        if (name.isNotEmpty &&
            name.toLowerCase().contains(sentinelNameFilter.toLowerCase())) {
          debugPrint("✅ Appareil Sentinel trouvé : $name");
          found ??= r.device; // garder le premier match
        }
      }
    });

    try {
      // Lancer le scan
      await FlutterBluePlus.startScan(timeout: timeout);

      // Attendre fin du scan
      await FlutterBluePlus.isScanning.firstWhere((s) => s == false);
    } catch (e, s) {
      debugPrint("⚠️ Erreur durant le scan BLE : $e\n$s");
    } finally {
      // Toujours arrêter proprement
      await FlutterBluePlus.stopScan();
      await scanSub.cancel();
    }

    // On fige la valeur trouvée dans une variable finale
    final BluetoothDevice? device = found;

    if (device == null) {
      debugPrint("❌ Aucun module Sentinel trouvé");
      return false;
    }

    debugPrint("🔗 Tentative de connexion à ${device.localName}...");

    try {
      await device.connect(
        license: License.free, // enum officielle: free / commercial
        timeout: const Duration(seconds: 10),
        autoConnect: false,
      );

      _connectedDevice = device;
      debugPrint("🎉 Connexion établie !");
      return true;
    } on FlutterBluePlusException catch (e, s) {
      debugPrint("❌ Erreur FlutterBluePlus lors de la connexion : $e\n$s");
      return false;
    } catch (e, s) {
      debugPrint("❌ Erreur inattendue lors de la connexion : $e\n$s");
      return false;
    }
  }

  /// Déconnecte proprement
  Future<void> disconnectDevice() async {
    final device = _connectedDevice;
    if (device == null) return;

    try {
      await device.disconnect();
      debugPrint("🔌 Module Sentinel déconnecté");
    } catch (e, s) {
      debugPrint("⚠️ Erreur pendant la déconnexion : $e\n$s");
    } finally {
      _connectedDevice = null;
    }
  }
}
