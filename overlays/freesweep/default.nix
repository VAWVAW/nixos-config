_final: prev: {
  freesweep = prev.freesweep.overrideAttrs (o: {
    patches = (o.patches or [ ]) ++ [ ./chars.patch ./xkg_dirs.patch ];
  });
}
