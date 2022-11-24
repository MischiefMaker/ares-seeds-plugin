module AresMUSH
  module Seeds
    class EditSeedsCmd
    include CommandHandler

     attr_accessor :name, :seed_name, :seed_description

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
       return "You're not allowed to edit other people's Seeds."
    end

    def handle
      char = Character.find_one_by_name(self.name)
      if (char.seeds == nil)
        client.emit_failure "#{self.name} does not have any Seeds. Use seeds/set to create some first!"
      else
        seeds = Hash[char.seeds]
        self.seed_description = seeds[self.seed_name]
          if (enactor.name == self.name)
            Utils.grab client, enactor, "seeds/set #{self.seed_name}=#{self.seed_description}"
          else
            Utils.grab client, enactor, "seeds/set #{self.name}=#{self.seed_name}/#{self.seed_description}"
          end
      end
    end

    end
  end
end
