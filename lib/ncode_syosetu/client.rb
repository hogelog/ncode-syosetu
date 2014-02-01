require 'mechanize'
require "logger"

module NcodeSyosetu
  class Client
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
      @logger.info("GET #{url}...")
      NcodeSyosetu::Model::Toc.new(@mechanize.get(url))
    end

    def get_episode(ncode, title, number)
      sleep(@sleep)
      url = episode_url(ncode, number)
      @logger.info("GET #{url}...")
      NcodeSyosetu::Model::Episode.new(title, number, @mechanize.get(url))
    end

    def toc_url(ncode)
      "http://#{NcodeSyosetu::NCODE_HOST_NAME}/#{ncode}"
    end

    def episode_url(ncode, number)
      "http://#{NcodeSyosetu::NCODE_HOST_NAME}/#{ncode}/#{number}"
    end
  end
end
