На Windows Dart SDK можно обновить **в 3 разных случаях** — в зависимости от того, как ты его ставил:

---

## ✅ 1. Dart идёт вместе с Flutter — **ОБНОВЛЕНИЕ через Flutter**

> 💡 Это самый частый способ. Dart встроен в Flutter и обновляется вместе с ним.

### 🔧 Обновление:

Открой `cmd`, PowerShell или Git Bash:

```bash
flutter upgrade
```

### ✅ Проверка версии:

```bash
dart --version
flutter --version
```

---

## ✅ 2. Dart установлен через **Chocolatey** (если ты ставил отдельно Dart)

### 🔧 Обновление:

Открой PowerShell или `cmd` от имени администратора:

```bash
choco upgrade dart-sdk
```

> ❗ Если Dart не установлен через Chocolatey, эта команда не сработает.

---

## ✅ 3. Dart установлен вручную из архива

Если ты скачивал Dart SDK с [https://dart.dev/get-dart](https://dart.dev/get-dart) и распаковывал его сам:

### 🔧 Тогда:

1. Удали старую папку SDK (например, `C:\dart`)
    
2. Скачай свежую версию Dart SDK отсюда: 👉 [https://dart.dev/get-dart](https://dart.dev/get-dart)
    
3. Распакуй в ту же папку (`C:\dart`)
    
4. Убедись, что в `PATH` прописан путь:
    
    ```
    C:\dart\dart-sdk\bin
    ```
    

### ✅ Проверка:

```bash
dart --version
```

---


```bash
where dart
```

