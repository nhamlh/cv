{nixpkgs}:
stdenv.mkDerivation {
  name = "My resume";

  src = ./.;

  nativeBuildInputs = [
    nixpkgs.texlive.combined.scheme-full
  ];

  buildPhase = ''
    export HOME=$(mktemp -d)
    lualatex sample.tex
  '';

  installPhase = ''
    cp sample.pdf $out
  '';
}
