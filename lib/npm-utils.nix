{ pkgs }:

{
  npmPackage =
    {
      binName,
      packageName,
      version ? "latest",
      runtime ? "node",
      registry ? "https://npm.flatt.tech",
      additionalArgs ? "",
    }:
    let
      packageSpec = "${packageName}@${version}";
      runtimes = {
        node = ''
          export npm_config_loglevel=error
          export npm_config_registry=${registry}
          export PATH="${pkgs.lib.makeBinPath [ pkgs.nodejs ]}:$PATH"
          export NODE="${pkgs.nodejs}/bin/node"
          export SHELL="${pkgs.bash}/bin/bash"
          exec ${pkgs.nodejs}/bin/npx --node "$NODE" --yes ${additionalArgs} ${packageSpec} "$@"
        '';
        bun = ''
          export npm_config_registry=${registry}
          exec ${pkgs.bun}/bin/bunx --yes ${additionalArgs} ${packageSpec} "$@"
        '';
      };
      script =
        runtimes.${runtime}
          or (throw "npmPackage: unsupported runtime '${runtime}' (supported: ${toString (builtins.attrNames runtimes)})");
    in
    pkgs.writeShellScriptBin binName script;
}
