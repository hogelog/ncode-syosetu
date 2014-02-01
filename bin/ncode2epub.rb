#!/usr/bin/env ruby

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'ncode_syosetu'

if ARGV.size == 0
  puts "#{__FILE__} ncode [ncode...]"
  exit
end

ARGV.each do |ncode|
  novel = NcodeSyosetu.client.get(ncode)
  novel.write_epub3("#{ncode}.epub")
end
