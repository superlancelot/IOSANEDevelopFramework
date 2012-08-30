#!/bin/sh

echo build dir = $BUILD_DIR
echo project dir = $PROJECT_DIR
echo configuration build dir = $CONFIGURATION_BUILD_DIR
echo air sdk path = $AIR_SDK_PATH
echo native extension swc = $NATIVEEXTENSION_SWC
echo ane path = $ANE_PATH

EXTENSION_SWC_FILE_NAME=`/usr/bin/basename "$NATIVEEXTENSION_SWC"`
echo extension swc file name = $EXTENSION_SWC_FILE_NAME

NATIVE_EXTENSION_STATIC_LIB_NAME=lib"$PRODUCT_NAME".a
echo extension static lib file name = $NATIVE_EXTENSION_STATIC_LIB_NAME

echo "==============================="

#copy the extension.xml from $PROJECT_DIR/$PRODUCT_NAME/extension.xml to "$CONFIGURATION_BUILD_DIR"
rm -f "$CONFIGURATION_BUILD_DIR"/extension.xml
cp -f "$PROJECT_DIR"/"$PRODUCT_NAME"/extension.xml "$CONFIGURATION_BUILD_DIR"

#copy the platformoptions.xml from $PROJECT_DIR/$PRODUCT_NAME/platformoptions.xml to "$CONFIGURATION_BUILD_DIR"
rm -f "$CONFIGURATION_BUILD_DIR"/platformoptions.xml
cp -f "$PROJECT_DIR"/"$PRODUCT_NAME"/platformoptions.xml "$CONFIGURATION_BUILD_DIR"

#copy the swc from the original location to current configuration directory
echo copying the swc from the original location to the "$CONFIGURATION_BUILD_DIR"
rm -f "$CONFIGURATION_BUILD_DIR"/"$EXTENSION_SWC_FILE_NAME"
cp -f "$NATIVEEXTENSION_SWC" "$CONFIGURATION_BUILD_DIR" 

#Extract library.swf from the swc
echo "Extracting library.swf from the swc provided by the user"
mkdir -p -v "$CONFIGURATION_BUILD_DIR"/swcContents
/usr/bin/unzip -o "$NATIVEEXTENSION_SWC" -d "$CONFIGURATION_BUILD_DIR"/swcContents
rm -f "$CONFIGURATION_BUILD_DIR"/library.swf
cp -f "$CONFIGURATION_BUILD_DIR"/swcContents/library.swf "$CONFIGURATION_BUILD_DIR"

#remove the directory swcContents
rm -rf "$CONFIGURATION_BUILD_DIR"/swcContents 

#Run the ADT command to generate the ANE

rm -f "$ANE_PATH"/"$TARGET_NAME"

pushd "$CONFIGURATION_BUILD_DIR"
"$AIR_SDK_PATH"/bin/adt -package -target ane "$TARGET_NAME" extension.xml -swc "$EXTENSION_SWC_FILE_NAME" -platform default library.swf -platform iPhone-ARM -platformoptions platformoptions.xml "$NATIVE_EXTENSION_STATIC_LIB_NAME" library.swf 

cp -f "$TARGET_NAME" "$ANE_PATH"/"$TARGET_NAME"

popd

echo "$TARGET_NAME" generated at "$ANE_PATH"/"$TARGET_NAME" 

