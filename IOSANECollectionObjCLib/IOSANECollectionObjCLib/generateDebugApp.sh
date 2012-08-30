#!/bin/sh

echo ipa path = $IPA_PATH

echo "==============================="

pushd "$CONFIGURATION_BUILD_DIR"

#copy ipa
cp "$IPA_PATH"/"$PRODUCT_NAME".ipa "$CONFIGURATION_BUILD_DIR"/"$PRODUCT_NAME".ipa.zip
cp "$IPA_PATH"/"$PRODUCT_NAME".app.dSYM "$CONFIGURATION_BUILD_DIR"/"$PRODUCT_NAME".app.dSYM 

# extract the IPA
rm -rf "Payload"
unzip -o "$PRODUCT_NAME".ipa.zip
rm "$PRODUCT_NAME".ipa.zip

# copy the contents of the IPA to the location xcode wants
cp -r Payload/"$PRODUCT_NAME".app/* "${CONFIGURATION_BUILD_DIR}/${CONTENTS_FOLDER_PATH}/"
cp -r "$PRODUCT_NAME".app.dSYM "${CONFIGURATION_BUILD_DIR}/${CONTENTS_FOLDER_PATH}/"

# remove the following files and folders to avoid signature errors when installing the app
rm "${CONFIGURATION_BUILD_DIR}/${CONTENTS_FOLDER_PATH}/_CodeSignature/CodeResources"
rmdir "${CONFIGURATION_BUILD_DIR}/${CONTENTS_FOLDER_PATH}/_CodeSignature"
rm "${CONFIGURATION_BUILD_DIR}/${CONTENTS_FOLDER_PATH}/CodeResources"
rm "${CONFIGURATION_BUILD_DIR}/${CONTENTS_FOLDER_PATH}/PkgInfo"

popd


