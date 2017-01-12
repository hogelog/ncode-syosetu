require "aws-sdk-polly"
require "sanitize"
require "nokogiri"
require "expeditor"
require "concurrent"

module NcodeSyosetu
  module Builder
    class Polly
      POLLY_TEXT_LENGTH_LIMIT = 1500

      attr_reader :sample_rate, :client, :logger, :service

      def initialize(options={})
        options[:region] ||= "us-west-2"
        @logger = options.delete(:logger)
        @sample_rate = options.delete(:sample_rate) || "16000"
        @max_threads = options.delete(:max_threads) || 10
        @client = Aws::Polly::Client.new(options)
        @service = Expeditor::Service.new(
          executor: Concurrent::ThreadPoolExecutor.new(
            min_threads: 0,
            max_threads: @max_threads,
          )
        )
      end

      def write_episode(episode, path)
        tmp_files = []
        ssmls = split_ssml(episode.body_ssml.gsub("\n", "")).map{|body_ssml| create_ssml(body_ssml) }

        commands = []

        dirname = File.dirname(path)
        basename = File.basename(path, ".mp3")
        tmpdir = File.join(dirname, basename)
        FileUtils.mkdir_p(tmpdir)

        ssmls.each_with_index do |ssml, i|
          tmp_ssml_path = File.join(tmpdir, "#{basename}-#{i}.ssml")
          File.write(tmp_ssml_path, ssml)
          tmp_path = File.join(tmpdir, "#{basename}-#{i}.mp3")
          command = Expeditor::Command.new(service: service) do
            logger.info("#{tmp_path}...") if logger
            begin
              client.synthesize_speech(
                response_target: tmp_path,
                output_format: "mp3",
                sample_rate: sample_rate,
                text: ssml,
                text_type: "ssml",
                voice_id: "Mizuki",
              )
            rescue => e
              logger.error("#{e.message}\n#{ssml}")
              logger.error("#{e.message}: #{tmp_ssml_path}\n#{ssml}")
              raise e
            end
          end
          command.start
          commands << command
          tmp_files << tmp_path
        end
        commands.each{|command| command.get }
        File.open(path, "wb") do |file|
          tmp_files.each do |tmp_path|
            File.open(tmp_path, "rb") do |tmp_file|
              IO.copy_stream(tmp_file, file)
            end
          end
          file.flush
        end
        logger.info("Generated: #{path}") if logger
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

          case element
            when Nokogiri::XML::Text
              text = element.text
            when String
            text = element
            else
            buffer.print(element.to_s)
            next
          end

          if text.size > POLLY_TEXT_LENGTH_LIMIT
            elements = text.chars.each_slice(POLLY_TEXT_LENGTH_LIMIT).map(&:join) + elements
            next
          end

          if (text_count + text.size) > POLLY_TEXT_LENGTH_LIMIT
            results << buffer.string
            buffer = StringIO.new
            text_count = 0
          end
          buffer.print(text)
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
