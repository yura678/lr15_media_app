# LR15 — Медіа (камера / галерея)

Застосунок-галерея: зйомка фото камерою або вибір із галереї, збереження у
постійне сховище та перегляд сіткою.

## Можливості

**Обов'язкова частина:**
- Вибір джерела через `BottomSheet` (Камера / Галерея).
- Зйомка камерою та вибір із галереї (`image_picker`).
- Запит і обробка дозволів (`permission_handler`).
- Збереження фото у каталог документів застосунку (`path_provider`).
- Відображення сіткою (`GridView`), індикатор завантаження, обробка
  скасування та помилок.

**Самостійне виконання:**
- Повноекранний перегляд із Hero-анімацією та масштабуванням (`InteractiveViewer`).
- Видалення фото (long-press на мініатюрі).
- Відновлення збережених фото при запуску.

## Структура

```
lib/
├── main.dart
├── services/
│   ├── permission_service.dart     запит дозволів камери/галереї
│   └── image_storage_service.dart  збереження / завантаження / видалення
└── screens/
    ├── home_screen.dart            галерея, BottomSheet, камера/галерея
    └── image_detail_screen.dart    повноекранний перегляд (Hero)
```

## Залежності

- `image_picker: ^1.1.2`
- `permission_handler: ^11.3.1`
- `path_provider: ^2.1.4`
- `path: ^1.9.0`

## Дозволи (для реального пристрою)

- **Android** — `android/app/src/main/AndroidManifest.xml`:
  ```xml
  <uses-permission android:name="android.permission.CAMERA"/>
  ```
- **iOS** — `ios/Runner/Info.plist`:
  `NSCameraUsageDescription`, `NSPhotoLibraryUsageDescription`.

## Запуск

```bash
flutter pub get
flutter run
```

Робота камери/галереї перевіряється на пристрої або емуляторі з наданими
дозволами.

## Перевірка

```bash
flutter analyze   # No issues found!
flutter test      # All tests passed!
```
