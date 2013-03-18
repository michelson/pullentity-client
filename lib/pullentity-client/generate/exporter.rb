require 'session'
module Pullentity
  module Client
    module Generate
      class Exporter < Thor

        include ::Pullentity::Client::Utils

        class << self

          include ::Pullentity::Client::Utils

          def create(name)

          end

          def copy_defaults

          end

          def location
            base_location.join(@project_name)
          end

          def source_root
            File.dirname(__FILE__)
          end

        end

        map %(n) => 'new'
        desc "exporter new <name> ", "exports a new Pullentity Client project."
        long_desc "Exports a new Pullentity project"
        def new(name)

        end

      end
    end
  end
end
