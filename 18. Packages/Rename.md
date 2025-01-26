You can easily do this with [rename](https://pub.dev/packages/rename) package, It helps you to change your Flutter project's **AppName** and **BundleId** for any platform you want.

- To install the package run the following command:

```dart
flutter pub global activate rename
```

- To rename the App, use the following command:

```dart
rename setAppName --targets ios,android,macos,windows,linux,web --value "Your App Name"
```