require 'json'
require 'rest_client'

require_relative 'proteus_client/config'
require_relative 'proteus_client/proxy'
require_relative 'proteus_client/representers/video'
require_relative 'proteus_client/representers/videos'
require_relative 'proteus_client/representers/recording'
require_relative 'proteus_client/models/recording'
require_relative 'proteus_client/models/video'
require_relative 'proteus_client/models/thumbnail'
require_relative 'proteus_client/models/version'

# Provides an interface to use Proteus rest services features
#
module ProteusClient

  def self.config
    @config ||= ProteusClient::Config.new
  end

end
