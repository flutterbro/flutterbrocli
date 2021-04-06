import 'package:flutterbrocli/src/flutterbrocli.dart';

Future<void> setup(List<String> arguments) async {
  if (arguments.isEmpty) {
    print('Please specify command');
    return;
  }
  final command = arguments.first;
  switch (command) {
    case 'clear':
      await _clear();
      break;
    case 'nullsafety':
      await _nullSafety();
      break;
    default:
      print('Unknown command');
      break;
  }
}

Future<void> _clear() async {
  final isFlutterProject = await SetupUtils.isFlutterProject();
  if (!isFlutterProject) {
    print(
        'lib/main.dart not found. Are you sure you`re in the right directory?');
    return;
  }
  print('Removing comments from pubspec.yaml');
  await SetupUtils.clearPubSpecYaml();
  print('Removing comments from lib/main.dart');
  await SetupUtils.clearMainDart();
}

Future<void> _nullSafety() async {
  final isDartProject = await SetupUtils.isDartProject();
  if (!isDartProject) {
    print(
        'pubspec.yaml not found. Are you sure you`re in the right directory?');
    return;
  }
  print('Migrating to null-safety');
  await SetupUtils.migrateToNullSafety();
}
