# 📱 Guide des Notifications MoonPatrol

## ✅ Notifications implémentées

### 1️⃣ **GPS acquis**
```
📍 GPS acquis
Position GPS disponible
```
**Quand ?** : Première fois que le GPS obtient un fix

### 2️⃣ **Altitude API reçue**
```
🌍 Altitude API
Altitude précise : 145.2 m
```
**Quand ?** : L'altitude API est récupérée avec succès

### 3️⃣ **Photo sauvegardée**
```
📸 Photo enregistrée
Photo 3 sauvegardée avec GPS et altitude API
```
**Quand ?** : Après chaque photo capturée

### 4️⃣ **Envoi API réussi**
```
✅ Données envoyées
Photo et capteurs envoyés au serveur
```
**Quand ?** : Les données sont envoyées au serveur avec succès

### 5️⃣ **Erreur API**
```
⚠️ Erreur serveur
Impossible d'envoyer les données (photo sauvegardée localement)
```
**Quand ?** : L'envoi au serveur échoue (mais la photo est sauvegardée)

## 🎯 Workflow des notifications

```
1. Ouverture app
   ↓
2. 📍 GPS acquis
   ↓
3. 🌍 Altitude API (145.2 m)
   ↓
4. Utilisateur prend photo
   ↓
5. 📸 Photo 1 sauvegardée avec GPS et altitude API
   ↓
6. (en arrière-plan)
   ├─ ✅ Données envoyées (si succès)
   └─ ⚠️ Erreur serveur (si échec)
```

## 🔧 Personnalisation

### Modifier le texte d'une notification

Éditer `lib/services/notification_service.dart` :

```dart
Future<void> notifyPhotoSaved({...}) async {
  await _showNotification(
    id: 1,
    title: '📸 Votre titre',
    body: 'Votre message personnalisé',
    payload: 'photo_saved',
  );
}
```

### Ajouter une nouvelle notification

```dart
Future<void> notifyCustom() async {
  await _showNotification(
    id: 20,  // ID unique
    title: '🎯 Mon titre',
    body: 'Mon message',
    payload: 'custom_action',
  );
}
```

### Notification de progression

Pour afficher une barre de progression (mode rafale par exemple) :

```dart
// Prendre 10 photos
for (int i = 1; i <= 10; i++) {
  await _takePicture();
  await _notificationService.notifyPhotoProgress(
    current: i,
    total: 10,
  );
}
```

## 🎨 Canaux de notifications Android

Deux canaux sont configurés :

### 1. Canal principal (`moonpatrol_channel`)
- **Importance** : Haute
- **Son** : Oui
- **Vibration** : Oui
- **Usage** : Notifications importantes (photo sauvegardée, GPS, etc.)

### 2. Canal progression (`moonpatrol_progress_channel`)
- **Importance** : Basse
- **Son** : Non
- **Vibration** : Non
- **Usage** : Barres de progression

## 🔕 Désactiver les notifications

### Pour l'utilisateur

**Android** :
1. Paramètres → Apps → MoonPatrol
2. Notifications → Désactiver

**iOS** :
1. Réglages → Notifications → MoonPatrol
2. Autoriser les notifications → Désactiver

### Dans le code

Commenter l'initialisation dans `main.dart` :

```dart
// await NotificationService().initialize();
// await NotificationService().requestPermissions();
```

Ou conditionner selon les préférences utilisateur :

```dart
if (userPreferences.notificationsEnabled) {
  await NotificationService().initialize();
}
```

## 🧪 Test des notifications

### Test manuel

```dart
// Dans CameraScreen, ajouter un bouton temporaire
FloatingActionButton(
  onPressed: () async {
    await NotificationService().notifyPhotoSaved(
      photoCount: 999,
      hasGps: true,
      hasElevationApi: true,
    );
  },
  child: Icon(Icons.notifications),
)
```

### Vérifier les logs

```bash
flutter run
```

Dans les logs, vous devriez voir :
```
✅ Service de notifications initialisé
📱 Notification tapped: photo_saved
```

## 📊 Permissions

### Android
- **Android < 13** : Pas de permission requise
- **Android 13+** : Permission `POST_NOTIFICATIONS` automatiquement demandée

### iOS
- Permission demandée au premier lancement
- L'utilisateur peut accepter/refuser

## 🎯 Actions sur tap (futur)

Pour ajouter des actions quand l'utilisateur tape sur une notification :

```dart
void _onNotificationTap(NotificationResponse response) {
  switch (response.payload) {
    case 'photo_saved':
      // Ouvrir la galerie
      break;
    case 'api_error':
      // Réessayer l'envoi
      break;
  }
}
```

## 💡 Idées d'améliorations

- [ ] Notification avec miniature de la photo
- [ ] Bouton "Réessayer" sur erreur API
- [ ] Notification quotidienne de statistiques
- [ ] Rappel si GPS désactivé
- [ ] Badge avec nombre de photos non envoyées

## 🚨 Troubleshooting

### Notifications ne s'affichent pas

**Android** :
1. Vérifier la permission dans AndroidManifest.xml
2. Vérifier les paramètres de notification de l'app
3. Mode Ne pas déranger activé ?

**iOS** :
1. Permission accordée dans les réglages ?
2. Redémarrer l'app

### Notifications silencieuses

Vérifier l'importance du canal :
```dart
importance: Importance.high,  // Au lieu de .low
```

---

🎉 Les notifications sont maintenant actives !
