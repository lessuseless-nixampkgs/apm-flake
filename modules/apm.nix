{ lib, ... }:

{
  perSystem = { config, self', pkgs, system, ... }: {
    packages =
      let
        python = pkgs.python3;
        apm-pkg = python.pkgs.buildPythonApplication rec {
          pname = "apm";
          version = "0.5.5";
          pyproject = true;

          src = pkgs.fetchFromGitHub {
            owner = "danielmeppiel";
            repo = "apm";
            rev = "v${version}";
            hash = "sha256-BCOECY1Smht9gxiFE2iBhiFtV3OrNskPZSZJTGuEOJs=";
          };

          nativeBuildInputs = [
            python.pkgs.setuptools
            python.pkgs.wheel
          ];

          propagatedBuildInputs = (with python.pkgs; [
            click
            colorama
            gitpython
            llm
            python-frontmatter
            pyyaml
            requests
            rich
            rich-click
            toml
            tomli
            watchdog
          ]) ++ [
            (pkgs.callPackage ./llm-github-models.nix { })
          ];

          passthru.optional-dependencies = with python.pkgs; {
            build = [
              pyinstaller
            ];
            dev = [
              black
              isort
              mypy
              pytest
              pytest-cov
            ];
          };

          pythonImportsCheck = [
            "apm_cli"
          ];

          meta = with lib; {
            description = "Agent Package Manager";
            homepage = "https://github.com/danielmeppiel/apm";
            changelog = "https://github.com/danielmeppiel/apm/blob/${src.rev}/CHANGELOG.md";
            license = licenses.mit;
            maintainers = with maintainers; [ ];
            mainProgram = "apm";
          };
        };
      in
      {
        apm = apm-pkg;
        default = self'.packages.apm;
      };
  };
}
