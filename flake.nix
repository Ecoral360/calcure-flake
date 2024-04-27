{
  description = "Modern TUI calendar and task manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        python = pkgs.python3;
        python_packages = python.withPackages (ps: with ps; [
          setuptools
          wheel
          holidays
          jdatetime
          icalendar
          taskw
        ]);
      in

      {
        packages.default = with import nixpkgs { inherit system; };
          python3Packages.buildPythonApplication rec {
            pname = "calcure";
            version = "3.0.1";

            src = fetchPypi {
              inherit pname version;
              hash = "sha256:70fcd3bc07f5801200d861f4f03ff8ceb139c0683f6e2318a2bde8e4bdc959c9";
            };

            pyproject = true;

            nativeBuildInputs = [
              python_packages
            ];

            propagatedBuildInputs = [
              python_packages
            ];

            # postInstall = ''
            #   mv -v $out/bin/calcure.py $out/bin/calcure
            # '';

            meta = {
              description = "Modern TUI calendar and task manager";
              homepage = "https://github.com/anufrievroman/calcure";
              license = lib.licenses.mit;
              maintainers = [ "Roman Anufriev" ];
            };
          };

      }
    );
}
