module AresMUSH
  module Seeds
    class DeleteSeedsCmd
    include CommandHandler

     attr_accessor :name, :seed_name

     def parse_args
       args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.name = titlecase_arg(args.arg1)
        self.seed_name = titlecase_arg(args.arg2)
    end

    def required_args
      [ self.name, self.seed_name ]
    end

    def check_can_manage
      return nil if enactor.has_permission?("view_bgs")
      return "You're not allowed to edit other people's Seeds."
     end

    def handle
      char = Character.find_one_by_name(self.name)
      seeds = Hash[char.seeds]
      if ( seeds.has_key?(self.seed_name) )
        seeds.delete self.seed_name
        char.update(seeds: seeds)
        client.emit_success "Seed #{self.seed_name} deleted from #{self.name}"
      else
        client.emit_failure "#{self.name} does not have an Seed named #{self.seed_name}"
      end
    end

    end
  end
end
