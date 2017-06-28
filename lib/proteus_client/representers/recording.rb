module ProteusClient
  module Representers
    class Recording

      def initialize(raw_response)
        response = JSON.parse(raw_response)

        @properties = {
          id: response['id'],
          adobe_rtmpe_write: response['_links']['adobe_rtmpe:write']['href'],
          adobe_rtmpe_read: response['_links']['adobe_rtmpe:read']['href'],
          adobe_rtmpe_file: response['_links']['adobe_rtmpe:file']['href'],
          generic_https_write: response['_links']['generic_https:write']['href'],
          generic_https_write_inputs: response['_links']['generic_https:write']['inputs'],
          generic_https_file: response['_links']['generic_https:file']['href'],
          generic_https_read: response['_links']['generic_https:read']['href']
        }
      end

      def to_hash
        @properties
      end

    end 
  end
end
