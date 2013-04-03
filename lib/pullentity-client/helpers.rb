require "middleman"
require 'middleman-target'
URL_REMOTE = "http://pullentity.s3.amazonaws.com"

module Pullentity::Client::Helpers


  def javascript_include_tag(file)
    if target?(:pullentity)
      path = "#{URL_REMOTE}/uploads/theme_asset/#{site_name}/theme/#{theme_name}/assets/#{file}"
      "<script src='#{path}.js' type='text/javascript'></script>"
    else
      super
    end
  end

  def stylesheet_link_tag(file)
    if target?(:pullentity)
      path = "#{URL_REMOTE}/uploads/theme_asset/#{site_name}/theme/#{theme_name}/assets/#{file}"
      "<link href='#{path}.css' media='screen' rel='stylesheet' type='text/css' />"
    else
      super
    end
  end

  def test_data_include_tag
    unless target?(:pullentity)
      javascript_include_tag "pullentity/development"
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

module Pullentity::Client::MiddlemanConfig
  class << self
    def registered(app)
      app.helpers Pullentity::Client::Helpers
      app.set :site_name, site_name
      app.set :theme_name, theme_name
      app.set :sass_assets_paths, []
      app.set :relative_links, false
      app.set :images_dir,  "assets/images"
      app.set :fonts_dir,  "assets/fonts"
      app.set :css_dir,  "assets/stylesheets"
      app.set :js_dir, "assets/javascripts"
      app.set :markdown, :layout_engine => :haml
      app.set :default_encoding, 'utf-8'

      app.compass_config do |config|
        # config is the Compass.configuration object
        config.output_style = :compact
        if target?(:pullentity)
          config.http_images_path = "#{URL_REMOTE}/uploads/theme_asset/#{site_name}/theme/#{theme_name}/assets"
        end
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

    alias :included :registered
  end
end

::Middleman::Extensions.register(:pullentity_config, Pullentity::Client::MiddlemanConfig)