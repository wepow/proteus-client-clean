module ProteusClient

  # Provides an interface for Proteus REST service to encode videos
  # @example Creating a new proxy
  #   ProteusClient::Proxy.new
  #   ProteusClient::Proxy.new({account: "", api_key: "", root: "http://localhost:9292"})
  #
  # @example Calling a method
  #   proteus_client.create_video("video_id","type")
  #
  # @raise [APIKeyNotDefined] if api_key is not defined in ProteusClient.config or sent as param
  # @raise [RootNotDefined] if root is not defined in ProteusClient.config or sent as param
  # @raise [RestClient::Exception] if status code returned from services is not in 200..207
  #
  class Proxy

    def initialize(options = {})
      options = {
        account: ProteusClient.config.account,
        api_key: ProteusClient.config.api_key,
        root:    ProteusClient.config.root
      }.merge(options)

      raise "AccountNotDefined" unless options[:account]
      raise "APIKeyNotDefined"  unless options[:api_key]
      raise "RootNotDefined"    unless options[:root]

      @user     = options[:account]
      @password = options[:api_key]
      @root     = resource(options[:root])
      @cache    = {}
    end

    def create_recordings
      recordings = link(@root, 'proteus:recordings', cache: true)

      response   = retry_once { resource(recordings).post({}) }
      properties = Representers::Recording.new(response).to_hash

      ProteusClient::Recording.new(properties)
    end

    def get_recording(id)
      url       = link(@root, 'proteus:recording', cache: true)
      recording = expand_templated_route(url, 'id', id)

      response   = retry_once { resource(recording).get }
      properties = Representers::Recording.new(response).to_hash

      ProteusClient::Recording.new(properties)
    end

    def create_video(url, version_name, solution)
      videos   = link(@root, 'proteus:videos', cache: true)

      params     = { url: url, solution: solution, version_name: version_name }
      response   = retry_once { resource(videos).post(params) }
      properties = Representers::Video.new(response).to_hash

      ProteusClient::Video.new(properties)
    end

    def create_video_with_versions(url, version_name, solution, versions)
      uri = link(@root, 'proteus:videos', cache: true)
      params =
        {
          video: {
            url: url,
            solution: solution,
            version_name: version_name
          },
          versions: versions
        }
      video = "#{uri}/v2"
      response   = retry_once { resource(video).post(params) }
      properties = Representers::Video.new(response).to_hash
      ProteusClient::Video.new(properties)
    end

    def get_video(id, version_name = nil)
      url   = link(@root, 'proteus:video', cache: true)
      video = expand_templated_route(url, 'id', id)
      video << "?version_name=#{version_name}" if version_name

      response   = retry_once { resource(video).get }
      properties = Representers::Video.new(response).to_hash

      ProteusClient::Video.new(properties)
    end

    def get_videos(ids, version_name = nil)
      url    = link(@root, 'proteus:videos', cache: true)
      videos = url + "?ids=#{ids.join(',')}"
      videos << "&version_name=#{version_name}" if version_name

      response = retry_once { resource(videos).get }
      videos   = Representers::Videos.new(response).videos_properties

      videos.map { |properties| ProteusClient::Video.new(properties) }
    end

    def delete_video(id)
      url   = link(@root, 'proteus:video', cache: true)
      video = expand_templated_route(url, 'id', id)

      response = retry_once { resource(video).delete }
      
      {message: 'success'}
    end

    def create_version(video_id, version_name, solution)
      url      = link(@root, 'proteus:video', cache: true)
      video    = expand_templated_route(url, 'id', video_id)
      versions = link(resource(video), 'proteus:video:versions')

      params   = { version_name: version_name, solution: solution }
      response = retry_once { resource(versions).post(params) }

      {message: 'success'}
    end

    def get_failed_jobs
      url      = link(@root, 'proteus:telestream:failed_jobs', cache: true)
      response = retry_once { resource(url).get }
      response
    end

    private

    def resource(url)
      RestClient::Resource.new(url, content_type: :json, 
                               user: @user, password: @password)
    end

    def link(resource, link, options = {})
      response = @cache[resource.url] || retry_once { JSON.parse(resource.get) }

      @cache[resource.url] = response if options[:cache]

      response['_links'][link]['href']
    end

    def expand_templated_route(url, key, value)
      url.gsub("{/#{key.to_s}}", "/#{value}")
    end

    def retry_once
      yield
    rescue
      yield
    end

  end
end
