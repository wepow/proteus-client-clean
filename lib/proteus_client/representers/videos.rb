module ProteusClient
  module Representers
    class Videos

      def initialize(response)
        response    = JSON.parse(response)
        @videos_hash = response['_embedded']['proteus:video']
      end

      def videos_properties
        @videos_hash.map do |response|
          Representers::Video.new(response, raw: false).to_hash
        end
      end

    end
  end
end
