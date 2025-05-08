sudo xcode-select -s /Applications/Xcode15.app
xcodebuild archive \
  -workspace Example/linkid_mmp.xcworkspace \
  -scheme linkid_mmp \
  -sdk iphonesimulator \
  -archivePath "archives/ios_simulators.xcarchive" \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  SKIP_INSTALL=NO && \
xcodebuild archive \
  -workspace Example/linkid_mmp.xcworkspace \
  -scheme linkid_mmp \
  -sdk iphoneos \
  -archivePath "archives/ios_devices.xcarchive" \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  SKIP_INSTALL=NO && \

rm -rf build/linkid_mmp.xcframework && \
# rm -rf build/CryptoSwift.xcframework && \
# rm -rf build/GRDB.xcframework && \

xcodebuild -create-xcframework \
  -framework archives/ios_devices.xcarchive/Products/Library/Frameworks/linkid_mmp.framework \
  -framework archives/ios_simulators.xcarchive/Products/Library/Frameworks/linkid_mmp.framework \
  -output build/linkid_mmp.xcframework
# xcodebuild -create-xcframework \
#   -framework archives/ios_devices.xcarchive/Products/Library/Frameworks/CryptoSwift.framework \
#   -framework archives/ios_simulators.xcarchive/Products/Library/Frameworks/CryptoSwift.framework \
#   -output build/CryptoSwift.xcframework  && \
# xcodebuild -create-xcframework \
#   -framework archives/ios_devices.xcarchive/Products/Library/Frameworks/GRDB.framework \
#   -framework archives/ios_simulators.xcarchive/Products/Library/Frameworks/GRDB.framework \
#   -output build/GRDB.xcframework  && \

# rm -rf /Users/leonacky/Data/dev/flutter_linkid_mmp/ios/linkid_mmp.xcframework  && \
# rm -rf /Users/leonacky/Data/dev/flutter_linkid_mmp/ios/CryptoSwift.xcframework  && \
# rm -rf /Users/leonacky/Data/dev/flutter_linkid_mmp/ios/GRDB.xcframework  && \

# cp -R build/linkid_mmp.xcframework /Users/leonacky/Data/dev/flutter_linkid_mmp/ios
# cp -R build/GRDB.xcframework /Users/leonacky/Data/dev/flutter_linkid_mmp/ios
# cp -R build/CryptoSwift.xcframework /Users/leonacky/Data/dev/flutter_linkid_mmp/ios
