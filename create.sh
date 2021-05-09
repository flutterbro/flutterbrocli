mkdir example
flutter create --project-name brocli --org com.flutterbro --no-pub example
cd example
dart ../bin/setup.dart clear
dart ../bin/setup.dart nullsafety
dart ../bin/setup.dart linter
flutter pub get
cd ..