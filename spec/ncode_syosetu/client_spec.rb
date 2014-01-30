require "spec_helper"
require "spec_helpers/mock_ncode_data_helper"

describe NcodeSyosetu::Client do
  let(:ncode) { "n00000" }
  subject { NcodeSyosetu.client.get(ncode) }

  it "scrapes ncode novel" do
    expect(subject.toc.title).to eq("たいとる")
    expect(subject.episodes.size).to eq(2)
    expect(subject.episodes[0]).to be_a(NcodeSyosetu::Model::Heading)
    expect(subject.episodes[1]).to be_a(NcodeSyosetu::Model::Episode)
  end
end
