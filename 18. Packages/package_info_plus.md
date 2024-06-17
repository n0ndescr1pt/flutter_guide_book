#### Installing 
```shell
flutter pub add package_info_plus
```

#### Configuration
```dart
// Be sure to add this line if `PackageInfo.fromPlatform()` is called before runApp()
WidgetsFlutterBinding.ensureInitialized(); //first
runApp(); //second
```

#### Usage
```dart
PackageInfo packageInfo = await PackageInfo.fromPlatform();

String appName = packageInfo.appName;
String packageName = packageInfo.packageName;
String version = packageInfo.version;
String buildNumber = packageInfo.buildNumber;
```