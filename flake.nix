{
  outputs = {
    self,
  }: let
    createSetVercelEnv = import ./nix/set-vercel-env.nix;
  in {
    lib = {
      inherit createSetVercelEnv;
    };
  };
}
