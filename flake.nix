{
  description = "clean-devshell";

  inputs = { };

  outputs = { ... }: {
    lib = {
      mkDevShell = import ./devshell.nix;
    };
  };
}
