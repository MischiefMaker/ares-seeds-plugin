module AresMUSH
  module Seeds
    class NewSeedsCmd
      include CommandHandler

      attr_accessor :char, :seed_name, :seed_description

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_arg3)
          self.char = titlecase_arg(args .arg1)
          self.seed_name = titlecase_arg(args.arg2)
          self.seed_description = trim_arg(args.arg3)
      end

     def required_args
       [ self.char, self.seed_description, self.seed_name ]
     end

     def check_can_manage
      return nil if enactor.has_permission?("manage_seeds")
      return "You're not allowed to edit Seeds."
     end

     def check_has_seed
      return "#{Character.find_one_by_name(self.char).name} does not have a Seed named #{self.seed_name}." if !Seeds.has_seed?(self.char,self.seed_name)
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
