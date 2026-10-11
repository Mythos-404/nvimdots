{
  description = "Home-manager module for Mythos-404/nvimdots";

  outputs = { self, ... }: {
    homeManagerModules.default = ./nixos;
  };
}
