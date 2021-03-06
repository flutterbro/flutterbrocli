// ignore_for_file: avoid_print
// ignore: always_use_package_imports
import '../../src/flutterbrocli.dart';

Future<void> setup(List<String> arguments) async {
  if (arguments.isEmpty) {
    print('Please specify command');
    return;
  }
  final command = arguments.first;
  switch (command) {
    case 'all':
      await _all();
      break;
    case 'clear':
      await _clear();
      break;
    case 'nullsafety':
      await _nullSafety();
      break;
    case 'linter':
      await _linter();
      break;
    case 'clearcode':
      await _clearCode();
      break;
    case 'freezed':
      if (arguments.length > 1) {
        final arg2 = arguments[1];
        await _setupFreezed(arg2 != '--no-ignore');
      } else {
        await _setupFreezed(true);
      }
      break;
    default:
      print('Unknown command');
      break;
  }
}

Future<void> _all() async {
  await _clear();
  await _nullSafety();
  await _linter();
  await _clearCode();
  //await _setupFreezed(true);
}

Future<void> _clear() async {
  final isFlutterProject = await SetupUtils.isFlutterProject();
  if (!isFlutterProject) {
    print(
      'lib/main.dart not found. Are you sure you`re in the right directory?',
    );

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
      'pubspec.yaml not found. Are you sure you`re in the right directory?',
    );

    return;
  }
  print('Migrating to null-safety');
  await SetupUtils.migrateToNullSafety();
}

Future<void> _linter() async {
  final isFlutterProject = await SetupUtils.isFlutterProject();
  if (!isFlutterProject) {
    print(
      'lib/main.dart not found. Are you sure you`re in the right directory?',
    );

    return;
  }
  print('Setting up linter');
  await SetupUtils.setupLinter();
}

Future<void> _clearCode() async {
  final isFlutterProject = await SetupUtils.isFlutterProject();
  if (!isFlutterProject) {
    print(
      'lib/main.dart not found. Are you sure you`re in the right directory?',
    );

    return;
  }
  print('Clearing code');
  await SetupUtils.clearCode();
}

Future<void> _setupFreezed(bool shouldIgnore) async {
  final isDartProject = await SetupUtils.isDartProject();
  if (!isDartProject) {
    print(
      'pubspec.yaml not found. Are you sure you`re in the right directory?',
    );

    return;
  }
  print('Setup freezed');
  await SetupUtils.setupFreezed(shouldIgnore);
}
