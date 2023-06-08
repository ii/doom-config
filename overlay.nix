final: prev:
{
  # this key should be the same as the simpleFlake name attribute.
  iidoom = {
    # assuming that hello is a project-specific package;
    emacs = prev.emacs.override {

    };

    # doom-emacs = prev.nix-doom-emacs.override {
    #   doomPrivateDir = ./.;
    #   # emacsPackage = prev.emacsPgtkNativeComp;
    # };
    # demonstrating recursive packages
    # terraform-providers = prev.terraform-providers;
  };
}
