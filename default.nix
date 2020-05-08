{ obelisk ? import ./.obelisk/impl {
    system = builtins.currentSystem;
    iosSdkVersion = "10.2";
    # You must accept the Android Software Development Kit License Agreement at
    # https://developer.android.com/studio/terms in order to build Android apps.
    # Uncomment and set this to `true` to indicate your acceptance:
    # config.android_sdk.accept_license = false;
  }
}:
with obelisk;
project ./. ({ pkgs, hackGet, ... }: {
  android.applicationId = "systems.obsidian.obelisk.examples.minimal";
  android.displayName = "Obelisk Minimal Example";
  ios.bundleIdentifier = "systems.obsidian.obelisk.examples.minimal";
  ios.bundleName = "Obelisk Minimal Example";
  overrides = self: super:
  let
    jsaddle-src = hackGet ./dep/jsaddle;
  in
  {
    jsaddle = self.callCabal2nix "jsaddle" (jsaddle-src + /jsaddle) {};
    jsaddle-warp = pkgs.haskell.lib.dontCheck (self.callCabal2nix "jsaddle-warp" (jsaddle-src + /jsaddle-warp) {});
    jsaddle-webkit2gtk = null;
    jsaddle-dom = pkgs.haskell.lib.dontCheck (pkgs.haskell.lib.appendPatch super.jsaddle-dom ./remove-inAnimationFrame.patch);
    reflex-dom = null;
    reflex-dom-core = pkgs.haskell.lib.dontCheck super.reflex-dom-core;
  };
})
