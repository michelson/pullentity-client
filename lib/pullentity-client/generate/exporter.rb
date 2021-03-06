require 'session'
require 'faraday'
module Pullentity
  module Client
    module Generate
      class Exporter < Thor

        include ::Pullentity::Client::Utils

        class << self

          include ::Pullentity::Client::Utils

          def create(name)
            build_theme_list
            build_shared_views
            build_hash_output(name)
            create_with_template('pullentity_build.json', 'defaults/build.yml', { :json=> @full_app_hash })
          end

          def build_theme_list
            @theme_list = []
            Dir.foreach(location.join("build/views/themes") ).grep(/.html/).each do |theme|
              @theme_list << {
                :name => theme.gsub(".html", "") ,
                :content => File.open(location.join("build/views/themes/#{theme}")).readlines.join("")
              }
            end
          end

          def name_from_yaml
            yml = YAML.load(File.open(location.join("pullentity.yml")))
            return yml["theme_name"]
          end

          def build_shared_views

            @js      =  Nokogiri::HTML(File.open(location.join("build/views/shared/js.html")).readlines.join("")).css("script").first.content
            @head    =  File.open(location.join("build/views/shared/head.html")).readlines.join("")
            @css     =  Nokogiri::HTML(File.open(location.join("build/views/shared/css.html")).readlines.join("")).css("style").first.content
            @layout  =  Nokogiri::HTML(File.open(location.join("build/views/shared/body.html")).readlines.join("")).css("script").first.content
            @list    =  File.open(location.join("build/views/list.html")).readlines.join("")
          end

          def build_hash_output(name)
            @full_app_hash = {

              :theme_name => name,
              :themes => @theme_list,
              :js => @js,
              :css => @css,
              :layout => @layout,
              :head=> @head,
              :list=> @list,
              :assets => assets_hash
            }

          end

          def assets_hash
            images = []
            Dir.foreach(location.join("build/assets/images") ).grep(/.jpg|.jpeg|.png|.gif|.ico/).each do |image|
              images << image
            end

            fonts = []
            Dir.foreach(location.join("build/assets/fonts") ).grep(/.eot|.svg|.ttf|.woff/).each do |font|
              fonts << font
            end

            jss = []
            Dir.foreach(location.join("build/assets/javascripts") ).grep(/.js$/).each do |js|
              jss << js
            end

            styles = []
            Dir.foreach(location.join("build/assets/stylesheets") ).grep(/.css/).each do |css|
              styles << css
            end

            js      =  File.open(location.join("build/assets/javascripts/application.js")).readlines.join("")
            css = File.open(location.join("build/assets/stylesheets/application.css")).readlines.join("")

            { :images => images , :js => jss, :css => styles , :fonts=> fonts }

          end

          def location
            base_location
          end


          def source_root
            File.dirname(__FILE__)
          end

        end

        map %(ex) => 'export'
        desc "export", "exports a new Pullentity Client project."
        long_desc "Exports a new Pullentity project"
        def export
          begin
            name_for = YAML.load_file(location + "pullentity.yml")["theme_name"]
          rescue => e
            say "Error, make sure you are inside a pullentity project", :red
            say "and pullentity.yml file is created" , :red
            raise
          end
          name_for = YAML.load_file(location + "pullentity.yml")["theme_name"]
          ::Pullentity::Client::Builder::Middleman.build
          ::Pullentity::Client::Generate::Exporter.create(name_for)
          ::Pullentity::Client::Generate::Auth.start(['export', name_for])
        end

      end
    end
  end
end
