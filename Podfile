platform :ios, '16.0'

workspace 'WhereMyBus.xcworkspace'

def n_maps_pods
  pod 'NMapsMap', '~> 3.16.2'
end

target 'App' do
  project 'Projects/App/App.xcodeproj'
  n_maps_pods
end

target 'NearMapFeature' do
  project 'Projects/Feature/NearMapFeature/NearMapFeature.xcodeproj'
  n_maps_pods
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
    end
  end
end

