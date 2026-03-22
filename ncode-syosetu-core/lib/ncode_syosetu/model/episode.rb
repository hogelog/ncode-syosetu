require "erb"
require "nokogiri"

module NcodeSyosetu
  module Model
    class Episode
      attr_accessor :title, :number, :body_html, :url

      def initialize(title, number, page)
        @url = page.uri.to_s
        @title = title
        @number = number

        @body_html =
          page.search(".p-novel__title").to_html <<
          page.search(".p-novel__body").to_html
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

      def text
        doc = Nokogiri::HTML.fragment(@body_html)
        lines = []
        lines << doc.at(".p-novel__title")&.text&.strip
        doc.search(".p-novel__text p").each do |p|
          lines << p.text
        end
        lines.compact.join("\n")
      end

      def markdown
        doc = Nokogiri::HTML.fragment(@body_html)
        lines = []
        title_text = doc.at(".p-novel__title")&.text&.strip
        lines << "## #{title_text}" if title_text
        lines << ""
        doc.search(".p-novel__text p").each do |p|
          lines << ruby_to_markdown(p)
        end
        lines.join("\n")
      end

      private

      def ruby_to_markdown(node)
        result = +""
        node.children.each do |child|
          case child.name
          when "ruby"
            base = child.search("rb").first&.text || child.children.select(&:text?).map(&:text).join
            rt = child.at("rt")&.text
            if rt && !rt.empty?
              result << "#{base}（#{rt}）"
            else
              result << base
            end
          when "text"
            result << child.text
          else
            result << child.text
          end
        end
        result
      end
    end
  end
end
