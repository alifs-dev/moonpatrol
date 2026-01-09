// Page d'accueil avec menu
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:moonpatrol/screens/camera_screen.dart';
import 'package:moonpatrol/screens/responsive_scaffold.dart';
import 'package:moonpatrol/services/dot.env_service.dart';

class HomeScreen extends StatelessWidget {
  final List<CameraDescription> cameras;

  const HomeScreen({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      child: Column(
        children: [
          // En-tête
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Icon(Icons.nightlight_round, color: Colors.white, size: 32),
                // const SizedBox(width: 10),
                Text(
                  EnvConfig.appName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Contenu principal
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Carte de présentation
                  _buildFeatureCard(
                    icon: Icons.camera_alt,
                    title: 'Capture Intelligente',
                    description: 'Photos haute qualité avec métadonnées GPS et capteurs',
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 20),
                  _buildFeatureCard(
                    icon: Icons.sensors,
                    title: 'Données en Temps Réel',
                    description: 'Accéléromètre, gyroscope, magnétomètre et plus',
                    color: Colors.purple,
                  ),
                  const SizedBox(height: 20),
                  _buildFeatureCard(
                    icon: Icons.location_on,
                    title: 'Géolocalisation',
                    description: 'GPS précis avec altitude, vitesse et cap',
                    color: Colors.teal,
                  ),
                  const SizedBox(height: 40),

                  // Bouton principal
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigation vers CameraScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CameraScreen(cameras: cameras),
                          ),
                        );
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.camera_alt, size: 28),
                          SizedBox(width: 10),
                          Text(
                            'Commencer',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Footer
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Version ${EnvConfig.appVersion}',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
