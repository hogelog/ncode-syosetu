module NcodeSyosetu
  module Model
    class Novel
      attr_accessor :toc, :episodes

      def initialize(toc, episodes)
        @toc = toc
        @episodes = episodes
      end
    end
  end
end
