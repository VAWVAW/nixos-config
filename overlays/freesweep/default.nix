_final: prev: {
  freesweep = prev.freesweep.overrideAttrs (o: {
    patches = (o.patches or [ ])
      ++ [ ./chars.patch ./flag.patch ./xkg_dirs.patch ];
  });
}
