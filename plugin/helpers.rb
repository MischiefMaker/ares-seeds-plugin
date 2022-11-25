module AresMUSH
    module Soul

       def self.has_seed?(target,seed_name)
        char = Character.find_one_by_name(target)
            if char.char.seeds[seeds_name] != nil
                return true
            else
               return false
             end
        end


    end
end
