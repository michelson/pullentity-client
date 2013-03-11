module Pullentity
  module Client
  module Utils
    include Thor::Actions

    def self.source_root
       File.dirname(__FILE__)
    end

    def create_new_file(name, file=nil)
      log "Creating #{name}"
      contents = file.nil? ? '' : File.read(file)
      unless File.file?(location.join(name))
        File.open(location.join(name), 'w') { |f| f.write(contents) }
      end
    end

    def remove_files(*files)
      files.each do |file|
        log "Removing #{file} file."
        FileUtils.rm(location.join(file))
      end
    end

    def touch(*filenames)
      filenames.each do |filename|
        log "Creating #{filename} file."
        FileUtils.touch(location.join(filename))
      end
    end

    def create_directories(*dirs)
      dirs.each do |dir|
        log "Creating the #{dir} directory."
        FileUtils.mkdir_p(location.join(dir))
      end
    end

    def remove_directories(*names)
      names.each do |name|
        log "Removing #{name} directory."
        FileUtils.rm_rf(location.join(name))
      end
    end

    def create_with_template(name, template_location, contents={})
      template    = templates("#{template_location}.erb")
      eruby       = Erubis::Eruby.new(File.read(template))
      File.open(location.join(name.gsub(/^\//, '')), 'w') { |f| f.write(eruby.result(contents))}
    end

    def templates(path)
      ::Pullentity::Client.root.join('pullentity-client/templates').join(path)
    end

    def log(msg)
      ::Pullentity::Client::Logger.report(msg)
    end

    def error(msg)
      ::Pullentity::Client::Logger.error(msg)
    end

    def base_location
      @location ||= Pathname.new(Dir.pwd)
    end

    alias_method :location, :base_location

    def underscore(string)
      string.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase
    end

  end

  end
end
