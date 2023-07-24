inputs: final: prev: {
  devenv = inputs.devenv.packages.${prev.system}.devenv;
}
