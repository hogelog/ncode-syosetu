require "tmpdir"
require "gepub"

module NcodeSyosetu
  module Builder
    class Epub3
      def self.write(novel, path)
        Dir.mktmpdir do |tmpdir|
          book = GEPUB::Book.new
          book.language = "ja"
          book.add_identifier(novel.url, 'BookId')
          book.add_title(novel.title)
          book.add_creator(novel.author)
          book.add_date(Time.now.strftime('%Y-%m-%dT%H:%M:%SZ'))

          toc_html = novel.toc.html.gsub(%r[<a href="/[^/]+/(\d+)/?">], '<a href="\1.html">').gsub(/<br>/, '<br />')
          toc_path = File.join(tmpdir, "toc.html")
          File.write(toc_path, toc_html)
          item = book.add_item('toc.html', content: File.open(toc_path))
          item.add_property('nav')

          book.ordered do
            next_heading = nil
            novel.episodes.each do |episode|
              if episode.is_a?(NcodeSyosetu::Model::Heading)
                next_heading = episode.title
              else
                episode_html = episode.html.gsub(/<br>/, '<br />')
                html_path = "#{episode.number}.html"
                full_path = File.join(tmpdir, html_path)
                File.write(full_path, episode_html)
                item = book.add_item(html_path, content: File.open(full_path))
                item.toc_text(next_heading || episode.title)
                next_heading = nil
              end
            end
          end

          book.generate_epub(path)
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
