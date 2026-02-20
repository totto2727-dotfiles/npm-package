{ pkgs }:

{
  # Function to create an npx wrapper for any npm package
  npmPackage = { 
    name,                   # Name of the package
    packageName ? name,     # NPM package name (defaults to name)
    version ? "latest",     # Package version (defaults to "latest")
    binName ? null          # Binary name (defaults to name)
  }: 
    let
      # Use the provided binary name or fallback to package name
      actualBinName = if binName != null then binName else name;
    in
      # Create a simple wrapper script that uses npx
      pkgs.writeShellScriptBin actualBinName ''
        safe-chain bun x --bun --yes ${packageName}@${version} "$@"
      '';
}
