module AresMUSH
  module Seeds
    class NewSeedsCmd
      include CommandHandler

      attr_accessor :name, :seed_name, :seed_description

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_arg3)
          self.name = titlecase_arg(args.arg1)
          self.seed_name = titlecase_arg(args.arg2)
          self.seed_description = trim_arg(args.arg3)
      end

     def required_args
       [ self.name, self.seed_description, self.seed_name ]
     end

     def check_can_manage
      return nil if enactor.has_permission?("view_bgs")
      return "You're not allowed to edit other people's Seeds."
     end

      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
        seeds = model.seeds || {}
        seeds[self.seed_name] = self.seed_description
        model.update(seeds: seeds)
        client.emit_success "Seed #{self.seed_name} set for #{self.name}!"
      end
    end
  end
end

end
