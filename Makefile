generate:
	tuist fetch
	tuist generate

clean:
	rm -rf **/**/**/*.xcodeproj
	rm -rf **/**/*.xcodeproj
	rm -rf **/*.xcodeproj
	rm -rf *.xcworkspace
	rm -rf **/**/**/Derived/
	rm -rf **/**/Derived/
	rm -rf **/Derived/
	rm -rf Derived/

reset:
	tuist clean
	rm -rf **/**/**/*.xcodeproj
	rm -rf **/**/*.xcodeproj
	rm -rf **/*.xcodeproj
	rm -rf *.xcworkspace

regenerate:
	rm -rf **/**/**/*.xcodeproj
	rm -rf **/**/*.xcodeproj
	rm -rf **/*.xcodeproj
	rm -rf *.xcworkspace
	tuist generate
