module ProteusClient
  Version = Struct.new(:url, :solution, :name, :video_bitrate,
                       :audio_bitrate, :resolution, :media_type) do

    def initialize(options)
      options.each do |key, value|
        self[key.to_sym] = value
      end
    end

  end
end
