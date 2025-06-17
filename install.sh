#!/bin/bash
testmode = true

# Update system
echo "Updating system..."
if testmode == false; then
  sudo pacman -Syu --noconfirm
else
  echo "TESTMODE: sudo pacman -Syu --noconfirm"
fi


# NVIDIA driver detection and install choice
if lspci | grep -i nvidia; then
  gpu_name=$(lspci | grep -i nvidia)
  echo "Detected NVIDIA GPU: $gpu_name"

  if echo "$gpu_name" | grep -qE "AD10|5080|5090|50[0-9]{2}"; then
    if testmode == false; then
      sudo pacman -S --noconfirm nvidia-open nvidia-utils nvidia-settings egl-wayland
    else
      echo "TESTMODE: Would install: nvidia-open, nvidia-utils, nvidia-settings, egl-wayland"
    fi
  else
    if testmode == false; then  
      sudo pacman -S --noconfirm nvidia nvidia-utils nvidia-settings egl-wayland
    else
      echo "TESTMODE: Would install: nvidia, nvidia-utils, nvidia-settings, egl-wayland"
    fi
  fi
else # This wont run right now...
  echo "No NVIDIA GPU detected."
fi


# Install packages
echo "Installing base packages from packages.txt..."
if testmode == false; then
  xargs -a packages.txt sudo pacman -S --noconfirm
else
  echo "TESTMODE: xargs -a packages.txt sudo pacman -S --noconfirm"
fi


# Install fonts
echo "Installing font packages from fonts.txt..."
if testmode == false; then
  xargs -a fonts.txt sudo pacman -S --noconfirm
else
  echo "TESTMODE: xargs -a fonts.txt sudo pacman -S --noconfirm"
fi



# Restore configs
echo "Restoring dotfiles..."
if testmode == false; then
  cp config/zsh/.zshrc ~/.zshrc
  cp -r config/waybar/ ~/.config/
  cp -r config/tmux/ ~/.config/
  cp -r config/hypr/ ~/.config/
  # nvim setup
  cp -r config/nvim/init.lua ~/.config/nvim/
  cp -r config/nvim/lua/ ~/.config/nvim/
  #TODO:add the nvim config copies, can't do the whole folder since it includes a git repo. should have the nvim/init.lua and the nvim/lua/custom/plugins/init.lua
else
  echo "TESTMODE: Copy config dotfiles"
fi

# Run extra setup commands
echo "Running additional setup scripts..."
bash scripts/setup_zsh.sh
#TODO:set up tmux import env so you can run reload-env
bash scripts/setup_tmux.sh

# Setup symbolic links
TARGET = "$HOME/.local/bin/reload-env"
SOURCE = "$HOME/.config/hypr/scripts/reload-env.sh"

mkdir -p "$HOME/.local/bin/"

  # Create symlink
ln -s "$SOURCE" "$TARGET"

echo 'Symbolic link Created for reload-env'

echo 'Bootstrap complete.'

#TODO:figure out how to install yay with script
#TODO:figure out yay packages and create a yaypackages.txt
