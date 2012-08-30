#!/bin/sh

echo bin path = $BIN_PATH
echo air sdk path = $AIR_SDK_PATH
echo profile path = $PROFILE_PATH
echo cer path = $CER_PATH
echo swf path = $SWF_PATH
echo ipa path = $IPA_PATH
echo ane path = $ANE_PATH
echo ane name = $ANE_NAME

echo "==============================="

pushd "$CONFIGURATION_BUILD_DIR"

#create ext
rm -rf ext 
mkdir -p -v ext
cp -f "$ANE_PATH"/"$ANE_NAME" "$CONFIGURATION_BUILD_DIR"/ext

#copy swf
rm -f "$PRODUCT_NAME".swf
rm -f "$PRODUCT_NAME"-app.xml
cp -f "$SWF_PATH"/"$PRODUCT_NAME".swf "$CONFIGURATION_BUILD_DIR"
cp -f "$SWF_PATH"/"$PRODUCT_NAME"-app.xml "$CONFIGURATION_BUILD_DIR"

#copy mm.cfg
cp -f "$BIN_PATH"/mm.cfg "$CONFIGURATION_BUILD_DIR"

# generate IPA

rm -f "$TARGET_NAME"
rm -rf "$PRODUCT_NAME".app.dSYM

"$AIR_SDK_PATH"/bin/adt -package -target ipa-debug-interpreter -provisioning-profile "$PROFILE_PATH" -storetype pkcs12 -keystore "$CER_PATH" -storepass pass123 "$TARGET_NAME" "$PRODUCT_NAME"-app.xml "$PRODUCT_NAME".swf mm.cfg -extdir ext 

rm -f "$IPA_PATH"/"$TARGET_NAME"
rm -rf "$IPA_PATH"/"$PRODUCT_NAME".app.dSYM
cp -f "$TARGET_NAME" "$IPA_PATH"
cp -rf "$PRODUCT_NAME".app.dSYM "$IPA_PATH"

popd





