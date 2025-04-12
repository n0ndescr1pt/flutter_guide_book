https://appmetrica.yandex.ru/docs/ru/common/quick-start

```
flutter pub get appmetrica_plugin
```


```dart
void main() {
AppMetrica.activate(const AppMetricaConfig(appMetricaKey));
}
```

```dart
AppMetrica.reportEvent('My first AppMetrica event!');

AppMetrica.reportEventWithMap('OpenFilm', {
	"filmName": film.nameRu ?? "",
	"filmId": film.kinopoiskId
});
```