# -*- coding: utf-8 -*-

require "open-uri"
require "nokogiri"
require "yaml"

class MainParser
  @@page = Nokogiri::HTML(open("http://togotv-curated.dbcls.jp"))

  def self.latest_movies
    # return href of 10 latest movies
    @@page.css("tbody.row-hover tr").map{|tr| tr.css("a").attr("href").value.gsub(/\#.+$/,"") }[0..9]
  end

  def self.rank(term)
    # return 10 entries each, [[togotv url, view count, (up|down|same|new)]..]
    # :yesterday, :week, :this_month, :last_month are allowed for the variant
    yaml = YAML::load(open("http://togotv.dbcls.jp/count.yaml"))
    yaml[term]
  end
  
  def self.categories
    # return href of each movie categories page
    @@page.css(".pic-7").map{|l| l.attr("href")}.delete_if{|l| l.include?("list")}
  end
end

class CategoryParser
  def initialize(category_url)
    @page = Nokogiri::HTML(open(category_url))
  end
  
  def subcategories
    # return a hash, { href of subcategories, title of subcategories }
    subcat = {}
    @page.css("li.toc-level-3").each do |li|
      href = li.css("a").attr("href").value
      title =  li.css("a").attr("title").value
      subcat[href] = title
    end
    subcat
  end
  
  def subcat_movielist(subcat_href)
    # return an array of href, togotv page url.
    index_removed = @page.css(".hentry ul")[1]
    target_subcat = index_removed.css("li").select{|li| li.css("a").first.attr("name") == subcat_href.gsub("\#","")}.first
    target_subcat.css("a").map{|a| a.attr("href").gsub(/\#.+$/,"")}.delete_if{|v| !v }
  end
end

