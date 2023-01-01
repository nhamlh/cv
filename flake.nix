{
  description = "My personal curriculum vitae";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: 
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    resumeFile = "resume";
  in
  {
    packages.${system}.default = with import nixpkgs { inherit system; };
    stdenv.mkDerivation {
      name = resumeFile;

      src = ./.;

      nativeBuildInputs = [ texlive.combined.scheme-full ];

      buildPhase = ''
        export HOME=$(mktemp -d)
        lualatex ${resumeFile}.tex
      '';

      installPhase = ''
        mkdir $out
        cp ${resumeFile}.pdf $out/${resumeFile}.pdf
      '';
    };

    devShells.default = import ./shell.nix { inherit pkgs; };
  };
}
