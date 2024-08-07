```shell
 $ flutter pub add google_sign_in
```


android back4app
еще нужно подписать приложение получить sha1 у ключа и закинуть в credential в гугл коносль

в папке андроид в терминале (sha1)
./gradlew signingReport        

создаем OAuth consent screen
и credentials для андроида и веб сервера
https://console.cloud.google.com/

https://www.back4app.com/docs/platform/sign-in-with-google



ios 
https://pub.dev/packages/google_sign_in_ios#ios-integration

создаем ios app в гугл консоли

в info.plist
```swift
<key>GIDClientID</key>
<string>"CLIENT ID IOS"</string>
<key>GIDServerClientID</key>
<string>"CLIENT ID IOS"</string>
<key>CFBundleURLTypes</key>
<array>
	<dict>
		<key>CFBundleTypeRole</key>
		<string>Editor</string>
		<key>CFBundleURLSchemes</key>
		<array>
		<string>"REVERSE CLIENT ID IOS"</string>
		</array>
	</dict>
</array>
```


```dart
 Future<void> _handleSignIn() async {
try {
	final GoogleSignIn googleSignIn = GoogleSignIn(
	serverClientId: 'web_client_id',
	scopes: [
		'email',
		],
	);
	final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
	
	final GoogleSignInAuthentication googleAuth =
	await googleUser!.authentication;

	final String accessToken = googleAuth.accessToken!;

	final String idToken = googleAuth.idToken!;

	final ParseResponse response = await ParseUser.loginWith(
		'google',
		google(
			accessToken,
			googleUser.id,
			idToken,
		),
	);

	if (response.success) {

		ParseUser user = response.result;
		print('User logged in: ${user.username} ${user.password}');
	} else {
		 print('Error: ${response.error!.message}');
		}
	} catch (error) {
		print(error);
	}
}
```
