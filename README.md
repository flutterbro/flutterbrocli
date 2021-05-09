Flutter Bro command line tools.

# Getting started

1. Add dev dependency to your pubspec.yaml:
```yaml
dev_dependencies:
# other dependencies
  flutterbrocli:
    git:
      url: https://github.com/flutterbro/flutterbrocli.git
      ref: 0.1.0
``` 
2. Run from the command line: `flutter pub run flutterbrocli:setup all`

# Development

1. Call `create.sh` for creating an example with automated setup.
2. Call `clear.sh` for deleting example.