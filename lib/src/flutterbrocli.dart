import 'dart:io';

const _pubSpecYaml = 'pubspec.yaml';
const _mainDart = 'lib/main.dart';
const _newLine = '\n';
final _yamlCommentsPattern = RegExp(r'.*#.*');
final _dartCommentsPattern = RegExp(r'(.*\/\/.*)|\/\*(.*|[\s\S]*?)\*\/');

class SetupUtils {
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
      final raw = lines
          .where((element) => !element.contains(_dartCommentsPattern))
          .join(_newLine);
      final cleared = raw
          .replaceAll(_dartCommentsPattern, '')
          .replaceAll(_newLine + _newLine + _newLine, _newLine + _newLine);
      await file.delete();
      await file.create();
      await file.writeAsString(cleared);
    }
    return exists;
  }

  const SetupUtils._();
}
