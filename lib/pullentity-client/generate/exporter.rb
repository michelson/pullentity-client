require 'session'

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

          def build_shared_views
            # nokogiri remove scrpt tag
            @js      =  File.open(location.join("build/views/shared/js.html")).readlines.join("")
            @head    =  File.open(location.join("build/views/shared/head.html")).readlines.join("")
            # nokogiri remove scrpt tag
            @css     =  File.open(location.join("build/views/shared/css.html")).readlines.join("")
            @layout  =  File.open(location.join("build/views/shared/body.html")).readlines.join("")
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
            js      =  File.open(location.join("build/assets/javascripts/application.js")).readlines.join("")
            css = File.open(location.join("build/assets/stylesheets/application.css")).readlines.join("")

            { :images => images , :js => js, :css => css , :fonts=> fonts }

          end

          def location
            base_location
          end


          def source_root
            File.dirname(__FILE__)
          end

        end

        map %(n) => 'new'
        desc "exporter new <name> ", "exports a new Pullentity Client project."
        long_desc "Exports a new Pullentity project"
        def new(name)
          ::Pullentity::Client::Builder::Middleman.build
          ::Pullentity::Client::Generate::Exporter.create(name)

        end

      end
    end
  end
end
