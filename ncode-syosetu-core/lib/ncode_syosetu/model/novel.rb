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
    end
  end
end
