module Pullentity::Client
  module Builder
    class Middleman
      class << self
        include ::Pullentity::Client::Utils

        def build
          system "middleman build --verbose"
        end

      end
    end
  end
end