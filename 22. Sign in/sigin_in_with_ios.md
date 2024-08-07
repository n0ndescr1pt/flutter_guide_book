```shell
$ flutter pub add sign_in_with_apple
```


https://www.back4app.com/docs/flutter/parse-sdk/users/flutter-sign-in-with-apple
пушишь в аппле девелопер даешь разрешение на вход в xcode тоже джаешь разрешение на sign in и 




```dart
Future<void> _handleSignIn() async {
	final credential = await SignInWithApple.getAppleIDCredential(
		scopes: [
			AppleIDAuthorizationScopes.email,
			AppleIDAuthorizationScopes.fullName,
		],
	);
	print(credential);
	
	final parseResponse = await ParseUser.loginWith(
		'apple', apple(credential.identityToken!, credential.userIdentifier!));
		
	print(parseResponse.result);
	
}
```