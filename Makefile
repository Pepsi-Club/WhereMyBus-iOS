init: fetch gen
	
fetch:
	tuist clean
	tuist install
gen:
	tuist generate --no-open
	@find Tuist/.build/tuist-derived -name "project.pbxproj" -exec sed -i '' \
		's/IPHONEOS_DEPLOYMENT_TARGET = 12\.0/IPHONEOS_DEPLOYMENT_TARGET = 16.0/g; s/IPHONEOS_DEPLOYMENT_TARGET = 13\.0/IPHONEOS_DEPLOYMENT_TARGET = 16.0/g' {} \;
	@echo "✅ Deployment target patched (Xcode 27 fix)"

sign:
	@GIT_TOKEN=$$(git config user.password || git config --global user.password); \
	if [ -z "$$GIT_TOKEN" ]; then \
		echo "❌ Git token not found."; \
		exit 1; \
	fi; \
	$(MAKE) download-privates token=$$GIT_TOKEN && \
	fastlane sync

clean:
	rm -rf **/**/**/*.xcodeproj
	rm -rf **/**/*.xcodeproj
	rm -rf **/*.xcodeproj
	rm -rf *.xcworkspace
	rm -rf **/**/**/Derived/
	rm -rf **/**/Derived/
	rm -rf **/Derived/
	rm -rf Derived/
	
update_tuist:
	sh ./Scripts/update_tuist.sh

open_plist:
	open -a Xcode Plugins/EnvironmentPlugin/ProjectDescriptionHelpers/InfoPlist.swift

open_config:
	open -a Xcode Plugins/EnvironmentPlugin/ProjectDescriptionHelpers/XCConfig.swift

clean_xcode_cache:
	rm -rf ~/Library/Developer/Xcode/DerivedData/*
	
BASE_URL = https://raw.githubusercontent.com/Pepsi-Club/WhereMyBus-ignored/main

define download_file
	@echo "📥 Downloading $(strip $(3)) to $(strip $(1))"
	mkdir -p $(strip $(1))
	@curl -fsS -H "Authorization: token $(strip $(2))" -o $(strip $(1))/$(strip $(3)) $(BASE_URL)/$(strip $(3))
endef

.PHONY: download-privates

download-privates: download-xcconfigs download-env download-googleinfo

download-xcconfigs:
	$(call download_file, XCConfig, $(token),Secrets_Debug.xcconfig)
	$(call download_file, XCConfig, $(token),Secrets_Release.xcconfig)
	$(call download_file, XCConfig, $(token),App_Debug.xcconfig)
	$(call download_file, XCConfig, $(token),App_Release.xcconfig)
	$(call download_file, XCConfig, $(token),App_Common.xcconfig)
	$(call download_file, XCConfig, $(token),Widget_Debug.xcconfig)
	$(call download_file, XCConfig, $(token),Widget_Release.xcconfig)

download-env:
	$(call download_file, fastlane, $(token),.env)
	
download-googleinfo:
	$(call download_file, Projects/App/Resources, $(token),GoogleService-Info.plist)
	$(call download_file, Projects/App/Resources, $(token),GoogleService-Info-debugging.plist)
