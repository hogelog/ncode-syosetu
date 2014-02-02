require 'mechanize'
require "logger"

module NcodeSyosetu
  class Client
    class NotFound < StandardError
      attr_reader :url

      def initialize(url, error_message = nil)
        super(error_message)
        @url = url
      end
    end

    def initialize(logger: Logger.new(STDOUT), sleep: 0.5)
      @mechanize = Mechanize.new
      @logger = logger
      @sleep = sleep
    end

    def get(ncode)
      toc = get_toc(ncode)

      episodes = toc.episodes.map do |episode|
        if episode[:number]
          get_episode(ncode, episode[:text], episode[:number])
        else
          NcodeSyosetu::Model::Heading.new(episode[:text])
        end
      end

      NcodeSyosetu::Model::Novel.new(toc, episodes)
    end

    def get_toc(ncode)
      url = toc_url(ncode)
      NcodeSyosetu::Model::Toc.new(get_content(toc_url(ncode)))
    end

    def get_episode(ncode, title, number)
      sleep(@sleep)
      NcodeSyosetu::Model::Episode.new(title, number, get_content(episode_url(ncode, number)))
    end

    def toc_url(ncode)
      "http://#{NcodeSyosetu::NCODE_HOST_NAME}/#{ncode}"
    end

    def episode_url(ncode, number)
      "http://#{NcodeSyosetu::NCODE_HOST_NAME}/#{ncode}/#{number}"
    end

    private

    def get_content(url)
      @logger.info("GET #{url}...")
      @mechanize.get(url)
    end
  end
end
