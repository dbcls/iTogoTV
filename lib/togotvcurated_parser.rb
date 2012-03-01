# -*- coding: utf-8 -*-

require "open-uri"
require "nokogiri"
require "yaml"

class MainParser
  def initialize
    @page = Nokogiri::HTML(open("http://togotv-curated.dbcls.jp"))
  end
  
  def latest_movies
    # return href of 10 latest movies
    @page.css("tbody.row-hover tr").map{|tr| tr.css("a").attr("href").value.gsub(/\#.+$/,"") }[0..9]
  end
  
  def categories
    # return href of each movie categories page
    @page.css(".pic-7").map{|l| l.attr("href")}.delete_if{|l| l.include?("list")}
  end
end

class CategoryParser
  def initialize(category_url)
    @page = Nokogiri::HTML(category_url)
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
    # return a hash, { href of togotv page, title of the movie }
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

class RankingParser
  # return 10 entries each, [[togotv url, view count, (up|down|same|new)]..]
  def initialize
    @yaml = YAML::load(open("http://togotv.dbcls.jp/count.yaml"))
  end
  
  def yesterday
    @yaml[:yesterday]
  end
  
  def this_week
    @yaml[:week]
  end
  
  def this_month
    @yaml[:this_month]
  end
  
  def this_love
    "has taken its toll on me"
  end
  
  def last_month
    @yaml[:last_month]
  end
  
  def last_christmas
    "I gave you my heart"
  end
end
