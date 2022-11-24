module AresMUSH
  module Seeds
    class SeedsCmd
      include CommandHandler

      attr_accessor :char

      def parse_args
        if cmd.args == nil
          self.char = enactor
        else
          Character.find_one_by_name(cmd.args)
        end
      end

      def check_is_player
        return nil if self.char != nil
        return "#{self.name} is not a character."
      end

      def check_can_view
        return nil if self.char.name == enactor_name
        return nil if enactor.has_permission?("view_bgs")
        return "You're not allowed to view another person's Seeds."
      end


      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          template = SeedsTemplate.new(model,model.seeds || {})
          client.emit template.render
	       end
      end
    end
  end
end
