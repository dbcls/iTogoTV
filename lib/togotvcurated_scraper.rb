# -*- coding: utf-8 -*-

require "open-uri"
require "nokogiri"
require "ap"

class CuratedParser
  def initialize(url)
    @page_nkgr = Nokogiri::HTML(open(url))
  end
  
  def newvideos
    list = @page_nkgr.css("tbody.row-hover tr").map{|r| r.css("a").attr("href").value.gsub(/\#.+$/,"") }[0..9]
  end
end
