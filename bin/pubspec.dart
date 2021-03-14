import 'package:flutterbrocli/flutterbrocli.dart';

Future<void> main(List<String> arguments) async {
  if (arguments.isEmpty) {
    print('Please specify command');
    return;
  }
  final command = arguments.first;
  switch (command) {
    case 'clear':
      await ProjectUtils.clearPubSpecYaml();
      break;
    default:
      print('Unknown command');
      break;
  }
}
