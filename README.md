# test1_appgardienbut_fabrice

Application Flutter (mobile) utilisant notamment **Firebase** (authentification + base de données Firestore).

## Prérequis

- Flutter installé et configuré (SDK + toolchain iOS/Android)
- Un device ou un émulateur

Commandes utiles pour vérifier l’environnement :

```bash
flutter --version
flutter doctor -v
flutter devices
```

## Récupérer le projet depuis GitHub

```bash
git clone <URL_DU_REPO_GITHUB>
cd test2_appgarage_fabrice
```

## Installer les dépendances

```bash
flutter pub get
```

## Lancer l’application (dev)

Sur un device/émulateur connecté :

```bash
flutter run
```

Si plusieurs devices sont disponibles :

```bash
flutter devices
flutter run -d <device_id>
```

## Commandes Flutter utiles

```bash
# Hot restart / reload: depuis le terminal flutter run (r / R)

# Nettoyer et ré-installer les dépendances
flutter clean
flutter pub get

# Analyse (lints)
flutter analyze

# Tests
flutter test

# Formatage
dart format .
```

## Build (release)

### Android (APK)

```bash
flutter build apk --release
```

### Android (AAB - Play Store)

```bash
flutter build appbundle --release
```

### iOS (nécessite macOS + Xcode)

```bash
flutter build ios --release
```

## Rôle de l’app

Ce projet est une application mobile Flutter connectée à Firebase, destinée à gérer un flux applicatif autour d’un “garage” (ex. comptes utilisateurs, données stockées dans Firestore, navigation UI).

## Création

- **Date de création (1er commit Git)**: 2026-02-18
- **Auteur**: Fabrice (Git: LeFab70)
