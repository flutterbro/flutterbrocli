import 'dart:io';

const _pubSpecYaml = 'pubspec.yaml';
const _newLine = '\n';
final _yamlCommentsPattern = RegExp(r'.*#.*');

class SetupUtils {
  static Future<void> clearPubSpecYaml() async {
    final file = File(_pubSpecYaml);
    if (await file.exists()) {
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
  }

  const SetupUtils._();
}
