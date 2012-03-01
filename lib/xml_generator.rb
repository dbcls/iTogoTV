# -*- coding: utf-8 -*-

require "builder"
require "./togotvcurated_parser"
require "./togotv_parser"

if __FILE__ == $0
  # latest movies
  latest_detail = MainParser.latest_movies.map do |url|
    ttv = TogoTVParser.new(url)
    [ttv.mp4file_url, ttv.title, ttv.tag, ttv.thumbnail, ttv.date, ttv.text]
  end
  
  # view ranking
  rankings = {}
  [ :yesterday, :week, :this_month, :last_month ].each do |term|
    detail = MainParser.rank(term).map do |arr|
      ttv = TogoTVParser.new(url)
      [arr[0], arr[1], arr[2], ttv.mp4file_url, ttv.title, ttv.tag, ttv.date, ttv.text]
    end
    rankings[term] = detail
  end
  
  # categories
  categories = {}
  MainParser.categories.each do |url|
    catp = CategoryParser.new(url)
    catp.subcategories.each_pair do |href, title|
      
    end
  end
end
