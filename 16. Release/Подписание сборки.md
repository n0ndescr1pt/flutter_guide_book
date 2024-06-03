#### 1. Генерируем keystore файл.

windows
```
keytool -genkey -v -keystore upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

linux/mac
```
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA \ -keysize 2048 -validity 10000 -alias upload
```

#### 2. Создаем файл `key.properties`
`[project]/android/key.properties` (все без кавычек)
```
storePassword=<password-from-previous-step>
keyPassword=<password-from-previous-step>
keyAlias=upload
storeFile=<keystore-file-location>
```

#### 3. Редактируем gradle
`[project]/android/app/build.gradle` 
```xml
plugins {
	...
}
```
```
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
	keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
	}
```
```xml
android {
 ...
}
```

```xml
android {
	//...
```
```
	signingConfigs {
		release {
			keyAlias keystoreProperties['keyAlias']
			keyPassword keystoreProperties['keyPassword']
			storeFile keystoreProperties['storeFile'] ?
			file(keystoreProperties['storeFile']) : null
			storePassword keystoreProperties['storePassword']
		}
	}
	buildTypes {
		release {
			signingConfig signingConfigs.release
		}
	}
```
```xml
}
```

#### 5. Билд
`flutter build apk --release`
`flutter build appbundle --release`



если по какой то причине гугл консоль не принимает подписанное апк нужно поменять `applicationId "com.example.name"` на то которое в гугл консоли

Официальная документация [cick](https://docs.flutter.dev/deployment/android)
