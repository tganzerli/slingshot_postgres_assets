/// Opt-in companion of `slingshot_postgres` that carries only a build hook.
///
/// Add it to an app built with `dart build cli` and the pre-built native
/// library lands in `bundle/lib/`, found by the driver without copying files
/// or setting `DART_DB_CONNECTOR_NATIVE_LIB_PATH`. There is nothing to import.
///
/// Any package with a build hook makes `dart compile exe` refuse to build the
/// app, so keep this package out of apps compiled that way.
library;
