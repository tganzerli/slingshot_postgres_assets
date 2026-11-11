## 0.1.1

- Bundles the native library of `slingshot_postgres` 0.1.11, rebuilt with the fix that reports a server FATAL
  over a dead link as a lost connection. No change to the build hook.

## 0.1.0

- Build hook that registers `native/<os>-<arch>/libnative_db.*` as a bundled
  code asset for macOS and Linux (arm64, x64). No asset on other targets or
  when the binary is missing.
