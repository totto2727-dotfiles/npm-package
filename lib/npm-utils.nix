{ pkgs }:

{
  npmPackage =
    {
      name,
      packageName ? name,
      version ? "latest",
      binName ? null,
      additionalArgs ? "--bun",
    }:
    let
      # Use the provided binary name or fallback to package name
      actualBinName = if binName != null then binName else name;
    in
    pkgs.writeShellScriptBin actualBinName ''
      safe-chain bunx --yes ${additionalArgs} ${packageName}@${version} "$@"
    '';
}
