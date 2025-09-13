{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-25.05";
    };
    nixos = {
      url = "path:/etc/nixos";
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      nixos,
    }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config = {
          allowUnfree = true;
          cudaSupport = true;
          nvidia.acceptLicense = true;
        };
      };
      getPythonShells =
        pythonPackageName:
        let
          standardPackages = [
            pkgs.stdenv.cc
            pkgs.stdenv.cc.cc
            pkgs.stdenv.cc.cc.lib
            pkgs.binutils
            pkgs.ncurses5
            pkgs.autoconf
            pkgs.procps
            pkgs.gnumake
            pkgs.gnupg
            pkgs.util-linux
            pkgs.m4
            pkgs.gperf
            pkgs.unzip
            pkgs.libzip
            pkgs.zlib
            pkgs.glib
            pkgs.libGL
            pkgs.libGLU
            pkgs.pciutils
            pkgs.curl
            pkgs.wget
            pkgs.freeglut
            pkgs.qt5.full
            pkgs.qt5.qtbase
            pkgs.qt5.qttools
            pkgs.xorg.libX11
            pkgs.xorg.libXext
            pkgs.xorg.libXt
            pkgs.xorg.libXmu
            pkgs.xorg.libXi
            pkgs.xorg.libXrandr
            pkgs.xorg.libXrender
            pkgs.xorg.libXxf86vm
            pkgs.xorg.libXxf86dga
            pkgs.xorg.libXinerama
            pkgs.xorg.libXcursor
            pkgs.xorg.libXcomposite
            pkgs.xorg.libXfixes
            pkgs.xorg.libXft
            pkgs.xorg.libXpm
            pkgs.xorg.libXaw
            pkgs.xorg.libXtst
            pkgs.xorg.libXv
            pkgs.xorg.libXvMC
            pkgs.xorg.libxcb
            pkgs.xorg.libICE
            pkgs.xorg.libSM
          ];
          applicationPackages = [
            pkgs."${pythonPackageName}"
            pkgs."${pythonPackageName}Packages".venvShellHook
            pkgs."${pythonPackageName}Packages".pyqt5
            pkgs."${pythonPackageName}Packages".pyliblo3
            pkgs."${pythonPackageName}Packages".pyxdg
            pkgs.ruff
          ];
          getCUDAShell =
            cudaPackageName: gccPackageName:
            let
              cudaPackages = [
                nixos.nixosConfigurations.crown.options.boot.kernelPackages.value.nvidia_x11
                pkgs."${cudaPackageName}".cudatoolkit
              ];
            in
            pkgs.mkShell {
              nativeBuildInputs = [ pkgs."${gccPackageName}" ];
              buildInputs = standardPackages ++ applicationPackages ++ cudaPackages;
              venvDir = ".venv";
              postShellHook = ''
                unset SOURCE_DATE_EPOCH;
                export CUDA_PATH="${pkgs."${cudaPackageName}".cudatoolkit}";
                export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath (standardPackages ++ cudaPackages)}";
                export EXTRA_CCFLAGS="-I/usr/include";
              '';
            };
        in
        {
          "default" = pkgs.mkShell {
            buildInputs = standardPackages ++ applicationPackages;
            venvDir = ".venv";
            postShellHook = ''
              unset SOURCE_DATE_EPOCH;
              export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath standardPackages}";
              export EXTRA_CCFLAGS="-I/usr/include"
            '';
          };
          "cu124" = getCUDAShell "cudaPackages_12_4" "gcc12";
          "cu123" = getCUDAShell "cudaPackages_12_3" "gcc12";
          "cu122" = getCUDAShell "cudaPackages_12_2" "gcc12";
          "cu121" = getCUDAShell "cudaPackages_12_1" "gcc12";
          "cu120" = getCUDAShell "cudaPackages_12" "gcc12";
          "cu12" = getCUDAShell "cudaPackages_12" "gcc12";
          "cu118" = getCUDAShell "cudaPackages_11_8" "gcc11";
          "cu117" = getCUDAShell "cudaPackages_11_7" "gcc11";
          "cu116" = getCUDAShell "cudaPackages_11_6" "gcc11";
          "cu115" = getCUDAShell "cudaPackages_11_5" "gcc11";
          "cu1141" = getCUDAShell "cudaPackages_11_4_1" "gcc11";
          "cu114" = getCUDAShell "cudaPackages_11_4" "gcc10";
          "cu113" = getCUDAShell "cudaPackages_11_3" "gcc10";
          "cu112" = getCUDAShell "cudaPackages_11_2" "gcc10";
          "cu111" = getCUDAShell "cudaPackages_11_1" "gcc10";
          "cu110" = getCUDAShell "cudaPackages_11" "gcc9";
          "cu11" = getCUDAShell "cudaPackages_11" "gcc9";
          "cu102" = getCUDAShell "cudaPackages_10_2" "gcc8";
          "cu101" = getCUDAShell "cudaPackages_10_1" "gcc8";
          "cu100" = getCUDAShell "cudaPackages_10" "gcc7";
          "cu10" = getCUDAShell "cudaPackages_10" "gcc7";
        };
    in
    {
      devShells."x86_64-linux" = {
        "python310" = getPythonShells "python310";
        "python311" = getPythonShells "python311";
        "python312" = getPythonShells "python312";
        "python313" = getPythonShells "python313";
        "python314" = getPythonShells "python314";
      };
    };
}
