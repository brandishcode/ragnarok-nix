{
  description = "Ragnarok installation";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    erosanix = {
      url = "github:brandishcode/erosanix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, erosanix }: {

    packages.x86_64-linux =
      let pkgs = import "${nixpkgs}" { system = "x86_64-linux"; };

      in with (pkgs // erosanix.packages.x86_64-linux
        // erosanix.lib.x86_64-linux); {
          ragnarok-zero = {
            install = callPackage ./ragnarok-zero.nix {
              inherit mkWindowsApp;
              wine = wineWowPackages.full;
            };
          };
        };

    apps.x86_64-linux.ragnarok-zero = {
      type = "app";
      program =
        "${self.packages.x86_64-linux.ragnarok-zero.install}/bin/ragnarok-zero";
    };
  };
}
