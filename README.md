# clean-devshell

Nix devShell without envvar clutter. Derivation & idea borrowed from [numtide/devshell](https://github.com/numtide/devshell).

## Features

*Borrowing major selling points from [numtide/devshell](https://github.com/numtide/devshell)*

### Compatible

Keep it compatible with:

- nix-shell
- direnv
- nix flakes


### Clean environment

`pkgs.stdenv.mkDerivation` and `pkgs.mkShell` build on top of the `pkgs.stdenv` which introduces all sort of dependencies. Each added package, like the `pkgs.go` in the "Story time!" section has the potential of adding new environment variables, which then need to be unset. The stdenv itself contains either GCC or Clang which makes it hard to select a specific C compiler.

This is why this project builds its environment from `builtins.derivation`.

direnv loads will change from:

```
direnv: export +AR +AS +CC +CONFIG_SHELL +CXX +HOST_PATH +IN_NIX_SHELL +LD +NIX_BINTOOLS +NIX_BINTOOLS_WRAPPER_TARGET_HOST_x86_64_unknown_linux_gnu +NIX_BUILD_CORES +NIX_BUILD_TOP +NIX_CC +NIX_CC_WRAPPER_TARGET_HOST_x86_64_unknown_linux_gnu +NIX_CFLAGS_COMPILE +NIX_ENFORCE_NO_NATIVE +NIX_HARDENING_ENABLE +NIX_INDENT_MAKE +NIX_LDFLAGS +NIX_STORE +NM +OBJCOPY +OBJDUMP +RANLIB +READELF +RUSTC +SIZE +SOURCE_DATE_EPOCH +STRINGS +STRIP +TEMP +TEMPDIR +TMP +TMPDIR +buildInputs +buildPhase +builder +builtDependencies +cargo_bins_jq_filter +cargo_build_options +cargo_options +cargo_release +cargo_test_options +cargoconfig +checkPhase +configureFlags +configurePhase +cratePaths +crate_sources +depsBuildBuild +depsBuildBuildPropagated +depsBuildTarget +depsBuildTargetPropagated +depsHostHost +depsHostHostPropagated +depsTargetTarget +depsTargetTargetPropagated +doCheck +doInstallCheck +docPhase +dontAddDisableDepTrack +dontUseCmakeConfigure +installPhase +name +nativeBuildInputs +out +outputs +patches +preInstallPhases +propagatedBuildInputs +propagatedNativeBuildInputs +remapPathPrefix +shell +src +stdenv +strictDeps +system +version ~PATH
```

to:

```
direnv: export +IN_NIX_SHELL +name ~PATH
```

## Usage

TODO: refine this

```nix
let
  mkShell = pkgs.callPackage clean-devshell.lib.mkDevShell {};
in

mkShell {
  packages = [
    pkgs.cargo
    pkgs.rust-analyzer
    pkgs.rustfmt
  ];
}
```

## License

MIT.
