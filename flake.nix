{
  description = "My personal curriculum vitae";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    altacv = {
      type = "github";
      owner = "liantze";
      repo = "AltaCV";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, altacv, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      resumeFile = "resume";
    in {
      packages.${system}.default = with import nixpkgs { inherit system; };
        stdenv.mkDerivation {
          name = resumeFile;

          src = ./.;

          #NOTE: Should use pandoc so that we can also convert to html version?
          nativeBuildInputs = [
            (pkgs.texlive.combine {
              inherit (texlive)
                scheme-basic extsizes etoolbox pdfx luatex85 xcolor xmpincl
                accsupp fontawesome5 luatexbase koma-script fontspec pgf
                tcolorbox environ enumitem adjustbox collectbox xkeyval dashrule
                ifmtarg multirow changepage paracol biblatex biblatex-ieee;
            })
          ];

          buildPhase = ''
            cp  ${altacv}/*.cls ${altacv}/*.cfg .

            # lualatex needs writable HOME to store tmp files
            export HOME=$(mktemp -d)
            echo $HOME
            lualatex ${resumeFile}.tex
          '';

          installPhase = ''
            mkdir $out
            cp ${resumeFile}.pdf $out/${resumeFile}.pdf
          '';
        };

      devShells.x86_64-linux.default = import ./shell.nix { inherit pkgs; };
    };
}
