{
  description = "sakana fish l1npengtul nix system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko-zfs = {
      url = "github:numtide/disko-zfs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.disko.follows = "disko";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Package / Additional Services

    auto-cpufreq = {
      url = "github:AdnanHodzic/auto-cpufreq";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    audio = {
      url = "github:polygon/audio.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";
    };

    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

    nixos-needsreboot.url = "github:harryprayiv/nixos-needsreboot";

    reapkgs-known.url = "github:silvarc141/reapkgs-known/27487c09915f77cb8742936a1974897029055fee";
    reapkgs-extras.url = "github:l1npengtul/reapkgs-extras/8f709e959a7ed37e884067bc6fd4d3e423582fb4";

    # Nixpkgs patches
    # github:NixOS/nixpkgs?ref=pull/{PR NUMBER}/head

    # Additional Configuration Files

    plasma-overdose = {
      url = "github:olivertzeng/Plasma-Overdose";
      flake = false;
    };

    hatsune-miku-windows-linux-cursors = {
      url = "github:supermariofps/hatsune-miku-windows-linux-cursors";
      flake = false;
    };

    chicago95 = {
      url = "github:grassmunk/Chicago95";
      flake = false;
    };

    shhh = {
      url = "git+ssh://git@git.sr.ht/~l1npengtul/shhh?ref=senpai&shallow=1";
    };

    randomshit = {
      url = "git+ssh://git@git.sr.ht/~l1npengtul/randomshit?ref=senpai&shallow=1";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      nixos-hardware,
      home-manager,
      plasma-manager,
      nix-flatpak,
      auto-cpufreq,
      musnix,
      audio,
      nix-index-database,
      nix-minecraft,
      nixos-needsreboot,
      disko,
      disko-zfs,
      sops-nix,
      impermanence,
      reapkgs-known,
      reapkgs-extras,
      plasma-overdose,
      hatsune-miku-windows-linux-cursors,
      chicago95,
      shhh,
      randomshit,
      ...
    }@inputs:
    let
      username = "l1npengtul";
      system = "x86_64-linux";
      lib = nixpkgs.lib // home-manager.lib;

      #reapersws-overlay = final: prev: {
      #  inherit (nixpkgs-reaper-sws.legacyPackages.${prev.stdenv.hostPlatform.system})
      #    reaper-sws-extension
      #    ;
      #};

      commonArgs = {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          #reapersws-overlay
          inputs.nix-minecraft.overlay
        ];
      };

      hm-module = [
        home-manager.nixosModules.default
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {
              inherit
                inputs
                pkgs
                pkgs-unstable
                ;
            };
            sharedModules = [
              plasma-manager.homeModules.plasma-manager
              sops-nix.homeManagerModules.sops
              nix-flatpak.homeManagerModules.nix-flatpak
            ];
            users."${username}".imports = [
              ./home
            ];
          };
        }
      ];

      pkgs = import nixpkgs commonArgs;
      pkgs-unstable = import nixpkgs-unstable commonArgs;

      commonModules = [
        impermanence.nixosModules.impermanence
        musnix.nixosModules.musnix
        disko.nixosModules.disko
        disko-zfs.nixosModules.default
        sops-nix.nixosModules.sops
        auto-cpufreq.nixosModules.default
        nix-flatpak.nixosModules.nix-flatpak

        ./services
        ./system
        ./configuration.nix
      ];
    in
    {
      inherit lib commonArgs;

      nixosConfigurations = {
        clubcyberia = lib.nixosSystem {
          inherit system pkgs;
          specialArgs = {
            inherit inputs pkgs-unstable;
          };

          modules = [
            nixos-hardware.nixosModules.common-gpu-amd
            nixos-hardware.nixosModules.common-cpu-amd
            nixos-hardware.nixosModules.common-pc-ssd

            ./hosts/clubcyberia
          ]
          ++ commonModules
          ++ hm-module;
        };
        pegrose512 = lib.nixosSystem {
          inherit system pkgs;
          specialArgs = {
            inherit inputs pkgs-unstable;
          };

          modules = [
            nixos-hardware.nixosModules.common-gpu-intel
            nixos-hardware.nixosModules.common-cpu-intel
            nixos-hardware.nixosModules.common-hidpi

            ./hosts/pegrose512
          ]
          ++ commonModules
          ++ hm-module;
        };
        oldhome = lib.nixosSystem {
          inherit system pkgs;
          specialArgs = {
            inherit inputs pkgs-unstable;
          };

          modules = [
            nixos-hardware.nixosModules.common-pc-laptop-ssd
            nixos-hardware.nixosModules.common-gpu-intel
            nixos-hardware.nixosModules.common-cpu-intel
            nixos-hardware.nixosModules.common-pc-laptop
            nixos-hardware.nixosModules.common-hidpi

            ./hosts/oldhome
          ]
          ++ commonModules
          ++ hm-module;
        };
        thehouse = lib.nixosSystem {
          inherit system pkgs;
          specialArgs = {
            inherit inputs pkgs-unstable;
          };

          modules = [
            nixos-hardware.nixosModules.common-gpu-intel
            nixos-hardware.nixosModules.common-cpu-intel

            ./hosts/thehouse
          ]
          ++ commonModules;
        };
      };
    };
}
