{ lib, pkgs, python3, fetchurl }:

python3.pkgs.buildPythonPackage rec {
  pname = "azure_ai_inference";
  version = "1.0.0b9";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/py3/a/azure_ai_inference/azure_ai_inference-1.0.0b9-py3-none-any.whl";
    sha256 = "SYI3MuZ0CS2tg7uLDRtlqnMRH6uSTWE0nrKozcBJOZA=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    isodate
    azure-core
    typing-extensions
  ];

  pythonImportsCheck = [ "azure.ai.inference" ];

  meta = with lib; {
    description = "Microsoft Azure AI Inference Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/ai/azure-ai-inference";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
