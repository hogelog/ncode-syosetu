require "spec_helper"

describe NcodeSyosetu::Builder::Polly do
  describe ".split_ssml" do
    let(:builder) { NcodeSyosetu::Builder::Polly.new }
    subject { builder.split_ssml(body_ssml) }
    before do
      stub_const("NcodeSyosetu::Builder::Polly::POLLY_TEXT_LENGTH_LIMIT", 10)
    end

    context "with short text" do
      let(:body_ssml) { "shorttext" }

      it { is_expected.to eq(%w[shorttext]) }
    end

    context "with long text" do
      let(:body_ssml) { "123456789012345" }

      it { is_expected.to eq(%w[1234567890 12345]) }
    end

    context "with break tag and long text" do
      before do
        stub_const("NcodeSyosetu::Builder::Polly::POLLY_TEXT_LENGTH_LIMIT", 10)
      end
      let(:body_ssml) { %(12345<break strength="strong"/>6789012345<break/><break/>6789012345) }

      it { is_expected.to eq(['12345<break strength="strong"/>', '6789012345<break/><break/>', '6789012345']) }
    end
  end
end
