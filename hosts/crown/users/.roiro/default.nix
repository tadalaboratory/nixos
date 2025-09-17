{
  pkgs,
  lib,
  ...
}:
let
  username = builtins.baseNameOf ./.;
  password = "$6$UH5SANkQjvrqUJjN$FSAvqSfh7DB3tbSjTijuPthUvB4Gwq.CItH1itoMLcmfmech/L33Jcc0OgcohpVUayTyoqmh5ZyxAPLJvH0b0.";
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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHktMmLEqiiWfLO8aeyxbJF27TrWvQoL/6OFni+hZBpo roiro"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINGEaaMAWicGzseLPgaosPCd/p6qdTkoWgKbvOt6LkBQ nishimura"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE5e/mOaIctHSM01tBitqgpbb4Bmgg7Gnrtaq7PK+Bk4 kadotanijin@kadoyanoMacBook-Air.local"
    ];
  };

  home-manager.users."${username}" =
    { pkgs, lib, ... }:
    common.recursiveMerge (common.home { inherit pkgs lib; }) {
      home = {
        sessionVariables = {
          GTK_IM_MODULE = "fcitx";
          QT_IM_MODULE = "fcitx";
          XMODIFIERS = "@im=fcitx";
        };
      };
      programs = {
        git = {
          enable = true;
          userName = "qwertyroiro";
          userEmail = "57554521+qwertyroiro@users.noreply.github.com";
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
    };
}
