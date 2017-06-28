module ProteusClient
  Video = Struct.new(:id, :thumbnails, :versions) do

    def initialize(options)
      options.each do |key, value|
        self[key.to_sym] = value
      end
    end

  end
end
