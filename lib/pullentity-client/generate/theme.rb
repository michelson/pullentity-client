require 'session'

module Pullentity
  module Client
    module Generate
      class Theme < Thor

        include ::Pullentity::Client::Utils

        #map %(n) => 'sites'
        desc "sites", "list sites, needs auth_token."
        long_desc "sites, needs auth token, run pullentity login help."
        def sites
          ::Pullentity::Client::Generate::Auth.start(['list_sites'])
        end

        #map %(x) => 'export'
        desc "export", "exports a new Pullentity Client project."
        long_desc "builds & exports site to theme."
        def export
          ::Pullentity::Client::Generate::Exporter.start(['export'])
        end

        #map %(n) => 'select'
        desc "select_site", "needs auth_token."
        long_desc "select_site, needs auth token , run pullentity login help."
        def select_site
          ::Pullentity::Client::Generate::Auth.start(['select_site'])
        end

        #map %(n) => 'select'
        desc "make_defalt", "needs auth_token."
        long_desc "make default site"
        def make_default
          ::Pullentity::Client::Generate::Exporter.start(['export'])
          ::Pullentity::Client::Generate::Auth.start(['make_default'])
        end

        #map %(n) => 'select'
        desc "make_defalt", "needs auth_token."
        long_desc "make default site"
        def current
          ::Pullentity::Client::Generate::Auth.start(['show_theme'])
        end

        #map %(n) => 'select'
        desc "import_data", "download site data"
        def import_data
          ::Pullentity::Client::Generate::Auth.start(['download_json_data'])
        end

      end
    end
  end
end
