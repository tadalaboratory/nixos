nix-collect-garbage -d
nix-store --gc
nix-env --delete-generations old
rm -rf /tmp/*
rm -rf /home/*/.cache
rm -rf /home/**/*.backup
rm -rf /home/**/*.back
rm -rf /home/**/*.bak
