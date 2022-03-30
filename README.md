# flutter commands

flutter create -org com.carrot --platforms=android,ios carrot_market
flutter clean
flutter doctor -v
flutter build appbundle
flutter build apk
flutter build ios

# vscode shortcut

ctrl + .
alt + F12

# using packages

flutter pub get  
flutter pub add package_name

# ios build

flutter clean
rm ./ios/Podfile
rm ./ios/Podfile.lock
flutter pub get
cd ios
pod install
cd ..
flutter build ios --no-sound-null-safety
