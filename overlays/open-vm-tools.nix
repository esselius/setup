final: prev: {
  open-vm-tools = prev.open-vm-tools.overrideAttrs (old: {
    postPatch = old.postPatch + ''
      sed -i 's,/usr/bin/,/run/current-system/sw/bin/,g' services/plugins/vix/foundryToolsDaemon.c
      sed -i 's,/usr/bin/,/run/current-system/sw/bin/,g' vmhgfs-fuse/config.c
    '';
  });
}
