_final: prev: {
  ckbcomp = prev.ckbcomp.override {
    xkeyboard_config = prev.xkeyboard_config.overrideAttrs
      (o: { patches = (o.patches or [ ]) ++ [ ./custom.patch ]; });
  };
}
