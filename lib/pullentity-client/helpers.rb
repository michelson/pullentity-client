require "middleman"
require 'middleman-target'

module Pullentity::Client::Helpers

    def javascript_include_tag(file)

      if target?(:pullentity)
        path = "/uploads/theme_asset/#{site_name}/theme/#{theme_name}/assets/#{file}"
        "<script src='#{path}.js' type='text/javascript'></script>"
      else
        super
      end

    end

    def test_data_include_tag
      unless target?(:pullentity)
        javascript_include_tag "test-data"
      end
   end
    def site_name
      hsh = YAML.load_file(location + "pullentity.yml")
      hsh["site"]
    end

    def theme_name
      hsh = YAML.load_file(location + "pullentity.yml")
      hsh["theme_name"]
    end

    def location
      @location ||= Pathname.new(Dir.pwd)
    end

    def asset_pathxxxx(file)
      if target?(:pullentity)
        'yea'
      else
        super
      end
    end


end