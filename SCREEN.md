SystemChrome.setSystemUIOverlayStyle(
  const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.light,
  ),
);
```

#### **`SystemUiOverlayStyle`**
- Contrôle l'apparence des barres système (haut et bas de l'écran)

#### **Paramètres en détail :**

| Paramètre | Valeur | Explication | Illustration |
|-----------|--------|-------------|--------------|
| `statusBarColor` | `Colors.transparent` | Barre de statut **invisible** (heure, batterie, signal) | ![Barre transparente](#) |
| `statusBarIconBrightness` | `Brightness.light` | Icônes **blanches** (pour fond sombre) | ⚪ 🔋 📶 |
| `systemNavigationBarColor` | `Colors.black` | Barre de navigation **noire** (boutons Android bas d'écran) | ⚫ |
| `systemNavigationBarIconBrightness` | `Brightness.light` | Boutons de navigation **blancs** | ◁ ○ ▢ (en blanc) |

---

## 🎨 **Exemple visuel**

### **Sans cette configuration :**
```
┌─────────────────────┐
│ 🔵 Barre bleue      │ ← Barre de statut visible
│ 12:30  🔋 📶       │
├─────────────────────┤
│                     │
│   Votre contenu     │
│                     │
├─────────────────────┤
│ ⬜ ⬜ ⬜          │ ← Boutons blancs sur fond blanc
└─────────────────────┘
```

### **Avec cette configuration :**
```
┌─────────────────────┐
│ 12:30  🔋 📶       │ ← Barre transparente, icônes blanches
│                     │
│   Votre contenu     │
│   (plein écran)     │
│                     │
│ ◁  ○  ▢           │ ← Barre noire, boutons blancs
└─────────────────────┘