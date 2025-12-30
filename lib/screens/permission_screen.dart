import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:moonpatrol/services/permission_service.dart';
import 'camera_screen.dart';
import 'package:camera/camera.dart';

/// Écran de demande de permissions avant utilisation
class PermissionScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const PermissionScreen({super.key, required this.cameras});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  bool _cameraGranted = false;
  bool _locationGranted = false;
  bool _storageGranted = false;
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    setState(() => _isChecking = true);

    _cameraGranted = await PermissionService.isCameraPermissionGranted();
    _locationGranted = await PermissionService.isLocationPermissionGranted();
    _storageGranted = await PermissionService.isStoragePermissionGranted();

    setState(() => _isChecking = false);

    // Si toutes les permissions sont accordées, aller directement à la caméra
    if (_cameraGranted && _locationGranted && _storageGranted) {
      _navigateToCamera();
    }
  }

  Future<void> _requestPermissions() async {
    setState(() => _isChecking = true);

    await PermissionService.requestAllPermissions();
    await _checkPermissions();

    setState(() => _isChecking = false);
  }

  void _navigateToCamera() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => CameraScreen(cameras: widget.cameras)),
    );
  }

  Future<void> _openSettings() async {
    await openAppSettings();
    // Revérifier après retour des paramètres
    Future.delayed(const Duration(seconds: 1), () {
      _checkPermissions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final allGranted = _cameraGranted && _locationGranted && _storageGranted;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo/Icône
              const Icon(Icons.camera_alt_rounded, size: 100, color: Colors.blue),
              const SizedBox(height: 30),

              // Titre
              const Text(
                'Autorisations requises',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Description
              const Text(
                'MoonPatrol a besoin de ces autorisations pour fonctionner correctement :',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Liste des permissions
              if (_isChecking)
                const CircularProgressIndicator()
              else ...[
                _buildPermissionTile(
                  icon: Icons.camera_alt,
                  title: 'Caméra',
                  description: 'Pour prendre des photos',
                  granted: _cameraGranted,
                ),
                const SizedBox(height: 16),
                _buildPermissionTile(
                  icon: Icons.location_on,
                  title: 'Localisation',
                  description: 'Pour enregistrer les coordonnées GPS',
                  granted: _locationGranted,
                ),
                const SizedBox(height: 16),
                _buildPermissionTile(
                  icon: Icons.folder,
                  title: 'Stockage',
                  description: 'Pour sauvegarder les photos',
                  granted: _storageGranted,
                ),
              ],

              const Spacer(),

              // Boutons d'action
              if (!allGranted) ...[
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isChecking ? null : _requestPermissions,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Autoriser',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _openSettings,
                  child: const Text('Ouvrir les paramètres'),
                ),
              ] else
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _navigateToCamera,
                    icon: const Icon(Icons.check_circle, color: Colors.white),
                    label: const Text(
                      'Continuer',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionTile({
    required IconData icon,
    required String title,
    required String description,
    required bool granted,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: granted ? Colors.green.shade50 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: granted ? Colors.green : Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: granted ? Colors.green : Colors.grey,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Icon(
            granted ? Icons.check_circle : Icons.cancel,
            color: granted ? Colors.green : Colors.grey,
            size: 32,
          ),
        ],
      ),
    );
  }
}
