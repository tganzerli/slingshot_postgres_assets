// Registers the pre-built `libnative_db` of slingshot_postgres as a code asset,
// so `dart build cli` copies it into `bundle/lib/`, where the slingshot library
// resolver looks for it.
//
// The hook never fails a build: an unsupported target (mobile, Windows) or a
// missing binary yields no asset, and the resolver falls back to its other
// candidates.
import 'dart:io';

import 'package:code_assets/code_assets.dart';
import 'package:hooks/hooks.dart';
import 'package:slingshot_postgres_assets/src/platform_dir.dart';

void main(List<String> args) async {
  await build(args, (input, output) async {
    if (!input.config.buildCodeAssets) return;
    final code = input.config.code;
    final dir = platformDir(code.targetOS, code.targetArchitecture);
    if (dir == null) return;

    // `native/` always exists (it holds a tracked `.gitkeep`), so declaring it
    // makes the runner re-run the hook when a platform directory appears; the
    // platform directory, once present, covers the binary changing. The runner
    // lists every declared directory, so a missing one is never declared.
    final nativeDir = input.packageRoot.resolve('native/');
    final platformUri = nativeDir.resolve('$dir/');
    for (final d in [nativeDir, platformUri]) {
      if (Directory.fromUri(d).existsSync()) output.dependencies.add(d);
    }

    final file = platformUri.resolve(code.targetOS.dylibFileName('native_db'));
    if (!File.fromUri(file).existsSync()) return;

    output.assets.code.add(
      CodeAsset(
        package: input.packageName,
        name: 'native_db',
        linkMode: DynamicLoadingBundled(),
        file: file,
      ),
    );
  });
}
