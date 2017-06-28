module ProteusClient
  Recording = Struct.new(:id, :adobe_rtmpe_write, :adobe_rtmpe_read,
                         :adobe_rtmpe_file, :generic_https_write,
                         :generic_https_write_inputs,
                         :generic_https_file, :generic_https_read) do

    def initialize(options)
      options.each do |key, value|
        self[key.to_sym] = value
      end
    end

  end
end
