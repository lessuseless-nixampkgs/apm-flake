{ lib, pkgs, fetchFromGitHub, ... }:

pkgs.python3.pkgs.buildPythonApplication rec {
  pname = "llm-github-models";
  version = "0.18.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tonybaloney";
    repo = "llm-github-models";
    rev = version;
    hash = "sha256-Hn6q1DZMwHMVI5bvFaT3d8e/mYhCSBVqqvZ+aLZwpgY=";
  };

  build-system = with pkgs.python3.pkgs; [
    setuptools
    wheel
  ];

  dependencies = (with pkgs.python3.pkgs; [
    aiohttp
    llm
  ]) ++ [
    (pkgs.callPackage ./azure-ai-inference.nix { })
  ];

  optional-dependencies = with pkgs.python3.pkgs; {
    test = [
      pyright
      pytest
      pytest-asyncio
      pytest-recording
      ruff
    ];
  };

  pythonImportsCheck = [
    "llm_github_models"
  ];

  meta = {
    description = "";
    homepage = "https://github.com/tonybaloney/llm-github-models";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "llm-github-models";
  };
}
