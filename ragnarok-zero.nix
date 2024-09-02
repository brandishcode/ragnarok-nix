{ mkWindowsApp, wine, lib }:

let
  pname = "ragnarok-zero";
  installerDir = "drive_c/${pname}/installer";
  gameDir = "drive_c/RagnarokProjectZero";
in mkWindowsApp rec {
  inherit wine;
  inherit pname;

  version = "1.0.0";

  src = builtins.fetchurl {
    url =
      "https://downloads.playragnarokzero.com/RagnarokProjectZero20210311.exe";
    sha256 = "23bdaaa5b04f7a330e9a2061d2aeef952004b512651065295439769995446a0b";
  };

  persistRuntimeLayer = true;
  dontUnpack = true;
  enableVulcan = true;
  enableHUD = true;

  wineArch = "win64";

  winAppInstall = ''
    d="$WINEPREFIX/${installerDir}"
    mkdir -p "$d"
    cp ${src} "$d/installer.exe"
    wine start /d "$d" installer.exe
  '';

  winAppPreRun = ''
    winetricks videomemorysize=2048
  '';

  winAppRun = ''
    wine start /d "$WINEPREFIX/${gameDir}" RagnarokZero.exe
  '';

  installPhase = ''
    runHook preInstall

    ln -s $out/bin/.launcher $out/bin/${pname}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Ragnarok: Project Zero";
    homepage = "https://playragnarokzero.com";
    license = licenses.gpl3;
    maintainers = with maintainers; [ brandishcode ];
    platforms = [ "x86_64-linux" ];
  };
}
