{

	description = "My first flake system";

	inputs = {

		  nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
		  
		  zen-browser = {

			url = "github:youwen5/zen-browser-flake";
			inputs.nixpkgs.follows = "nixpkgs";
		  };

		  home-manager = {
			url = "github:nix-community/home-manager/release-26.05";

			inputs.nixpkgs.follows = "nixpkgs";
      };

      obsidian-extensions = {
       url = "github:karaolidis/nix-obsidian-extensions";
       inputs.nixpkgs.follows = "nixpkgs";
      };

		  nixvim.url = "github:nix-community/nixvim";

		  flake-utils.url = "github:numtide/flake-utils";

	};


	outputs = { self, nixpkgs, home-manager, zen-browser, nixvim, obsidian-extensions, ... }@inputs: {

		nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {

			system = "x86_64-linux";

			specialArgs = { inherit inputs; };

			modules = [
			./nixos/configuration.nix
			];
		};

		homeConfigurations.mimozyr = home-manager.lib.homeManagerConfiguration {

			pkgs = nixpkgs.legacyPackages."x86_64-linux";
			extraSpecialArgs = { inherit inputs; };
      modules = [  
			  nixvim.homeModules.nixvim
        ./home-manager/home.nix
        ./home-manager/alacritty.nix
        ./home-manager/fish.nix
        ./home-manager/nixvim/nixvim.nix
        ./home-manager/obsidian.nix
        ./home-manager/git.nix
        ./home-manager/tmux.nix
        ./home-manager/hyprlock.nix
        ./home-manager/fuzzel.nix
        ./home-manager/fnott.nix
        {
			  nixpkgs.config.allowUnfree = true;
			  }

      ];
		};


	};





}
