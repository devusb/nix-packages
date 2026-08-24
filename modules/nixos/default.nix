{ inputs, self, ... }:
let
  modulesPerFile = {
    overlay = import ./overlay.nix { inherit inputs self; };
    go-simple-upload-server = ./go-simple-upload-server.nix;
    wolweb = ./wolweb.nix;
    jellylex-watched = ./jellyplex-watched.nix;
    igb = ./igb.nix;
    nqptp = ./nqptp.nix;
    chiaki4deck = ./chiaki4deck.nix;
    deckbd = ./deckbd.nix;
    plex-mpv-sim = ./plex-mpv-shim.nix;
    sleep-on-lan = ./sleep-on-lan.nix;
    quakejs = ./quakejs.nix;
    hoarder-miniflux-webhook = ./hoarder-miniflux-webhook.nix;
    zz-sdjson = ./zz-sdjson.nix;
    reversepuck = ./reversepuck.nix;
    heb-mcp = ./heb-mcp;
  };

  tests = {
    heb-mcp = import ./heb-mcp/test.nix;
  };

  default =
    { ... }:
    {
      imports = builtins.attrValues modulesPerFile;
    };
in
modulesPerFile // { inherit default tests; }
