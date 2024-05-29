cd /Users/aleksandrsherbakov/Documents/Obsidian\ Vault/flutter_guide_book

# Проверка, что мы находимся в git-репозитории
if [ ! -d ".git" ]; then
  echo "Not a git repository. Exiting."
  exit 1
fi

# Выполнить git-команды
git add .
git commit -m "auto push"
git push gitlab main

exit