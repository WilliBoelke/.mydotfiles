#!/bin/bash
# Install Ember SDDM theme

THEME_DIR=/usr/share/sddm/themes/Ember
DOTFILES_DIR="$(dirname "$(realpath "$0")")"

echo "Installing Ember SDDM theme..."
sudo mkdir -p $THEME_DIR
sudo cp -r $DOTFILES_DIR/Ember/* $THEME_DIR/
sudo cp $DOTFILES_DIR/../wallpapers/1.png $THEME_DIR/wallpaper.png

echo "Setting Ember as active SDDM theme..."
sudo mkdir -p /etc/sddm.conf.d
sudo bash -c 'cat > /etc/sddm.conf.d/theme.conf << EOF
[Theme]
Current=Ember
EOF'

echo "Done."
