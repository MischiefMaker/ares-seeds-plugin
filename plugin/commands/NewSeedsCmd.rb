seedsmodule AresMUSH
  module Seeds
    class SetSeedsCmd
      include CommandHandler

      attr_accessor :name, :seed_name, :seed_description

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_optional_arg3)
        if (args.arg3 == nil)
          self.name = enactor_name
          self.seed_name = titlecase_arg(args.arg1)
          self.seed_description = trim_arg(args.arg2)
        else
          self.name = titlecase_arg(args.arg1)
          self.seed_name = titlecase_arg(args.arg2)
          self.seed_description = trim_arg(args.arg3)
        end
      end

     def required_args
       [ self.name, self.seed_description, self.seed_name ]
     end

     def check_chargen_locked
       return nil if Chargen.can_manage_apps?(enactor)
       Chargen.check_chargen_locked(enactor)
     end

      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
        seeds = model.seeds || {}
        seeds[self.seeds_name] = self.seeds_description
        model.update(seeds: seeds)
        client.emit_success "Seed set for #{self.name}!"
      end
    end
  end
end

