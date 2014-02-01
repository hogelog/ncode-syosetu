require 'webmock/rspec'
require 'yard'

DATA_DIR = File.expand_path('../../data', __FILE__)

shared_context "with mock ncode data" do
  before do
    Dir.glob("#{DATA_DIR}/*").each do |ncode_dir|
      ncode = File.relative_path(DATA_DIR, ncode_dir)
      Dir.glob("#{ncode_dir}/*").each do |html_path|
        File.relative_path(ncode_dir, html_path)
        if html_path.end_with?("index.html")
          path = "#{ncode}"
        elsif html_path =~ /(\d+).html$/
          path = "#{ncode}/#{$1}"
        end
        WebMock.stub_request(:get, "http://#{NcodeSyosetu::NCODE_HOST_NAME}/#{path}").
          to_return(body: File.new(html_path), status: 200, headers: { 'Content-Type' => 'text/html' })
      end
    end
  end
end
