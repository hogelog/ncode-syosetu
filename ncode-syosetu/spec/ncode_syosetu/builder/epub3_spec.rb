require "spec_helper"
require "spec_helpers/mock_ncode_data_helper"
require "tempfile"

describe NcodeSyosetu::Builder::Epub3 do
  include_context "with mock ncode data"

  let(:ncode) { "n00000" }
  let(:novel) { NcodeSyosetu.client.get(ncode) }

  describe ".write" do
    it "writes epub3" do
      Tempfile.open("epub3") do |file|
        NcodeSyosetu::Builder::Epub3.write(novel, file.path)
      end
    end
  end
end
