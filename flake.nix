{
    description = " A meta-flake distributing my projects";

    inputs = {
        nixpkgs-stable.url = "github:NixOS/nixpkgs";
        nixpkgs-unstable.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
        flake-utils.url = "github:numtide/flake-utils";

        # Imported apps
        cube.url = "github:ShilohAlleyne/cube";
        commie.url = "github:ShilohAlleyne/commie";
        decoy.url = "github:ShilohAlleyne/decoy";
    };

    outputs = { self, nixpkgs-stable, nixpkgs-unstable, flake-utils, cube, commie, decoy }:
    flake-utils.lib.eachDefaultSystem (system:
        let
            pkgs-stable = import nixpkgs-unstable { inherit system; };
        in {
            # Re-export packages
            packages.cube = cube.packages.${system}.default;
            packages.commie = commie.packages.${system}.default;
            packages.decoy = decoy.packages.${system}.default;

            # Optional: expose devShells
            # devShells.default = pkgs-stable.mkShell {
            #     packages = [
            #         cube.packages.${system}.default
            #         choreographer.packages.${system}.default
            #     ];
            # };

            # Define apps
            apps.cube = {
                type = "app";
                program = "${cube.packages.${system}.default}/bin/cube";
            };

            apps.commie = {
                type = "app";
                program = "${commie.packages.${system}.default}/bin/commie";
            };

            apps.decoy = {
                type = "app";
                program = "${decoy.packages.${system}.default}/bin/decoy";
            };

            # Default app (optional)
            # apps.default = self.apps.${system}.cube;
            # packages.default = self.packages.${system}.cube;
        }
    );
}
