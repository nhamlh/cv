{
  description = "My resume";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: 
  let
    resumeFile = "resume";
  in
  {
    packages.x86_64-linux.default = with import nixpkgs { system = "x86_64-linux"; };
    stdenv.mkDerivation {
      name = "My resume";

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
  };
}
