import 'package:flutter/material.dart';
import '../services/device_service.dart';
import 'package:flutter_animate/flutter_animate.dart';


class PairingScreen extends StatefulWidget {
  static const routeName = '/pairing';
  const PairingScreen({super.key});

  @override
  _PairingScreenState createState() => _PairingScreenState();
}

class _PairingScreenState extends State<PairingScreen> {
  final DeviceService _deviceService = DeviceService();
  bool _isConnected = false;
  bool _loading = false;

  Future<void> _connect() async {
    setState(() => _loading = true);
    final ok = await _deviceService.scanAndConnectToSentinel();
    setState(() {
      _isConnected = ok;
      _loading = false;
    });
  }

  Future<void> _disconnect() async {
    setState(() => _loading = true);
    await _deviceService.disconnectDevice();
    setState(() {
      _isConnected = false;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Module Sentinel')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Statut du module : ${_isConnected ? 'Connecté' : 'Non connecté'}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            !_isConnected
                ? ElevatedButton(
                    onPressed: _loading ? null : _connect,
                    child: Text(_loading ? 'Connexion...' : 'Rechercher un module'),
                  )
                : ElevatedButton(
                    onPressed: _loading ? null : _disconnect,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Text(_loading ? 'Déconnexion...' : 'Se déconnecter'),
                  ),
          ],
        ),
      ),
    );
  }
}
