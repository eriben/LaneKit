class LaneKit::Generate < Thor
  
  @@lanekit_version = LaneKit::VERSION;
  @@generate_date = Date.today.to_s

  def self.source_root
    File.dirname('./')
  end
  
  desc "pod POD_NAME", "Adds a CocoaPods pod to the Podfile"
  def pod(pod_name)
    pod_name = pod_name.strip
    validate_message = LaneKit.validate_pod_name(pod_name)
    if validate_message
      puts "***error: #{validate_message}"
      return
    end
    
    LaneKit.add_pod_to_podfile(pod_name)
  end

  no_tasks do
    def source_paths
      LaneKit.template_folders
    end

    def update_xcode_project
      xcworkspace_path = ""
      Xcodeproj::Workspace.new_from_xcworkspace(xcworkspace_path)
    end
  end

  @@template_opts = {
    :command => LaneKit::CLI.command,
    :generate_date => @@generate_date,
    :lanekit_version => @@lanekit_version
  }

  require 'lanekit/generate/model'
  require 'lanekit/generate/provider'
  require 'lanekit/generate/tableviewcontroller'
  require 'lanekit/generate/urbanairship'

  class_option :use_core_data, :type => :boolean, :default => false, :banner => "generate code compatible with Core Data (the default is false)", :aliases => "-c"     # option --use_core_data=true
end
