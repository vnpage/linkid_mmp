xcodebuild archive \
  -scheme linkid_mmp \
  -sdk iphonesimulator \
  -archivePath "archives/ios_simulators.xcarchive" \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  SKIP_INSTALL=NO && \
xcodebuild archive \
  -scheme linkid_mmp \
  -sdk iphoneos \
  -archivePath "archives/ios_devices.xcarchive" \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  SKIP_INSTALL=NO && \
rm -rf build/linkid_mmp.xcframework && \
xcodebuild -create-xcframework \
    -framework archives/ios_devices.xcarchive/Products/Library/Frameworks/linkid_mmp.framework \
   -framework archives/ios_simulators.xcarchive/Products/Library/Frameworks/linkid_mmp.framework \
  -output build/linkid_mmp.xcframework
rm -rf /Users/leonacky/Data/dev/flutter_linkid_mmp/ios/linkid_mmp.xcframework
cp -R build/linkid_mmp.xcframework /Users/leonacky/Data/dev/flutter_linkid_mmp/ios
