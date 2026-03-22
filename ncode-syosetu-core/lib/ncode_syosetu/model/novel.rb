module NcodeSyosetu
  module Model
    class Novel
      attr_accessor :toc, :episodes

      def initialize(toc, episodes)
        @toc = toc
        @episodes = episodes
      end

      [:title, :author, :abstract, :url].each do |method|
        class_eval <<-EOS
          def #{method}
            @toc.#{method}
          end
        EOS
      end

      def text
        lines = []
        lines << title
        lines << author
        lines << ""
        episodes.each do |episode|
          lines << episode.text
          lines << ""
        end
        lines.join("\n")
      end

      def markdown
        lines = []
        lines << "# #{title}"
        lines << ""
        lines << "*#{author}*"
        lines << ""
        episodes.each do |episode|
          lines << episode.markdown
          lines << ""
        end
        lines.join("\n")
      end
    end
  end
end
