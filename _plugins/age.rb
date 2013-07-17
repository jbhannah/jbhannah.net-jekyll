# Jekyll age calculation tag

module Jekyll
  class AgeTag < Liquid::Tag
    def initialize(tag_name, text, tokens)
      super
      now = Time.now.utc.to_date
      dob = Date.parse text
      @age = now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
    end

    def render(context)
      @age.to_s
    end
  end
end

Liquid::Template.register_tag('age', Jekyll::AgeTag)
