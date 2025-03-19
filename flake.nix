{
  description = "LaTeX build system using Nix flakes";

  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.11";

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      packages.${system}.default = pkgs.writeShellScriptBin "compile" ''
        mkdir -p out
        pdflatex report.tex
        biber report
        pdflatex report.tex
        pdflatex report.tex
        echo "Report generated"
      '';

      # Development shell with LaTeX environment
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          texliveFull
          texlab
        ];
        shellHook = ''
          echo "LaTeX build environment is ready."
        '';
      };
    };
}
