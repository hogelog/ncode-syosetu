require "ncode_syosetu/version"
require "ncode_syosetu/model"
require "ncode_syosetu/client"
require "ncode_syosetu/builder"

module NcodeSyosetu
  NCODE_HOST_NAME = "ncode.syosetu.com"

  def self.client
    @@client ||= Client.new
  end
end
