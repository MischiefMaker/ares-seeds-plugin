module AresMUSH
  module Seeds
    class DeleteSeedsCmd
    include CommandHandler

     attr_accessor :name, :seed_name

     def parse_args
       args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
        if (args.arg2 == nil)
          self.name = enactor_name
          self.seed_name = titlecase_arg(args.arg1)
        else
          self.name = titlecase_arg(args.arg1)
          self.seed_name = titlecase_arg(args.arg2)
        end
    end

    def required_args
      [ self.name, self.seed_name ]
    end

    def check_can_view
       return nil if self.name == enactor_name
       return nil if enactor.has_permission?("view_bgs")
       return "You're not allowed to edit other people's seeds."
    end

    def handle
      char = Character.find_one_by_name(self.name)
      seeds = Hash[char.seeds]
      if ( seeds.has_key?(self.seed_name) )
        seeds.delete self.seed_name
        char.update(seeds: seeds)
        client.emit_success "Inkling #{self.seed_name} deleted from #{self.name}"
      else
        client.emit_failure "#{self.name} does not have an Inkling named #{self.seed_name}"
      end
    end

    end
  end
end
