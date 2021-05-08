import 'dart:io';

const _pubSpecYaml = 'pubspec.yaml';
const _mainDart = 'lib/main.dart';
const _newLine = '\n';
final _yamlCommentsPattern = RegExp(r'.*#.*');
final _dartCommentsPattern = RegExp(r'(\s*\/\/.*)|\/\*(.*|[\s\S]*?)\*\/');
final _sdkLinePattern = RegExp(r'sdk:\s">=(\d+.\d+.\d+)\s*<(\d+.\d+.\d+)"');
final _nullSafeVersion = '2.12.0';
final _fixNullable = 'Key key, this.title';
final _fixNullSafe = 'Key? key, required this.title';

class SetupUtils {
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
    return false;
  }

  static Future<bool> _upToNullSafetyVersion() async {
    final file = File(_pubSpecYaml);
    final exists = await file.exists();
    if (exists) {
      final lines = await file.readAsLines();
      final raw = lines.join(_newLine);

      final sdk =
          lines.firstWhere((element) => element.contains(_sdkLinePattern));
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

  const SetupUtils._();
}
