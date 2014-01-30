module NcodeSyosetu
  module Model
    class Toc
      attr_accessor :title, :author, :abstract, :url, :episodes

      def initialize(page)
        @url = page.uri.to_s
        @title = page.title
        @author = page.search(".novel_writername").text.chomp
        @abstract = page.search(".novel_ex").text.chomp

        @episodes = []
        page.search(".novel_sublist tr").each do |sub_item|
          episode = { text: sub_item.text.gsub(/\s+/, " ").chomp }
          link = sub_item.search("a")
          unless link.empty?
            if link.attr("href").value =~ %r[/(\d+)/?$]
              episode[:number] = $1.to_i
            end
          end
          @episodes << episode
        end
      end
    end
  end
end
