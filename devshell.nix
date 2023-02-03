{ buildEnv
, writeTextFile
, bashInteractive
, coreutils
, system
}:

{ name ? "clean-devshell"
, packages ? [ ]
}:

let
  bashPath = "${bashInteractive}/bin/bash";
  profile = buildEnv {
    name = "clean-devshell-env";
    paths = packages;
  };
in

derivation {
  inherit name system;

  builder = bashPath;
  #args = [ "-ec" "${coreutils}/bin/ln -s ${profile} $out" ];
  args = [ "-ec" "printf '%s\n' ${profile} > $out" ];
  stdenv = writeTextFile {
    name = "clean-devshell-stdenv";
    destination = "/setup";
    text = ''
      # Fix for `nix develop`
      : ''${outputs:=out}
      runHook() { eval "$shellHook"; unset runHook; }
    '';
  };

  PATH = "${profile}/bin";

  shellHook = ''
    unset NIX_BUILD_TOP NIX_BUILD_CORES NIX_STORE
    unset TEMP TEMPDIR TMP TMPDIR

    # $name variable is preserved to keep it compatible with pure shell https://github.com/sindresorhus/pure/blob/47c0c881f0e7cfdb5eaccd335f52ad17b897c060/pure.zsh#L235
    unset builder out shellHook stdenv system

    # Flakes stuff
    unset dontAddDisableDepTrack outputs

    # For `nix develop`. We get /noshell on Linux and /sbin/nologin on macOS.
    if [[ "$SHELL" == "/noshell" || "$SHELL" == "/sbin/nologin" ]]; then
      export SHELL=${bashPath}
    fi
  '';
}
