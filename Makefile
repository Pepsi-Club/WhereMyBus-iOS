open_plist:
	open -a Xcode Plugins/EnvironmentPlugin/ProjectDescriptionHelpers/InfoPlist.swift

open_config:
	open -a Xcode Plugins/EnvironmentPlugin/ProjectDescriptionHelpers/XCConfig.swift

clean_xcode:
	rm -rf ~/Library/Developer/Xcode/DerivedData/*
	
clean:
	rm -rf **/**/**/*.xcodeproj
	rm -rf **/**/*.xcodeproj
	rm -rf **/*.xcodeproj
	rm -rf *.xcworkspace
	rm -rf **/**/**/Derived/
	rm -rf **/**/Derived/
	rm -rf **/Derived/
	rm -rf Derived/
	
clean_all:
	make clean
	make clean_xcode

BASE_URL = https://raw.githubusercontent.com/Pepsi-Club/WhereMyBus-ignored/main

define download_file
	@echo "Downloading $(3) to $(1) using token: $(2)"
	mkdir -p $(1)
	curl -H "Authorization: token $(2)" -o $(1)/$(3) $(BASE_URL)/$(3)
endef

.PHONY: download-privates

download-privates: download-xcconfigs download-env download-googleinfo download-googleinfo2

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

download-googleinfo2:
	$(call download_file, Projects/App/Resources, $(token),GoogleService-Info-debugging.plist)

