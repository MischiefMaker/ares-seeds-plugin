module AresMUSH
  module Seeds
    class SeedsCmd
      include CommandHandler

      attr_accessor :char

      def parse_args
        self.char = cmd.args ? titlecase_arg(cmd.args) : enactor_name
      end

      def check_can_view
         return nil if self.char == enactor_name
         return nil if enactor.has_permission?("view_bgs")
         return "You're not allowed to view other peoples' Seeds."
      end


      def handle
        ClassTargetFinder.with_a_character(self.char, client, enactor) do |model|
          template = SeedsTemplate.new(model,model.seeds || {})
          client.emit template.render
        end
      end
    end
  end
end
