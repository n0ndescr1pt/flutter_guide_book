Команда

```bash
git rm --cached `git ls-files -i --exclude-from=.gitignore` 
```

имеет проблемы с пробелами в названиях.

Самый простой путь - удалить из кэша ВСЕ файлы, и добавить заново с учетом gitignore. на все про все 2 команды.

```erlang
git rm -rf --cached .
git add .
```

потом закоммитить:

```sql
git commit -m "fix gitignore"
```