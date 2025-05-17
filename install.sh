#!/bin/bash
testmode = true

# Update system
echo "Updating system..."
if testmode == false; then
  sudo pacman -Syu --noconfirm
else
  echo "TESTMODE: sudo pacman -Syu --noconfirm"
fi

# Install packages
echo "Installing base packages from packages.txt..."
if testmode == false; then
  xargs -a packages.txt sudo pacman -S --noconfirm
else
  echo "TESTMODE: xargs -a packages.txt sudo pacman -S --noconfirm"
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

# Restore configs
echo "Restoring dotfiles..."
if testmode == false; then
  cp config/zsh/.zshrc ~/.zshrc
  cp config/tmux/.tmux.conf ~/.tmux.conf
  mkdir -p ~/.config/hypr
  cp -r config/hypr/* ~/.config/hypr/
else
  echo "TESTMODE: Copy config dotfiles"
fi

# Run extra setup commands
echo "Running additional setup scripts..."
bash scripts/setup_zsh.sh
bash scripts/setup_tmux.sh

echo 'Bootstrap complete.'
