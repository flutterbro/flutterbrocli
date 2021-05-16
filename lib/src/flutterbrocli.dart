// ignore_for_file: avoid_print
import 'dart:io';

import 'package:http/http.dart' as http;

const _pubSpecYaml = 'pubspec.yaml';
const _mainDart = 'lib/main.dart';
const _newLine = '\n';
final _yamlCommentsPattern = RegExp(r'.*#.*');
final _dartCommentsPattern = RegExp(r'(\s*\/\/.*)|\/\*(.*|[\s\S]*?)\*\/');
final _sdkLinePattern = RegExp(r'sdk:\s">=(\d+.\d+.\d+)\s*<(\d+.\d+.\d+)"');
const _nullSafeVersion = '2.12.0';
const _fixNullable = 'Key key, this.title';
const _fixNullSafe = 'Key? key, required this.title';

// Linter config
const _analysisOptionsYaml = 'analysis_options.yaml';
const dartCodeMetrics = '  dart_code_metrics:^3.1.0';
const _rawRulesLink =
    'https://gist.githubusercontent.com/flutterbro/88366c39b2cbed329e2aaddbfea3f9dd/raw/e31fdb37f83ee47180e7bc3bdfd6c7a09e034969/bro_linter.yaml';

// Clear code
const _rawSimpleMainLink =
    'https://gist.githubusercontent.com/flutterbro/88366c39b2cbed329e2aaddbfea3f9dd/raw/a04c1c5523ebc83d0501cc8bcbe12a1b836957be/bro_simple_main.dart';
const _testDirName = 'test';

// freezed
const _buildRunner = 'build_runner:^2.0.3';
const _freezedVersion = '0.14.2';
const _freezed = 'freezed:^$_freezedVersion';
const _freezedAnnitations = 'freezed_annotation:^$_freezedVersion';
const _jsonSerializable = 'json_serializable:^4.1.2';
const _jsonSerializableAnnotation = 'json_annotation: ^4.0.1';

class SetupUtils {
  const SetupUtils._();

  static Future<bool> isDartProject() async {
    final file = File(_pubSpecYaml);
    final exists = await file.exists();
    return exists;
  }

  static Future<bool> isFlutterProject() async {
    final file = File(_mainDart);
    final exists = await file.exists();
    return exists;
  }

  static Future<bool> clearPubSpecYaml() async {
    final file = File(_pubSpecYaml);
    final exists = await file.exists();
    if (exists) {
      final lines = await file.readAsLines();
      final raw = lines
          .where((element) => !element.contains(_yamlCommentsPattern))
          .join(_newLine);
      final cleared = raw
          .replaceAll(_yamlCommentsPattern, '')
          .replaceAll(_newLine + _newLine + _newLine, _newLine + _newLine);
      await file.delete();
      await file.create();
      await file.writeAsString(cleared);
    }
    return exists;
  }

  static Future<bool> clearMainDart() async {
    final file = File(_mainDart);
    final exists = await file.exists();
    if (exists) {
      final lines = await file.readAsLines();
      final raw = lines.join(_newLine);
      final cleared = raw
          .replaceAll(_dartCommentsPattern, '')
          .replaceAll(_newLine + _newLine + _newLine, _newLine + _newLine);
      await file.delete();
      await file.create();
      await file.writeAsString(cleared);
    }
    return exists;
  }

  static Future<bool> migrateToNullSafety() async =>
      await _upToNullSafetyVersion() && await _migrateDefaultMain();

  static Future<bool> setupLinter() async {
    final result =
        await Process.run('dart', ['pub', 'add', '--dev', dartCodeMetrics]);
    print(result.stdout);

    final file = File(_analysisOptionsYaml);
    final exists = await file.exists();
    if (!exists) {
      await file.create();
      final rules = await http.get(Uri.parse(_rawRulesLink));
      await file.writeAsString(rules.body);
    }
    return !exists;
  }

  static Future<bool> setupFreezed() async {
    var result =
        await Process.run('dart', ['pub', 'add', '--dev', _buildRunner]);
    print(result.stdout);
    result = await Process.run('dart', ['pub', 'add', '--dev', _freezed]);
    print(result.stdout);
    result =
        await Process.run('dart', ['pub', 'add', '--dev', _jsonSerializable]);
    print(result.stdout);
    result = await Process.run('dart', ['pub', 'add', _freezedAnnitations]);
    print(result.stdout);
    result =
        await Process.run('dart', ['pub', 'add', _jsonSerializableAnnotation]);
    print(result.stdout);
    return true;
  }

  static Future<bool> clearCode() async {
    final file = File(_mainDart);
    final exists = await file.exists();
    if (exists) {
      await file.delete();
    }
    await file.create();
    final simpleMain = await http.get(Uri.parse(_rawSimpleMainLink));
    await file.writeAsString(simpleMain.body);

    final testDir = Directory(_testDirName);
    final testDirExists = await testDir.exists();
    if (testDirExists) {
      await testDir.delete(recursive: true);
    }
    return true;
  }

  static Future<bool> _upToNullSafetyVersion() async {
    final file = File(_pubSpecYaml);
    final exists = await file.exists();
    if (exists) {
      final lines = await file.readAsLines();
      final raw = lines.join(_newLine);

      final sdk =
          lines.firstWhere((element) => element.contains(_sdkLinePattern));
      // ignore: avoid-non-null-assertion
      final bottomVersion = _sdkLinePattern.allMatches(sdk).first.group(1)!;
      final fullMatch =
          sdk.replaceFirst(bottomVersion, _nullSafeVersion).trim();
      final cleared = raw.replaceAll(_sdkLinePattern, fullMatch);

      await file.delete();
      await file.create();

      await file.writeAsString(cleared);
    }
    return exists;
  }

  static Future<bool> _migrateDefaultMain() async {
    final file = File(_mainDart);
    final exists = await file.exists();
    if (exists) {
      final lines = await file.readAsLines();
      final raw = lines.join(_newLine);

      final cleared = raw.replaceAll(_fixNullable, _fixNullSafe);

      await file.delete();
      await file.create();

      await file.writeAsString(cleared);
    }
    return exists;
  }
}
