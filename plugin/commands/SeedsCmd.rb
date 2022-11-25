module AresMUSH
  module Seeds
    class SeedsCmd
      include CommandHandler

      attr_accessor :char

      def parse_args
        arg = downcase_arg(cmd.args)
        if arg == nil
          self.char = enactor
        else
          ClassTargetFinder.with_a_character(arg, client, enactor) do |model|
            self.char = model
           end
        end
      end

      def check_can_view
        return nil if self.char.name == enactor_name
        return nil if enactor.has_permission?("view_bgs")
        return "You're not allowed to view another person's Seeds."
      end


      def handle
        template = SeedsTemplate.new(char,char.seeds || {})
        client.emit template.render
      end
    end
  end
end
