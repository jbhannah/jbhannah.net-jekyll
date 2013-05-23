# Flickr Tag
#
# A Jekyll plug-in for embedding Flickr photos in your Liquid templates.
#
# Usage:
#
#   {% flickr 1234567890 %}
#   {% flickr 1234567890 "Large Square" %}
#
# ... where 1234567890 is the Flickr photo ID, and "Large Square" is the size label, as defined here by Flickr:
#
#   http://www.flickr.com/services/api/flickr.photos.getSizes.html
#
# Medium 640 (~640px width) is the default.
#
# Requires a Flickr API key and secret set in environment variables FLICKR_API_KEY and FLICKR_API_SECRET.
#
# You can obtain a Flickr API key here: http://www.flickr.com/services/apps/create/
#
# Based on the jekyll-flickr plugin by Chris Nunciato (http://github.com/cnunciato/jekyll-flickr)
#
# Rewritten by Jesse B. Hannah to use the flickraw gem
# Source: https://github.com/jbhannah/jbhannah.net/blob/master/_plugins/flickr_tag.rb

require 'flickraw'
require 'shellwords'

FlickRaw.api_key = ENV['FLICKR_API_KEY']
FlickRaw.shared_secret = ENV['FLICKR_API_SECRET']

module Jekyll
  class FlickrTag < Liquid::Tag
    @@cached = {} # Prevents multiple requests for the same photo

    def initialize(tag_name, markup, tokens)
      super
      params = Shellwords.shellwords markup
      @photo = { :id => params[0], :size => params[1] || "Medium 640", :sizes => {}, :title => "", :caption => "", :url => "", :exif => {} }
    end

    def render(context)
      @photo.merge!(@@cached[photo_key] || get_photo)

      selected_size = @photo[:sizes][@photo[:size]]
      "<a class=\"thumbnail\" href=\"#{@photo[:url]}\"><img src=\"#{selected_size[:source]}\" title=\"#{@photo[:title]}\" alt=\"#{@photo[:caption]}\" /></a>"
    end

    def get_photo
      sizes = flickr.photos.getSizes photo_id: @photo[:id]
      sizes.to_hash["size"].each do |size|
        @photo[:sizes][size["label"]] = {
          width:  size["width"],
          height: size["height"],
          source: size["source"],
          url:    size["url"]
        }
      end

      info = flickr.photos.getInfo photo_id: @photo[:id]
      @photo[:title]   = info.title
      @photo[:caption] = info.description
      @photo[:url]     = info.urls.url[0]["_content"]

      @photo[:exif] = flickr.photos.getExif photo_id: @photo[:id]

      @@cached[photo_key] = @photo
    end

    def photo_key
      "#{@photo[:id]}"
    end
  end
end

Liquid::Template.register_tag('flickr', Jekyll::FlickrTag)
