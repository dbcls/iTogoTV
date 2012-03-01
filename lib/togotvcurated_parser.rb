# -*- coding: utf-8 -*-

require "open-uri"
require "nokogiri"
require "ap"

class MainParser
  def initialize
    @page = Nokogiri::HTML(open("http://togotv-curated.dbcls.jp"))
  end
  
  def newvideos
    @page.css("tbody.row-hover tr").map{|tr| tr.css("a").attr("href").value.gsub(/\#.+$/,"") }[0..9]
  end
  
  def categories
    @page.css(".pic-7").map{|l| l.attr("href")}.delete_if{|l| l.include?("list")}
  end
end

class CategoryParser
  def initialize(category_url)
    @page = Nokogiri::HTML(category_url)
  end
  
  def subcategories
    subcat = {}
    @page.css("li.toc-level-3").each do |li|
      href = li.css("a").attr("href").value
      title =  li.css("a").attr("title").value
      subcat[href] = title
    end
    subcat
  end
  
  def subcat_movielist(subcat_href)
    index_removed = @page.css(".hentry ul")[1]
    target_subcat = index_removed.css("li").select{|li| li.css("a").first.attr("name") == subcat_href }.first
    movlist = {}
    target_subcat.css("a").each do |a|
      href = a.attr("href")
      title = a.inner_text
      if href
        movlist[href] = title
      end
    end
    movlist
  end
end
