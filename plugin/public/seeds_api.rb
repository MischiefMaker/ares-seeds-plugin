module AresMUSH
  module Seeds

    def self.get_seeds_for_web_viewing(char, viewer)
        (char.seeds || {}).map { |name, desc| {
        name: name,
        desc: Website.format_markdown_for_html(desc)
        }}
    end

    def self.get_seeds_for_web_editing(char)
        (char.seeds || {}).map { |name, desc| {
        name: name,
        desc: Website.format_input_for_html(desc)
        }}
    end

    def self.get_blurb_for_web()
     blurb = Global.read_config('seeds')["seeds_blurb"]
     Website.format_input_for_html(blurb)
    end

  end
end
