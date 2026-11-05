## 0.1.0

- Build hook that registers `native/<os>-<arch>/libnative_db.*` as a bundled
  code asset for macOS and Linux (arm64, x64). No asset on other targets or
  when the binary is missing.
