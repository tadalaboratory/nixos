{
  pkgs,
  lib,
  ...
}:
let
  username = builtins.baseNameOf ./.;
  password = "$6$7AQG5ll4cxNl1oiy$zCF86/Lz/6gsn1I7TOrDlyNdwMuIwywNCr1upvLbCouLOFl1UAKVPTWc3xcPEGo39/1uBc0l/q6PceIz9ieaA/";
  common = import ../common.nix {
    inherit pkgs lib username;
  };
in
{
  users.users."${username}" = common.recursiveMerge common.user {
    extraGroups = [
      "wheel"
      "networkmanager"
      "projecthazard"
    ];
    shell = pkgs.fish;
    hashedPassword = "${password}";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJP/IIjdhZUgCqXnIZRf7MSNO8IYzSEBRbgC2tB1hTnw"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMDhOFKRBXFzQG+D2la6Am7Ef1JEs5I4DlefV61p06yO"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKtRkxaN3glqSMkTE4hOnz+QiDmKArNviuQBT7huyaSp"
    ];
  };

  home-manager.users."${username}" =
    { pkgs, lib, ... }:
    common.recursiveMerge (common.home { inherit pkgs lib; }) (
      let
        g = lib.hm.gvariant;
        aplEntry =
          name: pos:
          g.mkDictionaryEntry [
            (g.mkString name)
            (g.mkVariant [
              (g.mkDictionaryEntry [
                (g.mkString "position")
                (g.mkVariant (g.mkUint32 pos))
              ])
            ])
          ];
      in
      {
        home = {
          packages = with pkgs; [
            gnomeExtensions.blur-my-shell
            gnomeExtensions.user-themes
            dbeaver-bin
            insomnia
            lazygit
            lazydocker
            wireshark
            mitmproxy
            burpsuite
            sqlmap
            hydra
            feroxbuster
            amass
            subfinder
            assetfinder
            httpx
            naabu
            dnsx
            nuclei
            masscan
            zmap
            zgrab2
            gowitness
            bettercap
            aircrack-ng
            hashcat
            hashcat-utils
            john
            johnny
            yara
            ghidra
            radare2
            rizin
            iaito
            cutter
            frida-tools
            binwalk
            apktool
            jadx
            ghex
            hexyl
            rr
            pwninit
            gef
            radamsa
            sleuthkit
            testdisk
            foremost
            scalpel
            volatility3
            steghide
            mat2
            tcpreplay
            trivy
            grype
            syft
            dockle
          ];
          sessionVariables = {
            GTK_IM_MODULE = "fcitx";
            QT_IM_MODULE = "fcitx";
            XMODIFIERS = "@im=fcitx";
          };
        };
        programs = {
          git = {
            enable = true;
            userName = "kerthical";
            userEmail = "121681466+kerthical@users.noreply.github.com";
          };
          fish = {
            enable = true;
            interactiveShellInit = ''
              set fish_greeting
              set -g fish_key_bindings fish_vi_key_bindings
            '';
            plugins = [
              {
                name = "autopair-fish";
                src = pkgs.fishPlugins.autopair-fish.src;
              }
            ];
          };
        };
        dconf.settings = {
          "org/gnome/shell" = {
            enabled-extensions = [
              "blur-my-shell@aunetx"
              "user-theme@gnome-shell-extensions.gcampax.github.com"
            ];
            app-picker-layout = [
              [
                (aplEntry "dev" 0)
                (aplEntry "web" 1)
                (aplEntry "comms" 2)
                (aplEntry "office" 3)
                (aplEntry "media" 4)
                (aplEntry "graphics" 5)
                (aplEntry "remote" 6)
                (aplEntry "security" 7)
                (aplEntry "System" 8)
                (aplEntry "Utilities" 9)
              ]
            ];
          };
          "org/gnome/desktop/app-folders" = {
            folder-children = [
              "dev"
              "web"
              "comms"
              "media"
              "graphics"
              "office"
              "remote"
              "security"
            ];
          };
          "org/gnome/desktop/app-folders/folders/dev" = {
            name = "Development";
            categories = [
              "Development"
              "IDE"
            ];
            apps = [
              "code.desktop"
              "dbeaver.desktop"
              "insomnia.desktop"
            ];
          };
          "org/gnome/desktop/app-folders/folders/web" = {
            name = "Web";
            categories = [ "WebBrowser" ];
            apps = [
              "firefox.desktop"
              "google-chrome.desktop"
            ];
          };
          "org/gnome/desktop/app-folders/folders/comms" = {
            name = "Communication";
            categories = [
              "InstantMessaging"
              "Chat"
              "Email"
            ];
            apps = [
              "slack.desktop"
              "discord.desktop"
              "signal-desktop.desktop"
              "thunderbird.desktop"
            ];
          };
          "org/gnome/desktop/app-folders/folders/media" = {
            name = "Media";
            categories = [
              "AudioVideo"
              "Audio"
              "Video"
              "Player"
              "Recorder"
            ];
            apps = [
              "vlc.desktop"
              "mpv.desktop"
              "spotify.desktop"
              "com.obsproject.Studio.desktop"
            ];
          };
          "org/gnome/desktop/app-folders/folders/graphics" = {
            name = "Graphics";
            categories = [
              "Graphics"
              "2DGraphics"
              "RasterGraphics"
              "VectorGraphics"
              "Photography"
            ];
            apps = [
              "gimp.desktop"
              "org.inkscape.Inkscape.desktop"
              "pinta.desktop"
            ];
          };
          "org/gnome/desktop/app-folders/folders/office" = {
            name = "Office";
            categories = [ "Office" ];
            apps = [
              "libreoffice-startcenter.desktop"
              "libreoffice-writer.desktop"
              "libreoffice-calc.desktop"
              "libreoffice-impress.desktop"
              "obsidian.desktop"
              "logseq.desktop"
              "joplin.desktop"
              "notion-app.desktop"
            ];
          };
          "org/gnome/desktop/app-folders/folders/remote" = {
            name = "Remote";
            categories = [ "RemoteAccess" ];
            apps = [
              "org.remmina.Remmina.desktop"
            ];
          };
          "org/gnome/desktop/app-folders/folders/security" = {
            name = "Security";
            apps = [
              "wireshark.desktop"
              "burpsuite.desktop"
              "ghidra.desktop"
              "iaito.desktop"
              "org.gnome.GHex.desktop"
              "jadx-gui.desktop"
              "johnny.desktop"
              "cutter.desktop"
            ];
          };
          "org/gnome/shell/extensions/blur-my-shell/applications" = {
            blur = true;
            whitelist = [
              "kgx"
              "gnome-text-editor"
              "org.gnome.Nautilus"
              "Code"
            ];
            opacity = 230;
            dynamic-opacity = false;
          };
          "org/gnome/desktop/background" = {
            color-shading-type = "solid";
            picture-options = "zoom";
            picture-uri = "${builtins.path { path = ./wallpaper.jpg; }}";
            picture-uri-dark = "${builtins.path { path = ./wallpaper.jpg; }}";
            primary-color = "#241f31";
            secondary-color = "#000000";
          };
        };
      }
    );
}
