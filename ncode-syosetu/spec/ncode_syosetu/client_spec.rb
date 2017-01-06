require "spec_helper"
require "spec_helpers/mock_ncode_data_helper"

describe NcodeSyosetu::Client do
  include_context "with mock ncode data"

  let(:ncode) { "n00000" }

  describe "#get" do
    subject { NcodeSyosetu.client.get(ncode) }

    it "scrapes ncode novel" do
      expect(subject.toc.title).to eq("たいとる")
      expect(subject.episodes.size).to eq(4)
      expect(subject.episodes[0]).to be_a(NcodeSyosetu::Model::Heading)
      expect(subject.episodes[1]).to be_a(NcodeSyosetu::Model::Episode)
      expect(subject.episodes[1].number).to eq(1)
      expect(subject.episodes[2]).to be_a(NcodeSyosetu::Model::Heading)
      expect(subject.episodes[3]).to be_a(NcodeSyosetu::Model::Episode)
      expect(subject.episodes[3].number).to eq(2)
    end
  end
end
