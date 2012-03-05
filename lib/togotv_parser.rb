# -*- coding: utf-8 -*- 

require "open-uri"
require "nokogiri"

class TogoTVParser
  def initialize(togotv_url)
    @page = Nokogiri::HTML(open(togotv_url))
  end
  
  def mp4file_url
    # return an url of mp4 format movie file
    @page.css("script").inner_text =~ /file=(.+?\.mov)&image/
    "http://togotv.dbcls.jp/videocast/togotv_videocast/Media/#{$1}.ff.mp4"
  end
  
  def title
    # return movie title by String
    @page.css("title").inner_text.gsub(/^.+?\s-\s/,"")
  end
  
  def tag
    # return tags by an array
    @page.css("h3 a").select{|a| !a.attr("name") }.map{|a| a.inner_text }
  end
  
  def thumbnail
    # return URL of a thumbnail image
    @page.css(".section").inner_html =~ /h3>.+?(<img.+?)<\/a>/m
    tail = Nokogiri::HTML($1).css("img").attr("src").value
    "http://togotv.dbcls.jp/#{tail}"
  end
  
  def date
    # return uploaded date by YYYY-MM-DD format
    @page.css("h2 a").inner_text
  end
  
  def text
    # return movie description by String
    section_html = @page.css(".section").inner_html
    section_html =~ /image\">.+?<\/div>(.+?)id=\"movie/m
    Nokogiri::HTML($1).inner_text.gsub("\n","").gsub(/YouTube版はこちらです。/,"").gsub(/【ダイジェスト】.*$/,"")
  end
end
