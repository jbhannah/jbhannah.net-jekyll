module Jekyll
  class Pagination < Generator
    def paginate(site, page)
      all_posts = site.site_payload['site']['posts']
      pages = Pager.calculate_pages(all_posts, site.config['paginate'].to_i)
      (1..pages).each do |num_page|
        pager = Pager.new(site.config, num_page, all_posts, pages)
        if num_page > 1
          newpage = Page.new(site, File.join(site.source, "blog"), page.dir, page.name)
          newpage.pager = pager
          newpage.dir = File.join(page.dir, "blog/page#{num_page}")
          site.pages << newpage
        else
          page.pager = pager
        end
      end
    end
  end
end
