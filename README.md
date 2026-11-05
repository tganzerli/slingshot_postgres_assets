# slingshot_postgres_assets

Opt-in companion of [`slingshot_postgres`](https://github.com/tganzerli/slingshot_postgres) that carries one thing: a
build hook that bundles the driver's pre-built native library, so an app built with `dart build cli` runs without
copying `libnative_db` by hand or setting `DART_DB_CONNECTOR_NATIVE_LIB_PATH`.

```bash
dart pub add slingshot_postgres slingshot_postgres_assets
dart build cli -o out
./out/bundle/bin/<app>         # finds out/bundle/lib/libnative_db.*
```

There is nothing to import. The hook registers `native/<os>-<arch>/libnative_db.*` as a code asset, and the
`slingshot` library resolver looks in `bundle/lib/` right after the executable's own directory.

## When not to add it

Any package with a build hook makes `dart compile exe` refuse to build the app:

```
'dart compile' does not support build hooks, use 'dart build' instead.
```

Apps compiled with `dart compile exe` (the container recipe in the `slingshot_postgres` README) should leave this
package out. That is why the hook lives here and not in the driver.

## Platforms

macOS and Linux, arm64 and x64, the same matrix as the driver's pre-built binaries. On any other target (iOS, Android,
Windows) the hook adds no asset and the build goes on; the driver itself does not support those targets.

The library links dynamically against libpq, so the machine that runs the app still needs libpq installed.

## Requirements

Dart 3.10 or later (build hooks), and `slingshot` 1.0.5 or later, whose resolver checks `bundle/lib/`. This package
depends on it, so the pub solver picks a release that has the step.
