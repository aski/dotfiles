#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# Change this to the path of your source directory
SOURCE_DIR="$1"
TARGET_DIR="$2"

if [ -z "$SOURCE_DIR" ]; then
    echo "Error: Please provide the source directory path."
    echo "Usage: $0 /path/to/source_dir /path/to/target_dir"
    exit 1
fi

if [ -z "$TARGET_DIR" ]; then
    echo "Error: Please provide the target directory path."
    echo "Usage: $0 /path/to/source_dir /path/to/target_dir"
    exit 1
fi

SOURCE_DIR=$(cd "$SOURCE_DIR" && pwd)
TARGET_DIR=$(cd "$TARGET_DIR" && pwd)

echo "Processing files from: $SOURCE_DIR"
echo "Target directory:      $TARGET_DIR"
echo "------------------------------------------------"

# -path "$SOURCE_DIR/scripts" -prune: Skips the scripts folder only at the root level
# -name ".git" -prune: Skips all .git folders
find "$SOURCE_DIR" -mindepth 1 \
    \( -name ".git" -prune \) -o \
    \( -path "$SOURCE_DIR/scripts" -prune \) -o \
    \( -name "*.md" \) -o \
    -print | while read -r item; do

    # Extra safety checks for the pruned/excluded items
    [ "$item" = "$SOURCE_DIR" ] && continue
    [[ "$item" == *.md ]] && continue

    # Get the relative path from the source directory
    rel_path="${item#$SOURCE_DIR/}"
    
    # Replace "dot_" at the beginning of the path or after any slash
    new_rel_path=$(echo "$rel_path" | sed -E 's/(^|\/)dot_/\/\./g' | sed 's/^\/\././' | sed 's/\/\//\//g')
    
    dest_path="$TARGET_DIR/$new_rel_path"
    
    if [ -d "$item" ]; then
        if [ ! -d "$dest_path" ]; then
            echo "Creating directory: $dest_path"
            mkdir -p "$dest_path"
        fi
    elif [ -f "$item" ]; then
        mkdir -p "$(dirname "$dest_path")"
        echo "Copying file:        $rel_path -> $new_rel_path"
        cp "$item" "$dest_path"
    fi
done

echo "------------------------------------------------"
echo "Operation complete!"
