module AresMUSH
  module Seeds
    class SeedsCmd
      include CommandHandler

      attr_accessor :char

      def parse_args
        self.char = cmd.args ? Character.find_one_by_name(cmd.args) : enactor
      end

      def check_is_character
        return "#{self.char} is not a character." if self.char.name == nil
        return nil
      end

      def check_can_view
        return nil if self.char.name == enactor_name
        return nil if enactor.has_permission?("view_bgs")
        return "You're not allowed to view another person's Seeds."
      end


      def handle
        template = SeedsTemplate.new(self.char,self.char.seeds || {})
        client.emit template.render
      end
    end
  end
end
