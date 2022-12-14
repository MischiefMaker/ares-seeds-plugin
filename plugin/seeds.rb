$:.unshift File.dirname(__FILE__)

module AresMUSH
     module Seeds
       include CommandHandler

    def self.plugin_dir
      File.dirname(__FILE__)
    end

    def self.shortcuts
      Global.read_config("seeds", "shortcuts")
    end

    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "seeds"
       case cmd.switch
       when "new"
          return NewSeedsCmd
       when "edit"
         return EditSeedsCmd
       when "delete"
         return DeleteSeedsCmd
       else
          return SeedsCmd
       end
     end
     return nil
   end

    def self.get_event_handler(event_name)
      nil
    end

    def self.get_web_request_handler(request)
      nil
    end

  end
end
