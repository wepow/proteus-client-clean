module ProteusClient
  module Representers
    class Video

      def initialize(response, options = { raw: true })
        response         = JSON.parse(response) if options[:raw]
        versions_hash    = response['_embedded']['proteus:video:versions']
        thumbnails_hash  = response['_embedded']['proteus:video:thumbnails']

        @properties = { 
          id:         response['id'],
          thumbnails: create_thumbnails(thumbnails_hash),
          versions:   create_versions(versions_hash)
        }
      end

      def to_hash
        @properties
      end

      private

      def create_thumbnails(thumbnails_hash)
        thumbnails_hash.map do |hash|
          options = {
            size: hash['name'],
            url:  hash['_links']['alternate']['href']
          }
          ProteusClient::Thumbnail.new(options)
        end
      end

      def create_versions(versions_hash)
        versions_hash.map do |hash|
          options = {
            name:          hash['name'],
            solution:      hash['solution'],
            url:           hash['_links']['alternate']['href'],
            video_bitrate: hash['video_bitrate'],
            audio_bitrate: hash['audio_bitrate'],
            resolution:    hash['resolution'],
            media_type:    hash['_links']['alternate']['type']
          }
          ProteusClient::Version.new(options)
        end
      end

    end 
  end
end
