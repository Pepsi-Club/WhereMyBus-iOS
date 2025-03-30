init: fetch gen
	
fetch:
	tuist clean
	tuist install
gen:
	tuist generate --no-open

getig:
	@echo "Select config source:"
	@echo " 1) global"
	@echo " 2) local"
	@read -p "Enter choice [1 or 2]: " choice; \
	if [ "$$choice" = "1" ]; then \
	  echo "Using GITHUB_ACCESS_TOKEN from global config"; \
	  GITHUB_ACCESS_TOKEN=$$(git config --global user.password); \
	elif [ "$$choice" = "2" ]; then \
	  echo "Using GITHUB_ACCESS_TOKEN from local config"; \
	  GITHUB_ACCESS_TOKEN=$$(git config user.password); \
	else \
	  echo "Invalid choice: $$choice. Aborting..."; \
	  exit 1; \
	fi; \
	$(MAKE) download-privates token=$$GITHUB_ACCESS_TOKEN

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
	@echo "Downloading $(3) to $(1) using token: $(2)"
	mkdir -p $(1)
	curl -H "Authorization: token $(2)" -o $(1)/$(3) $(BASE_URL)/$(3)
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
