module NcodeSyosetu
  module Model
    class Episode
      attr_accessor :title, :body_html, :url

      def initialize(title, page)
        @url = page.uri.to_s
        @title = title

        @body_html =
          page.search(".novel_subtitle").to_html <<
          page.search(".novel_view").to_html
      end
    end
  end
end
