{
  pkgs,
  lib,
  ...
}:
let
  username = builtins.baseNameOf ./.;
  password = "$6$6D2ut8u8Wmk/wOxm$XG4JdSToXrVNDT3j4KFnrOYV1puUs2qQHRGxyASnnkZtyx881YTnOxUs8DoZ1uX4CMOi7ly/Bx.qOhv.MJXc50";
  common = import ../common.nix {
    inherit pkgs lib username;
  };
in
{
  users.users."${username}" = common.recursiveMerge common.user {
    hashedPassword = "${password}";
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
    };
}
