mkdir example
flutter create --project-name brocli --org com.flutterbro --no-pub example
cd example
dart ../bin/setup.dart clear
dart ../bin/setup.dart nullsafety
flutter pub get
cd ..