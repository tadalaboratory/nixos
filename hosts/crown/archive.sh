TARGET_DIRS=("Downloads" "Desktop")

for USER_DIR in /home/*; do
  for TARGET in "${TARGET_DIRS[@]}"; do
    TARGET_PATH="$USER_DIR/$TARGET"
    
    if [ -d "$TARGET_PATH" ]; then
      SOURCE_DIR="$TARGET_PATH"
      
      if compgen -G "$SOURCE_DIR/*" > /dev/null; then
        DEST_DIR="$SOURCE_DIR/archived/$(date +'%Y')/$(date +'%m')/$(date +'%d')"
        
        mkdir -p "$DEST_DIR"
        chown -R --reference="$SOURCE_DIR" "$SOURCE_DIR/archived"
        chmod -R --reference="$SOURCE_DIR" "$SOURCE_DIR/archived"
        
        for ITEM in "$SOURCE_DIR"/*; do
          if [ -e "$ITEM" ] && [ "$ITEM" != "$SOURCE_DIR/archived" ]; then
            mv "$ITEM" "$DEST_DIR"
          fi
        done
      fi
    fi
  done
done
