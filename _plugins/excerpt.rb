# Jekyll post excerpt filter
# Based on:
#   - http://metaclaws.com/2012/03/03/jekyll_post_excerpts_plugin_and_also_without_a_plugin_for_use_on_github_pages/
#   - https://github.com/imathis/octopress/blob/master/plugins/octopress_filters.rb
module Jekyll
  module ExcerptFilter
    def excerpt(input)
      if input.index(/<!-- more -->/i)
        input.split(/<!-- more -->/i)[0]
      else
        input
      end
    end

    def has_excerpt(input)
      input =~ /<!-- more -->/i ? true : false
    end
  end
end

Liquid::Template.register_filter(Jekyll::ExcerptFilter)
