{ pkgs }:

{
  npmPackage =
    {
      binName,
      packageName,
      version ? "latest",
      runtime ? "bun",
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
          exec ${pkgs.nodejs}/bin/npx --yes ${additionalArgs} ${packageSpec} "$@"
        '';
        bun = ''
          export npm_config_loglevel=error
          export npm_config_registry=${registry}
          export PATH="${pkgs.lib.makeBinPath [ pkgs.bun ]}:$PATH"
          exec ${pkgs.bun}/bin/bunx --bun --yes ${additionalArgs} ${packageSpec} "$@"
        '';
      };
      script =
        runtimes.${runtime}
          or (throw "npmPackage: unsupported runtime '${runtime}' (supported: ${toString (builtins.attrNames runtimes)})");
    in
    pkgs.writeShellScriptBin binName script;
}
