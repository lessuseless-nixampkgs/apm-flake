{ lib, ... }:

{
  perSystem =
    {
      config,
      self',
      pkgs,
      system,
      ...
    }:
    {
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

            propagatedBuildInputs =
              (with python.pkgs; [
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
              ])
              ++ [
                (pkgs.callPackage ./llm-github-models.nix { })
              ];

            postPatch = ''
              # Move scripts to src/apm_cli/scripts so they are included in the package
              mkdir -p src/apm_cli/scripts
              cp -r scripts/* src/apm_cli/scripts/
              touch src/apm_cli/scripts/__init__.py


              # Fix path resolution in RuntimeManager
              substituteInPlace src/apm_cli/runtime/manager.py \
                --replace-fail 'current_file = Path(__file__)' 'current_file = Path(__file__).resolve()' \
                --replace-fail 'repo_root = current_file.parent.parent.parent.parent  # Go up to repo root' 'repo_root = current_file.parent.parent  # Go up to repo root'

              # Patch pyproject.toml to include the scripts directory
              echo "" >> pyproject.toml
              echo "[tool.setuptools.package-data]" >> pyproject.toml
              echo '"apm_cli.scripts" = ["**/*"]' >> pyproject.toml
              echo '"apm_cli.scripts.runtime" = ["**/*"]' >> pyproject.toml
            '';

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
                pkgs.nodejs_24
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
