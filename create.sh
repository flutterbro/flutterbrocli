mkdir example
flutter create --project-name brocli --org com.flutterbro --no-pub example
cd example
dart ../bin/setup.dart all
flutter pub get
cd ..