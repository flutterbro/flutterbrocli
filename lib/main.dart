import 'package:flutterbrocli/flutterbrocli.dart';

Future<void> main(List<String> arguments) async {
  await ProjectUtils.clearPubSpecYaml();
}
