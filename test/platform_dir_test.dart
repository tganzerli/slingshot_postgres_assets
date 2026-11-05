import 'dart:io';
import 'dart:isolate';

import 'package:code_assets/code_assets.dart';
import 'package:slingshot_postgres_assets/src/platform_dir.dart';
import 'package:test/test.dart';

/// The package root, from the package URI rather than the current directory.
final Uri _packageRoot = Isolate.resolvePackageUriSync(
  Uri.parse('package:slingshot_postgres_assets/'),
)!.resolve('../');

void main() {
  test('maps the four supported targets to their native/ directory', () {
    expect(platformDir(OS.macOS, Architecture.arm64), 'macos-arm64');
    expect(platformDir(OS.macOS, Architecture.x64), 'macos-x64');
    expect(platformDir(OS.linux, Architecture.arm64), 'linux-arm64');
    expect(platformDir(OS.linux, Architecture.x64), 'linux-x64');
  });

  test('has no directory for other targets', () {
    expect(platformDir(OS.windows, Architecture.x64), isNull);
    expect(platformDir(OS.android, Architecture.arm64), isNull);
    expect(platformDir(OS.iOS, Architecture.arm64), isNull);
    expect(platformDir(OS.linux, Architecture.riscv64), isNull);
  });

  // The binaries are committed only in the public repository, at release; in
  // a checkout without them this test is skipped.
  final native = Directory.fromUri(_packageRoot.resolve('native/'));
  final shipsBinaries = supportedPlatformDirs.any(
    (d) => Directory('${native.path}$d').existsSync(),
  );
  final skip = shipsBinaries ? false : 'no pre-built binaries in this checkout';
  test('ships libnative_db for every platform', () {
    for (final dir in supportedPlatformDirs) {
      final os = dir.startsWith('macos') ? OS.macOS : OS.linux;
      final name = os.dylibFileName('native_db');
      final file = File('${native.path}$dir/$name');
      expect(file.existsSync(), isTrue, reason: file.path);
    }
  }, skip: skip);
}
