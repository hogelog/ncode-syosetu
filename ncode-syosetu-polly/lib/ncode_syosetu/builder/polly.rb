require "aws-sdk-polly"
require "sanitize"
require "nokogiri"

module NcodeSyosetu
  module Builder
    class Polly
      POLLY_TEXT_LENGTH_LIMIT = 1500

      attr_reader :sample_rate, :client, :logger

      def initialize(options={})
        options[:region] ||= "us-west-2"
        @logger = options.delete(:logger)
        @sample_rate = options.delete(:sample_rate) || "16000"
        @client = Aws::Polly::Client.new(options)
      end

      def write_episode(episode, path)
        tmp_files = []
        ssmls = split_ssml(episode.body_ssml.gsub("\n", "")).map{|body_ssml| create_ssml(body_ssml) }

        ssmls.each_with_index do |ssml, i|
          dirname = File.dirname(path)
          basename = File.basename(path, ".mp3")

          File.write(File.join(dirname, "#{basename}-#{i}.ssml"), ssml)
          tmp_path = File.join(dirname, "#{basename}-#{i}.mp3")
          logger.info("#{tmp_path}...") if logger
          client.synthesize_speech(
            response_target: tmp_path,
            output_format: "mp3",
            sample_rate: sample_rate,
            text: ssml,
            text_type: "ssml",
            voice_id: "Mizuki",
          )
          tmp_files << tmp_path
        end
        File.open(path, "wb") do |file|
          tmp_files.each do |tmp_path|
            File.open(tmp_path, "rb") do |tmp_file|
              IO.copy_stream(tmp_file, file)
            end
          end
          file.flush
        end
      end

      def create_ssml(body_ssml)
        <<-XML
<?xml version="1.0"?>
<speak version="1.1" xmlns="http://www.w3.org/2001/10/synthesis" xml:lang="ja">
#{body_ssml}
</speak>
        XML
      end

      def split_ssml(body_ssml)
        ssml = tweak_ssml(body_ssml)
        doc = Nokogiri::XML.parse("<root>#{ssml}</root>")
        elements = doc.root.children

        buffer = StringIO.new
        text_count = 0
        results = []
        while elements.size > 0 do
          element = elements.shift

          unless element.is_a?(Nokogiri::XML::Text) || element.is_a?(String)
            buffer.print(element.to_s)
            next
          end

          text = element.to_s

          if text.size > POLLY_TEXT_LENGTH_LIMIT
            elements = text.chars.each_slice(POLLY_TEXT_LENGTH_LIMIT).map(&:join) + elements
            next
          end

          if (text_count + text.size) > POLLY_TEXT_LENGTH_LIMIT
            results << buffer.string
            buffer = StringIO.new
            text_count = 0
          end
          buffer.print(element.to_s)
          text_count += text.size
        end
        results << buffer.string if buffer.size > 0

        results
      end

      def tweak_ssml(body_ssml)
        body_ssml.
            gsub("<p>", "").
            gsub("</p>", '<break strength="strong"/>').
            gsub(/([」】）』])/, '\1<break strength="strong"/>')
      end
    end
  end
end
