# 📸 Moon Patrol

Application Flutter professionnelle qui capture des photos avec toutes les données des capteurs du smartphone (GPS, accéléromètre, gyroscope, magnétomètre, batterie).

# Moon Patrol Viewer:
https://github.com/alifs-dev/moonpatrol_editor

![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-green.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

## ✨ Fonctionnalités

- 📸 **Capture photo** en plein écran avec interface moderne
- 📍 **GPS** : Latitude, longitude, altitude, vitesse, cap
- 📐 **Accéléromètre** : Mesure de l'inclinaison sur 3 axes
- 🔄 **Gyroscope** : Détection de rotation
- 🧭 **Magnétomètre** : Orientation magnétique (boussole)
- 🔋 **Batterie** : Niveau de charge
- 📱 **Infos appareil** : Modèle, OS, fabricant
- 💾 **Métadonnées EXIF** : Toutes les données intégrées dans l'image
- 📁 **Sauvegarde dans la galerie** : Photos accessibles immédiatement
- 📄 **Export texte** : Fichier .txt avec toutes les données détaillées

## 📱 Captures d'écran

*(Ajoutez vos captures d'écran ici)*

## 🏗️ Architecture

Architecture professionnelle avec séparation des responsabilités :

```
lib/
┣ features/
┃ ┣ camera/
┃ ┃ ┗ zoomable_camera_preview.dart
┃ ┗ http/
┃   ┗ localhost.dart
┣ models/
┃ ┣ device_info_data.dart
┃ ┣ orientation_data.dart
┃ ┗ sensor_data.dart
┣ screens/
┃ ┣ camera_screen.dart
┃ ┣ home_screen.dart
┃ ┣ permission_screen.dart
┃ ┣ responsive_scaffold.dart
┃ ┗ splash_screen.dart
┣ services/
┃ ┣ api_service.dart
┃ ┣ camera_service.dart
┃ ┣ dot.env_service.dart
┃ ┣ elevation_service.dart
┃ ┣ location_service.dart
┃ ┣ notification_service.dart
┃ ┣ orientation_service.dart
┃ ┣ permission_service.dart
┃ ┣ sensor_service.dart
┃ ┗ storage_service.dart
┣ utils/
┃ ┗ logger/
┃   ┗ debug_log.dart
┣ widgets/
┃ ┣ camera_button_widget.dart
┃ ┣ crosshair_widget.dart
┃ ┗ sensor_overlay_widget.dart
┗ main.dart

```

## 🚀 Installation

### Prérequis

- Flutter 3.29.3 ou supérieur
- Dart 3.7.2 ou supérieur
- Android Studio / Xcode pour le développement
- Un appareil physique (recommandé pour tester les capteurs)

### Étapes

1. **Cloner le repository**
```bash
git clone https://github.com/alifs-dev/moonpatrol.git
cd moonpatrol
```
```
Renommer le fichier .env.example en .env

mv .env.example .env
```

2. **Installer les dépendances**
```bash
flutter pub get
```

3. **Lancer l'application**
```bash
flutter run
```

## 📦 Dépendances principales

- `camera` - Gestion de la caméra
- `sensors_plus` - Accéléromètre, gyroscope, magnétomètre
- `geolocator` - Localisation GPS
- `native_exif` - Écriture métadonnées EXIF
- `image_gallery_saver` - Sauvegarde dans la galerie
- `battery_plus` - Niveau de batterie
- `device_info_plus` - Informations appareil
- `permission_handler` - Gestion des permissions

## 🔐 Permissions

### Android
- Caméra
- Localisation (fine et grossière)
- Stockage / Galerie photo
- Capteurs de mouvement

### iOS
- Caméra
- Localisation
- Galerie photo
- Capteurs de mouvement

Les permissions sont demandées automatiquement au premier lancement.

## 📖 Utilisation

1. Lancez l'application
2. Autorisez les permissions (caméra, GPS, galerie)
3. Les données des capteurs s'affichent en temps réel
4. Appuyez sur le bouton 📷 pour capturer une photo
5. La photo est sauvegardée dans votre galerie avec toutes les métadonnées

### Accéder aux métadonnées

Les données GPS et capteurs sont écrites dans les métadonnées EXIF de l'image. Vous pouvez les consulter :

- **Sur ordinateur** : `exiftool photo.jpg`
- **Google Photos** : Affiche automatiquement la localisation GPS
- **Propriétés Windows/Mac** : Onglet "Détails"

## 🛠️ Développement

### Structure du code

Le projet suit une architecture propre et modulaire :

- **Services** : Logique métier isolée et réutilisable
- **Models** : Structures de données typées
- **Screens** : Interface utilisateur
- **Widgets** : Composants UI réutilisables

### Ajouter de nouvelles fonctionnalités

1. Créez un nouveau service dans `lib/services/`
2. Importez-le dans l'écran concerné
3. Utilisez le service via son API publique

### Tests

```bash
flutter test
```

## 🐛 Problèmes connus

- **GPS lent** : La première acquisition GPS peut prendre 10-30 secondes à l'extérieur
- **iOS simulator** : Les capteurs ne fonctionnent pas sur simulateur, utilisez un appareil physique
- **Android 13+** : Nécessite des permissions spécifiques pour la galerie photo

## 🤝 Contribution

Les contributions sont les bienvenues ! Pour contribuer :

1. Fork le projet
2. Créez une branche (`git checkout -b feature/AmazingFeature`)
3. Committez vos changements (`git commit -m 'Add AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrez une Pull Request

## 📝 TODO

- [ ] Changer de caméra (avant/arrière)
- [ ] Mode rafale
- [ ] Visualisation des photos prises
- [ ] Export CSV des données capteurs
- [ ] Mode nuit
- [ ] Zoom
- [ ] Historique des photos avec carte

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

## 👨‍💻 Auteur

Créé avec ❤️ par @ali

## 🙏 Remerciements

- Flutter Team pour l'excellent framework
- Contributeurs des packages utilisés
- Communauté Flutter

---

⭐ Si ce projet vous a été utile, n'hésitez pas à lui donner une étoile !
