import 'package:code_assets/code_assets.dart';

/// The platforms with a pre-built `libnative_db`, as `native/<dir>/` names.
const supportedPlatformDirs = [
  'macos-arm64',
  'macos-x64',
  'linux-arm64',
  'linux-x64',
];

/// The `native/` subdirectory holding the pre-built library for a target, or
/// null when the target has none (mobile, Windows, other architectures).
String? platformDir(OS os, Architecture arch) => switch ((os, arch)) {
  (OS.macOS, Architecture.arm64) => 'macos-arm64',
  (OS.macOS, Architecture.x64) => 'macos-x64',
  (OS.linux, Architecture.arm64) => 'linux-arm64',
  (OS.linux, Architecture.x64) => 'linux-x64',
  _ => null,
};
