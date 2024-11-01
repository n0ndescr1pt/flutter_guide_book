создать на firebase проект

```dart
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
	    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    runApp(MyApp());
  }, (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack);
  });
}

```

**В `android/build.gradle`:**
Copy code
```
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:8.0.2'
        classpath 'com.google.gms:google-services:4.3.15'
        classpath 'com.google.firebase:firebase-crashlytics-gradle:2.9.1'
    }
}
```


- **В `android/app/build.gradle`:**
```
apply plugin: 'com.android.application'
apply plugin: 'com.google.gms.google-services'
apply plugin: 'com.google.firebase.crashlytics'

android {
    compileSdkVersion 33

    defaultConfig {
        // Настройки для отладочных сборок
        buildConfigField "boolean", "DEBUG", "true"
    }

    buildTypes {
        debug {
            // Настройки для отладочной сборки
            firebaseCrashlytics {
                nativeSymbolUploadEnabled true
            }
        }
        release {
            // Настройки для релизной сборки
            firebaseCrashlytics {
                nativeSymbolUploadEnabled true
            }
        }
    }
}

dependencies {
    implementation 'com.google.firebase:firebase-crashlytics:18.4.1'
}

```

<application
    ...>
    <meta-data
        android:name="firebase_crashlytics_collection_enabled"
        android:value="true" />
    <meta-data
        android:name="com.google.firebase.crashlytics.SEND_REPORTS_AT_CRASH"
        android:value="true" />
</application>


### 1. **GoogleService-Info.plist**

- **Для iOS:** Файл `GoogleService-Info.plist` содержит настройки конфигурации Firebase для вашего проекта на iOS. Вы должны загрузить этот файл из консоли Firebase и добавить его в ваш проект Xcode.
  
  настройки проекта
