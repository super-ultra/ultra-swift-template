#!/usr/bin/env bash
set -euo pipefail

OLD_PASCAL="UltraTemplate"
OLD_KEBAB="ultra-template"
OLD_SNAKE="ultra_template"

usage() {
  echo "Usage: $(basename "$0") MyNewProject"
  echo "Example: $(basename "$0") MyNewProject"
}

[[ ${1:-} != "" ]] || { usage; exit 1; }

NEW_PASCAL="$1"

# --- Pascal/Camel -> kebab-case
to_kebab() {
  perl -pe '
    s/::/\//g;
    s/([A-Z]+)([A-Z][a-z])/$1-$2/g;
    s/([a-z\d])([A-Z])/$1-$2/g;
    $_ = lc($_);
  '
}

# --- Pascal/Camel -> snake_case
to_snake() {
  perl -pe '
    s/::/\//g;
    s/([A-Z]+)([A-Z][a-z])/$1_$2/g;
    s/([a-z\d])([A-Z])/$1_$2/g;
    $_ = lc($_);
  '
}

NEW_KEBAB="$(printf '%s' "$NEW_PASCAL" | to_kebab)"
NEW_SNAKE="$(printf '%s' "$NEW_PASCAL" | to_snake)"

echo "Renaming:"
echo "  $OLD_PASCAL -> $NEW_PASCAL"
echo "  $OLD_KEBAB  -> $NEW_KEBAB"
echo "  $OLD_SNAKE  -> $NEW_SNAKE"
echo

# --- mv helper
mv_cmd() {
  if command -v git >/dev/null 2>&1 && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    git mv -f "$1" "$2"
  else
    mv -f "$1" "$2"
  fi
}

prune_expr=(
  -path "*/.git" -o -path "*/.git/*"
  -o -path "*/node_modules" -o -path "*/node_modules/*"
  -o -path "*/build" -o -path "*/build/*"
  -o -path "*/.build" -o -path "*/.build/*"
  -o -path "*/DerivedData" -o -path "*/DerivedData/*"
)

pass=1
while : ; do
  renamed=0
  while IFS= read -r -d '' d; do
    new="$d"
    new="${new//$OLD_PASCAL/$NEW_PASCAL}"
    new="${new//$OLD_KEBAB/$NEW_KEBAB}"
    new="${new//$OLD_SNAKE/$NEW_SNAKE}"
    [[ "$new" == "$d" ]] && continue

    mkdir -p "$(dirname "$new")"
    mv_cmd "$d" "$new"
    echo "mv[d]: $d -> $new"
    renamed=$((renamed+1))
  done < <(
    find . \
      \( "${prune_expr[@]}" \) -prune -o \
      -type d \( -name "*$OLD_PASCAL*" -o -name "*$OLD_KEBAB*" -o -name "*$OLD_SNAKE*" \) \
      -depth -print0
  )
  echo "pass $pass: renamed dirs = $renamed"
  (( renamed == 0 )) && break
  pass=$((pass+1))
done

while IFS= read -r -d '' f; do
  new="$f"
  new="${new//$OLD_PASCAL/$NEW_PASCAL}"
  new="${new//$OLD_KEBAB/$NEW_KEBAB}"
  new="${new//$OLD_SNAKE/$NEW_SNAKE}"
  [[ "$new" == "$f" ]] && continue

  mkdir -p "$(dirname "$new")"
  mv_cmd "$f" "$new"
  echo "mv[f]: $f -> $new"
done < <(
  find . \
    \( "${prune_expr[@]}" \) -prune -o \
    -type f \( -name "*$OLD_PASCAL*" -o -name "*$OLD_KEBAB*" -o -name "*$OLD_SNAKE*" \) \
    -print0
)

while IFS= read -r -d '' f; do
  if grep -Iq . "$f"; then
    perl -0777 -i -pe "
      s/\\Q$OLD_PASCAL\\E/$NEW_PASCAL/g;
      s/\\Q$OLD_KEBAB\\E/$NEW_KEBAB/g;
      s/\\Q$OLD_SNAKE\\E/$NEW_SNAKE/g;
    " "$f"
    echo "edit: $f"
  fi
done < <(
  find . \
    \( "${prune_expr[@]}" \) -prune -o \
    -type f -print0
)

echo
echo "✅ Done."
echo "Check leftovers with:"
echo "  git grep -n \"$OLD_PASCAL\\|$OLD_KEBAB\\|$OLD_SNAKE\" || true"
