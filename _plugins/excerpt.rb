# Jekyll post excerpt and related filters, extracted from Octopress
#
# Originally written by Brandon Mathis
# https://github.com/imathis/octopress/blob/master/plugins/octopress_filters.rb

module Jekyll
  module ExcerptFilter
    def excerpt(input)
      if input.index(/<!--\s*more\s*-->/i)
        input.split(/<!--\s*more\s*-->/i)[0]
      else
        input
      end
    end

    def has_excerpt(input)
      !input.match(/<!--\s*more\s*-->/i).to_a.empty?
    end

    def raw_content(input)
      /<section class="post_content">(?<content>[\s\S]*?)<\/section>\s*<(footer|\/article)>/ =~ input
      return (content.nil?) ? input : content
    end

    def truncate(input, length)
      if input.length > length && input[0..(length-1)] =~ /(.+)\b.+$/im
        $1.strip + '&hellip;'
      else
        input
      end
    end

    def condense_spaces(input)
      input.gsub(/\s{2,}/, ' ').strip
    end
  end
end

Liquid::Template.register_filter(Jekyll::ExcerptFilter)
