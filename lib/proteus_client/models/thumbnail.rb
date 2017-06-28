module ProteusClient
  Thumbnail = Struct.new(:size, :url) do

    def initialize(options)
      options.each do |key, value|
        self[key.to_sym] = value
      end
    end

  end
end
