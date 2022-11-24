module AresMUSH
  module Seeds
    class SeedsCmd
      include CommandHandler

      attr_accessor :name

      def parse_args
        self.name = cmd.args ? titlecase_arg(cmd.args) : enactor_name
        self.char = Character.find_one_by_name(self.name)
      end

      def check_can_view
        return nil if char.name == enactor_name
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
