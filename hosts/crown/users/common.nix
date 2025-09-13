{
  pkgs,
  lib,
  username,
}:
let
  recursiveMerge =
    attrSet1: attrSet2:
    let
      keys = lib.lists.unique (builtins.attrNames attrSet1 ++ builtins.attrNames attrSet2);
    in
    builtins.listToAttrs (
      map (
        key:
        let
          val1 = if builtins.hasAttr key attrSet1 then attrSet1.${key} else null;
          val2 = if builtins.hasAttr key attrSet2 then attrSet2.${key} else null;
          mergedValue =
            if builtins.isAttrs val1 && builtins.isAttrs val2 then
              recursiveMerge val1 val2
            else if builtins.isList val1 && builtins.isList val2 then
              val1 ++ val2
            else if val2 != null then
              val2
            else
              val1;
        in
        {
          name = key;
          value = mergedValue;
        }
      ) keys
    );
in
{
  recursiveMerge = recursiveMerge;
  user = {
    isNormalUser = true;
    shell = pkgs.bash;
  };
  home =
    { pkgs, lib }:
    {
      home = {
        username = "${username}";
        homeDirectory = "/home/${username}";
        stateVersion = "25.05";
        packages = with pkgs; [
          slack
          vscode
          gnomeExtensions.appindicator
          gnomeExtensions.dash-to-dock
          gnomeExtensions.kimpanel
          kitty
          alacritty
          wezterm
          tilix
          gnome-tweaks
          gnome-extension-manager
          dconf-editor
          gnome-disk-utility
          baobab
          sushi
          seahorse
          google-chrome
          discord
          signal-desktop
          telegram-desktop
          zoom-us
          thunderbird-bin
          spotify
          obsidian
          notion
          logseq
          joplin-desktop
          libreoffice-fresh
          mpv
          vlc
          gimp
          inkscape
          pinta
          remmina
          flameshot
          copyq
          rclone-browser
          qbittorrent
          scrcpy
          android-tools
          meld
          filezilla
          obs-studio
          peek
        ];
        sessionVariables = {
          GTK_IM_MODULE = "fcitx";
          QT_IM_MODULE = "fcitx";
          XMODIFIERS = "@im=fcitx";
        };
      };
      xdg = {
        enable = true;
        userDirs = {
          enable = true;
          createDirectories = true;
          desktop = "Desktop";
          documents = "Documents";
          download = "Downloads";
          music = "Music";
          pictures = "Pictures";
          publicShare = "Public";
          templates = "Templates";
          videos = "Videos";
        };
        desktopEntries = {
          "fish" = {
            name = "Fish";
            noDisplay = true;
          };
          "nixos-manual" = {
            name = "NixOS Manual";
            noDisplay = true;
          };
          "cups" = {
            name = "CUPS";
            noDisplay = true;
          };
          "gnome-printers-panel.desktop" = {
            name = "Printers";
            noDisplay = true;
          };
          "fcitx5-configtool" = {
            name = "Fcitx5 Config Tool";
            noDisplay = true;
          };
          "fcitx5-wayland-launcher" = {
            name = "Fcitx5 Wayland Launcher";
            noDisplay = true;
          };
          "kcm_fcitx5" = {
            name = "Fcitx5 KDE Config Module";
            noDisplay = true;
          };
          "org.fcitx.Fcitx5" = {
            name = "Fcitx5";
            noDisplay = true;
          };
          "org.fcitx.fcitx5-config-qt" = {
            name = "Fcitx5 Config Qt";
            noDisplay = true;
          };
          "org.fcitx.fcitx5-migrator" = {
            name = "Fcitx5 Migrator";
            noDisplay = true;
          };
          "org.fcitx.fcitx5-qt5-gui-wrapper" = {
            name = "Fcitx5 Qt5 GUI Wrapper";
            noDisplay = true;
          };
          "org.fcitx.fcitx5-qt6-gui-wrapper" = {
            name = "Fcitx5 Qt6 GUI Wrapper";
            noDisplay = true;
          };
        };
        configFile = {
          "fcitx5/profile".text = ''
            [Groups/0]
            Name=デフォルト
            Default Layout=jp
            DefaultIM=mozc

            [Groups/0/Items/0]
            Name=keyboard-jp
            Layout=

            [Groups/0/Items/1]
            Name=mozc
            Layout=

            [GroupOrder]
            0=デフォルト
          '';
        };
      };
      programs = {
        firefox = {
          enable = true;
          package = pkgs.firefox-bin;
          profiles = {
            default = {
              settings = {
                "extensions.autoDisableScopes" = 0;
                "browser.download.folderList" = 2;
                "browser.download.dir" = "/home/${username}/Downloads";
                "browser.download.lastDir" = "/home/${username}/Downloads";
              };
            };
          };
        };
      };
      gtk = {
        enable = true;
        gtk3.extraConfig = {
          Settings = ''
            gtk-application-prefer-dark-theme=1
          '';
        };
        gtk4.extraConfig = {
          gtk-cursor-blink = false;
          gtk-recent-files-limit = 20;
          Settings = ''
            gtk-application-prefer-dark-theme=1
          '';
        };
      };
      dconf.settings = {
        "org/gnome/shell" = {
          favorite-apps = [
            "org.gnome.Nautilus.desktop"
            "firefox.desktop"
            "slack.desktop"
            "org.gnome.TextEditor.desktop"
            "org.gnome.Console.desktop"
            "code.desktop"
          ];
          enabled-extensions = [
            "appindicatorsupport@rgcjonas.gmail.com"
            "dash-to-dock@micxgx.gmail.com"
            "kimpanel@kde.org"
          ];
          last-selected-power-profile = "performance";
        };
        "org/gnome/shell/extensions/dash-to-dock" = {
          dock-fixed = true;
          dash-max-icon-size = 42;
          custom-theme-shrink = false;
          extend-height = false;
          show-apps-at-top = true;
          apply-custom-theme = true;
          show-mounts = false;
          show-trash = false;
        };
        "org/gnome/desktop/interface" = {
          enable-hot-corners = false;
          color-scheme = "prefer-dark";
        };
        "org/gnome/desktop/session" = {
          idle-delay = lib.hm.gvariant.mkUint32 0;
        };
        "org/gnome/desktop/screensaver" = {
          lock-enabled = false;
        };
        "org/gnome/desktop/peripherals/keyboard" = {
          repeat-interval = lib.hm.gvariant.mkUint32 20;
          delay = lib.hm.gvariant.mkUint32 230;
        };
        "org/gnome/desktop/wm/preferences" = {
          num-workspaces = 1;
          workspace-names = [ "Main" ];
          button-layout = ":minimize,maximize,close";
        };
      };
    };
}
