require "tmpdir"
require "gepub"

module NcodeSyosetu
  module Builder
    class Epub3
      def self.write(novel, path)
        Dir.mktmpdir do |tmpdir|
          builder = GEPUB::Builder.new do
            language "ja"
            unique_identifier novel.url
            title novel.title
            creator novel.author

            date Time.now.to_s

            resources(workdir: tmpdir) do
              toc_html = novel.toc.html.gsub(%r[<a href="/[^/]+/(\d+)/?">], '<a href="\1.html">')
              File.write("toc.html", toc_html)
              nav "toc.html"

              ordered do
                novel.episodes.each do |episode|
                  if episode.is_a?(NcodeSyosetu::Model::Heading)
                    heading episode.title
                  else
                    html_path = "#{episode.number}.html"
                    File.write(html_path, episode.html)
                    file html_path
                  end
                end
              end
            end
          end

          builder.generate_epub(path)
        end
      end
    end
  end

  NcodeSyosetu::Model::Novel.class_eval do
    def write_epub3(file)
      NcodeSyosetu::Builder::Epub3.write(self, file)
    end
  end
end
