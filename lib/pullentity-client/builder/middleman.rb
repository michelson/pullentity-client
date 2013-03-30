module Pullentity::Client
  module Builder
    class Middleman
      class << self
        include ::Pullentity::Client::Utils

        def build
          system "export MIDDLEMAN_BUILD_TARGET=remote_theme; middleman build --verbose"
        end

      end
    end
  end
end