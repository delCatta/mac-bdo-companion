.PHONY: build archive clean

APP_NAME = BDO Companion
SCHEME = BDOCompanion
BUILD_DIR = build
ARCHIVE_PATH = $(BUILD_DIR)/$(SCHEME).xcarchive
EXPORT_PATH = $(BUILD_DIR)/export
ZIP_NAME = BDOCompanion.zip

build:
	xcodegen generate
	xcodebuild -project $(SCHEME).xcodeproj \
		-scheme $(SCHEME) \
		-configuration Release \
		-destination 'platform=macOS' \
		build

archive:
	xcodegen generate
	xcodebuild -project $(SCHEME).xcodeproj \
		-scheme $(SCHEME) \
		-configuration Release \
		-archivePath $(ARCHIVE_PATH) \
		archive
	xcodebuild -exportArchive \
		-archivePath $(ARCHIVE_PATH) \
		-exportPath $(EXPORT_PATH) \
		-exportOptionsPlist ExportOptions.plist
	cd $(EXPORT_PATH) && zip -r ../$(ZIP_NAME) "$(APP_NAME).app"
	@echo "Built: $(BUILD_DIR)/$(ZIP_NAME)"

clean:
	rm -rf $(BUILD_DIR) $(SCHEME).xcodeproj
