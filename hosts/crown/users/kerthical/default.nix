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
    common.recursiveMerge (common.home { inherit pkgs lib; }) {
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
    };
}
