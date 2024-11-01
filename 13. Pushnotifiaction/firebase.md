с помощью fluttercli конфигурируем 
для андроида в androidManifest.xml добавляем
```xml
	</activity>
	<meta-data
	android:name="com.google.firebase.messaging.default_notification_channel_id"
	android:value="high_importance_channel" />
	<!-- Don't delete the meta-data below.
	This used by the Flutter tool to generate GeneratedPluginRegistrant.java -->
	<meta-data
	android:name="flutterEmbedding"
	android:value="2" />
</application>
```

для ios в Podfile добавляем строку (потому что фаербейс не может работать с мейшей версией ios)
`platform :ios, '13.0'`

MainApp()
```dart
void main() async {
	WidgetsFlutterBinding.ensureInitialized();
	await Firebase.initializeApp(
	options: DefaultFirebaseOptions.currentPlatform,
		);
	await FirebaseApi().initNotifications();
	runApp(const MainApp());
}
```


получение данных с сообщения 
```dart
Widget build(BuildContext context) {
	final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;
	return Scaffold(
		appBar: AppBar(),
		body: Center(
		child: Column(
		children: [
			Text(message.toString()),
			Text(message.notification.toString()),
			Text(message.data.toString())
			],
			),
		),
	);
}
```

реализация![[firebase_api.dart]]