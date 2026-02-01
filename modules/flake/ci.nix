# CI workflow definition using actions.nix
{
  inputs,
  self,
  lib,
  ...
}:
let
  # Platform mappings: Nix system -> GitHub runner
  platforms = {
    aarch64-linux.label = ''["self-hosted", "linux", "ARM64"]'';
    aarch64-darwin.label = ''["self-hosted", "macOS", "ARM64"]'';
    x86_64-linux.label = ''["self-hosted", "linux", "x64"]'';
  };

  # Build matrix entry from configuration (autodiscovery)
  # Returns data in the exact shape needed for GitHub Acuctions matrix
  mkHostInfo =
    kind: name: cfg:
    let
      platform = cfg.pkgs.stdenv.hostPlatform.system;
      platformInfo = platforms.${platform} or null;
    in
    lib.optionalAttrs (platformInfo != null) {
      inherit name;
      hostPlatform = platform;
      runsOn = platformInfo.label;
      attr =
        if kind == "nixos" then
          "nixosConfigurations.${name}.config.system.build.toplevel"
        else
          "darwinConfigurations.${name}.config.system.build.toplevel";
    };

  # Autodiscover all hosts and filter out unsupported platforms
  nixosHosts = lib.filter (h: h != { }) (
    lib.mapAttrsToList (mkHostInfo "nixos") (self.nixosConfigurations or { })
  );
  darwinHosts = lib.filter (h: h != { }) (
    lib.mapAttrsToList (mkHostInfo "darwin") (self.darwinConfigurations or { })
  );

  # GitHub Actions references - all versions consolidated here for Renovate
  actions = {
    alls-green = "re-actors/alls-green@05ac9388f0aebcb5727afa17fcccfecd6f8ec5fe"; # v1.2.2
    cache = "actions/cache@8b402f58fbc84540c8b491a91e594a4576fec3d7"; # v5.0.2
    cachix = "cachix/cachix-action@0fc020193b5a1fa3ac4575aa3a7d3aa6a35435ad"; # v16
    checkout = "actions/checkout@8e8c483db84b4bee98b60c0593521ed34d9990e8"; # v6.0.1
    nix-installer = "nixbuild/nix-quick-install-action@v33";
    update-flake-inputs = "mic92/update-flake-inputs@main";
  };

  # Reusable step definitions
  steps = {
    checkout = {
      uses = actions.checkout;
      "with".persist-credentials = false;
    };

    nixInstaller = {
      uses = actions.nix-installer;
      "with".extra-conf = ''
        accept-flake-config = true
        always-allow-substitutes = true
        builders-use-substitutes = true
        max-jobs = auto
      '';
    };

    nixCache = {
      uses = actions.cache;
      "with" = {
        path = "~/.cache/nix";
        key = "nix-eval-\${{ runner.os }}-\${{ runner.arch }}-\${{ hashFiles('flake.lock') }}";
        restore-keys = "nix-eval-\${{ runner.os }}-\${{ runner.arch }}-";
      };
    };

    cachix = {
      uses = actions.cachix;
      "with" = {
        name = "sinrohit";
        authToken = "\${{ secrets.CACHIX_AUTH_TOKEN }}";
      };
    };

    # Helper to create nixci-build step for a given attribute expression
    nixci-build = flakeAttr: {
      name = "Run Nix CI 🔧";
      run = "nix build ${flakeRef}#${flakeAttr}";
    };
  };

  # Common setup steps for build jobs
  setupSteps = [
    steps.checkout
    steps.nixInstaller
    steps.nixCache
    steps.cachix
  ];

  # Platforms to run flake check/show on (derived from all hosts)
  checkPlatforms =
    let
      allHosts = nixosHosts ++ darwinHosts;
      hostPlatforms = lib.unique (map (h: h.hostPlatform) allHosts);
    in
    map (p: {
      platform = p;
      inherit (platforms.${p}) label;
    }) hostPlatforms;

  flakeRef = "git+file:.";
in
{
  imports = [ inputs.actions-nix.flakeModules.default ];

  flake.actions-nix = {
    pre-commit.enable = true;

    defaultValues.jobs = {
      timeout-minutes = 60;
      runs-on = "macOS";
    };

    workflows = {
      ".github/workflows/ci.yaml" = {
        name = "ci";

        on = {
          push.branches = [
            "main"
          ];
          pull_request = { };
          workflow_dispatch = { };
        };

        concurrency = {
          group = "ci-\${{ github.head_ref || github.ref_name }}";
          cancel-in-progress = "\${{ github.event_name == 'pull_request' }}";
        };

        # Minimal permissions for security - this workflow only needs to read code
        permissions = { };

        jobs = {
          # Flake check on all platforms
          flake-check = {
            name = "flake check (\${{ matrix.systems.platform }})";
            strategy.matrix.systems = checkPlatforms;
            runs-on = "\${{ fromJSON(matrix.attrs.runsOn) }}";
            steps = setupSteps ++ [
              {
                name = "nix flake check";
                run = "nix flake check '${flakeRef}'";
              }
              {
                name = "nix flake show";
                run = "nix flake show '${flakeRef}'";
              }
            ];
          };

          # Build hosts
          build = {
            name = "\${{ matrix.attrs.name }} (\${{ matrix.attrs.hostPlatform }})";
            strategy = {
              fail-fast = false;
              matrix.attrs = nixosHosts ++ darwinHosts;
            };
            runs-on = "\${{ fromJSON(matrix.attrs.runsOn) }}";
            steps = setupSteps ++ [ (steps.nixci-build "\${{ matrix.attrs.attr }}") ];
          };

          # Final check job - aggregates all results
          check = {
            runs-on = "macOS";
            needs = [
              "flake-check"
              "build"
            ];
            "if" = "always()";
            steps = [
              {
                uses = actions.alls-green;
                "with" = {
                  jobs = "\${{ toJSON(needs) }}";
                };
              }
            ];
          };
        };
      };

      ".github/workflows/update-inputs.yaml" = {
        name = "update-flake-inputs";

        on = {
          schedule = [
            { cron = "0 2 * * 1"; }
          ];
          workflow_dispatch = { };
        };

        permissions = {
          contents = "write";
          pull-requests = "write";
        };

        jobs.update-inputs = {
          runs-on = "ubuntu-latest";

          steps = [
            (
              steps.checkout
              // {
                "with" = {
                  token = "\${{ secrets.PAT }}";
                };
              }
            )

            steps.nixInstaller

            {
              name = "Update flake inputs";
              uses = actions.update-flake-inputs;
              "with" = {
                github-token = "\${{ secrets.PAT }}";

                # Explicit: PR only
                auto-merge = false;

                commit-message = "chore(flake): update inputs";
                pr-title = "chore(flake): update inputs";
                pr-labels = "dependencies,nix";
              };
            }
          ];
        };
      };
    };
  };
}
