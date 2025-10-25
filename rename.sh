#!/usr/bin/env bash
set -euo pipefail

OLD_PASCAL="UltraTemplate"
OLD_KEBAB="ultra-template"

usage() {
  cat <<EOF
Usage: $(basename "$0") NewNamePascalCase
Example: $(basename "$0") WalletCreator
EOF
}

if [[ ${1:-} == "" ]]; then
  usage
  exit 1
fi

NEW_PASCAL="$1"

# Функция: из Pascal/Camel -> kebab-case
to_kebab() {
  perl -pe '
    s/::/\//g;
    s/([A-Z]+)([A-Z][a-z])/$1-$2/g;
    s/([a-z\d])([A-Z])/$1-$2/g;
    $_ = lc($_);
  '
}
NEW_KEBAB="$(printf '%s' "$NEW_PASCAL" | to_kebab)"

echo "Renaming:"
echo "  $OLD_PASCAL -> $NEW_PASCAL"
echo "  $OLD_KEBAB  -> $NEW_KEBAB"
echo

while IFS= read -r -d '' path; do
  new="$path"
  new="${new//$OLD_PASCAL/$NEW_PASCAL}"
  new="${new//$OLD_KEBAB/$NEW_KEBAB}"
  if [[ "$new" != "$path" ]]; then
    mkdir -p "$(dirname "$new")"
    mv "$path" "$new"
    echo "mv: $path -> $new"
  fi
done < <(
  find . -depth \( -name "*$OLD_PASCAL*" -o -name "*$OLD_KEBAB*" \) \
    -not -path "*/.git/*" \
    -not -path "*/build/*" \
    -not -path "*/.build/*" \
    -print0
)

while IFS= read -r -d '' f; do
  if grep -Iq . "$f"; then
    perl -0777 -i -pe "
      s/\\Q$OLD_PASCAL\\E/$NEW_PASCAL/g;
      s/\\Q$OLD_KEBAB\\E/$NEW_KEBAB/g;
    " "$f"
    echo "edit: $f"
  fi
done < <(
  find . -type f \
    -not -path "*/.git/*" \
    -not -path "*/build/*" \
    -not -path "*/.build/*" \
    -print0
)

echo
echo "✅ Done. Replaced names and contents."
