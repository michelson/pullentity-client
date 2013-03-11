module Pullentity::Client
  module Builder
    class Middleman
      class << self
        include ::Pullentity::Client::Utils

        def build
          system "middleman build"
        end

      end
    end
  end
end