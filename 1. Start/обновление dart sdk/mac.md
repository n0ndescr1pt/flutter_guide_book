
---

## ✅ 1. Если Dart установлен через Flutter (стандартный способ)

> Dart идёт **встроенным в Flutter**, и обновляется вместе с ним.

### 🔧 Обновление:

```bash
flutter upgrade
```

✅ После этого Dart тоже обновится. Проверить:

```bash
dart --version
```

---

## ✅ 2. Если Dart установлен отдельно через `brew`

### Проверка:

```bash
brew list dart
```

### Обновление:

```bash
brew upgrade dart
```
если не получилось:
```bash
brew tap dart-lang/dart
```

👉 Проверка:

```bash
dart --version
```

---

## ✅ 3. Если Dart установлен вручную (скачивал `.zip` с сайта)

В этом случае:

### Удалить старую версию:

```bash
sudo rm -rf /usr/local/lib/dart
```

### Скачать новую:

1. Перейди на [https://dart.dev/get-dart](https://dart.dev/get-dart)
    
2. Скачай .zip для macOS
    
3. Распакуй и перемести в `/usr/local/lib/dart`
    
4. Обнови `PATH`, если нужно:
    

```bash
export PATH="$PATH:/usr/local/lib/dart/bin"
```

---

## 🔁 Проверка после обновления:

```bash
dart --version
```

---

Если скажешь, каким способом у тебя установлен Dart, я подскажу точно под твой вариант.