{
  pkgs,
  outPath,
  commandPrefix ? "pnpm",
}: let
  scriptName = "set-vercel-env";
  cmd =
    if builtins.isString commandPrefix && builtins.stringLength commandPrefix > 0
    then commandPrefix + " vercel"
    else "vercel";
in
  pkgs.writeShellScriptBin scriptName ''
    help() {
      echo "Usage: ${scriptName} <environment>"
      echo
      echo "Example:"
      echo "1. Set the environment to production:"
      echo "${scriptName} production"
      echo
      echo "2. Set the environment to preview:"
      echo "${scriptName} preview"
      echo
      echo "3. Set the environment to development:"
      echo "${scriptName} development"
      echo
      echo "Description:"
      echo "The '${scriptName}' script allows you to easily switch between different environments, adjusting configurations and settings based on your specific needs. By selecting the appropriate environment, you ensure that your application operates with the correct set of parameters, making it suitable for its designated purpose."
      echo
      echo "Available Environments:"
      echo "1. Production: Connect to live instance."
      echo "2. Preview: Connect to test instance."
      echo "3. Development: Connect to local development instance."
    }

    # Check if out path is set.
    if [ -z "${outPath}" ]; then
      echo "outPath is not set in nix configuration!"
      exit 1
    fi

    # Check if the number of arguments is correct
    if [ $# -ne 1 ]; then
      echo "Error: Incorrect number of arguments. Please provide one environment (production, preview, or development)." >&2
      help
      exit 1
    fi

    # Get the first argument
    environment="$1"

    # Check if the provided environment is valid
    if [ "$environment" != "production" ] && [ "$environment" != "preview" ] && [ "$environment" != "development" ]; then
      echo "Error: Invalid environment. Please provide one of the following environments: production, preview, or development." >&2
      help
      exit 1
    fi

    # Proceed with setting the environment based on the provided argument
    echo "Setting environment to: $environment"
    ${cmd} env pull --environment=$environment ${outPath}
  ''
