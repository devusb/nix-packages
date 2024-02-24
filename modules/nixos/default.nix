let
  modulesPerFile = {
    overlay = ./overlay.nix;
    go-simple-upload-server = ./go-simple-upload-server.nix;
    wolweb = ./wolweb.nix;
    jellylex-watched = ./jellyplex-watched.nix;
    igb = ./igb.nix;
    nqptp = ./nqptp.nix;
    chiaki4deck = ./chiaki4deck.nix;
    deckbd = ./deckbd.nix;
    plex-mpv-sim = ./plex-mpv-shim.nix;
    sleep-on-lan = ./sleep-on-lan.nix;
    sunshine = ./sunshine.nix;
    quakejs = ./quakejs.nix;
  };

  default = { ... }: {
    imports = builtins.attrValues modulesPerFile;
  };
in
modulesPerFile // { inherit default; }
