{ config, inputs, ... }:
{

  imports = [
    inputs.agenix.darwinModules.default
  ];

  age = {
    identityPaths = [ "/Users/${config.me.username}/.ssh/id_ed25519" ]; # TODO: Find a better way to do this
    secrets.github-runner = {
      file = ../../secrets/github-runner.age;
      owner = "_github-runner";
      group = "_github-runner";
      mode = "600";
    };
  };

  services.github-runners = {
    "runner1" = {
      enable = true;
      name = "macos-runner1";
      url = "https://github.com/sinrohit/fold";
      tokenFile = config.age.secrets.github-runner.path;
    };
  };
}
