cd /Users/aleksandrsherbakov/Documents/Obsidian\ Vault/flutter_guide_book

if [ ! -d ".git" ]; then
  echo "Not a git repository. Exiting."
  exit 1
fi

git add .
git commit -m "auto push"
git push gitlab main

exit;