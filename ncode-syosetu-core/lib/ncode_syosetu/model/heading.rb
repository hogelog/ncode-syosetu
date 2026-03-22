module NcodeSyosetu
  module Model
    class Heading
      attr_accessor :title

      def initialize(title)
        @title = title
      end

      def text
        title.strip
      end

      def markdown
        "# #{title.strip}"
      end
    end
  end
end
