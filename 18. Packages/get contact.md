ios 
https://pub.dev/packages/flutter_contacts

![[Pasted image 20250127010251.png]]
не забыть в подфайле прописать

Больше подводных камней нет, он достаточно простой

```dart
 if (!await FlutterContacts.requestPermission(readonly: true)) return;

  List<Contact> contacts =
      await FlutterContacts.getContacts(withProperties: true);
```
 
