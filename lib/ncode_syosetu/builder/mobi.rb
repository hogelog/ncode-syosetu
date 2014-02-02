require "kindlegen"
require "tempfile"

module NcodeSyosetu
  module Builder
    class Mobi
      def self.write(novel, mobi_path)
        mobi_pathname = Pathname.new(mobi_path)
        mobi_basename = mobi_pathname.basename.to_s
        Dir.mktmpdir do |tmpdir|
          epub_path = File.join(tmpdir, "#{mobi_basename}.epub")
          NcodeSyosetu::Builder::Epub3.write(novel, epub_path)
          STDERR.puts Kindlegen.run(epub_path,
                        "-verbose",
                        "-locale", "ja",
                        "-o", mobi_basename)
          File.rename(File.join(tmpdir, mobi_basename), mobi_path)
        end
      end
    end
  end

  NcodeSyosetu::Model::Novel.class_eval do
    def write_mobi(file)
      NcodeSyosetu::Builder::Mobi.write(self, file)
    end
  end
end
