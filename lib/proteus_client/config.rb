module ProteusClient

  # Used to configure default values used for creating a ProteusClient::Proxy
  # @example Configuring values
  #   ProteusClient.config.root = "http://localhost:9292"
  #   ProteusClient.config.api_key= "api_key"
  #   ProteusClient.config.account = "account"
  #
  class Config
    attr_accessor :root, :api_key, :account
  end

end
