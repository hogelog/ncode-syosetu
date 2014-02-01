require "erb"

module NcodeSyosetu
  module Model
    class Episode
      attr_accessor :title, :number, :body_html, :url

      def initialize(title, number, page)
        @url = page.uri.to_s
        @title = title
        @number = number

        @body_html =
          page.search(".novel_subtitle").to_html <<
          page.search(".novel_view").to_html
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
