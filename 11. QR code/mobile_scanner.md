#### Установка пакета
```shell
flutter pub add mobile_scanner
```

### Спецификации платформ

#### Android
в файле `[project]/android/gradle.properties` устанавливаем:
```bash
dev.steenbakker.mobile_scanner.useUnbundled=true
```

#### iOS
в файле `[project]/ios/Runner/info.plist` добавляем:
```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to scan QR codes</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs photos access to get QR code from photo library</string>
```

### Пример использования
Пакет для вибраций [[flutter_vibrate]]
```dart
final MobileScannerController controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
  );
  
SizedBox(
	height: MediaQuery.of(context).size.height,
	child: MobileScanner(
	controller: controller,
	onDetect: (capture) {
		Vibrate.vibrate(); //Вибрация на удачный скан 
		final Barcode barcode = capture.barcodes.first;
		
		//barcode.rawValue чтобы получить информацию из qr кода
		//любой способ обработки этих данных
		
		overlayBuilder: (context, constraints) {
			return Container(); //Оверлей qr код экрана
```

- ##### Больше примеров использования [click](https://github.com/juliansteenbakker/mobile_scanner/tree/master/example/lib)
- ##### Официальная документация [click](https://pub.dev/packages/mobile_scanner)

