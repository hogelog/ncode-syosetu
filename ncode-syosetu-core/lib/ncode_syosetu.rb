require "ncode_syosetu/version"
require "ncode_syosetu/model"
require "ncode_syosetu/client"
require "ncode_syosetu/builder"

module NcodeSyosetu
  NCODE_HOST_NAME = "ncode.syosetu.com"
  NOVEL18_HOST_NAME = "novel18.syosetu.com"

  def self.client(host: NCODE_HOST_NAME)
    @@clients ||= {}
    @@clients[host] ||= Client.new(host: host)
  end

  def self.parse_url(url_or_ncode)
    if url_or_ncode =~ %r{\Ahttps?://([^/]+)/([^/]+)}
      { host: $1, ncode: $2 }
    else
      { host: NCODE_HOST_NAME, ncode: url_or_ncode }
    end
  end
end
