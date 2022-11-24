module AresMUSH
  module Seeds
    class SeedsTemplate < ErbTemplateRenderer
      attr_accessor :char, :seeds

      def initialize(char, seeds)
        @char = char
        @seeds = Hash[seeds]
        super File.dirname(__FILE__) + "/SeedsTemplate.erb"
      end
      def name(char)
        char.name
      end
    end
  end
end
