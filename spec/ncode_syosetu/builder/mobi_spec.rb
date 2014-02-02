require "spec_helper"
require "spec_helpers/mock_ncode_data_helper"
require "tempfile"

describe NcodeSyosetu::Builder::Epub3 do
  include_context "with mock ncode data"

  let(:ncode) { "n00000" }
  let(:novel) { NcodeSyosetu.client.get(ncode) }

  describe ".write" do
    it "writes mobi" do
      Tempfile.open("mobi") do |file|
        NcodeSyosetu::Builder::Mobi.write(novel, file.path)
      end
    end
  end
end
