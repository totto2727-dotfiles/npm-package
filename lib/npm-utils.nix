{ pkgs }:

{
  npmPackage =
    {
      name,
      packageName ? name,
      version ? "latest",
      binName ? null,
      runtime ? "bunx --yes",
      additionalArgs ? "",
    }:
    let
      # Use the provided binary name or fallback to package name
      actualBinName = if binName != null then binName else name;
    in
    pkgs.writeShellScriptBin actualBinName ''
      ${runtime} ${additionalArgs} ${packageName}@${version} "$@"
    '';
}
