module NcodeSyosetu
  module Model
    class Toc
      attr_accessor :title, :author, :abstract, :url, :episodes

      def initialize(page)
        @url = page.uri.to_s
        @title = page.title
        @author = page.search(".p-novel__author").text.chomp
        @abstract = page.search(".p-novel__summary").text.chomp

        @episodes = []
        eplist = page.at(".p-eplist")
        if eplist
          eplist.children.each do |sub_item|
            next unless sub_item.matches?('.p-eplist__chapter-title, .p-eplist__sublist')
            episode = { text: sub_item.text.gsub(/\s+/, " ").chomp }
            link = sub_item.search("a")
            unless link.empty?
              if link.attr("href").value =~ %r[/(\d+)/?$]
                episode[:number] = $1.to_i
              end
            end
            @episodes << episode
          end

          @body_html =
            page.search(".p-novel__author").to_html <<
            page.search(".p-novel__summary").to_html <<
            page.search(".p-eplist").to_html
        else
          # Short story: the toc page itself contains the body.
          @short_story = true
          @page = page

          @body_html =
            page.search(".p-novel__author").to_html <<
            page.search(".p-novel__summary").to_html
        end
      end

      def short_story?
        !!@short_story
      end

      def to_episode
        raise "not a short story" unless short_story?
        Episode.new(@title, 1, @page)
      end

      def html
        <<-HTML
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ja" lang="ja">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>#{@title}</title>
</head>
<body>

#{@body_html}

</body>
</html>
        HTML
      end
    end
  end
end
