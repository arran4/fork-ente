// ignore_for_file: deprecated_member_use

import "dart:async";
import "package:ente_auth/main.dart" as entrypoint;

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  await entrypoint.main();
}
