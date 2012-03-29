# -*- coding: utf-8 -*-

require "./togotvcurated_parser"
require "./togotv_parser"
require "json"
require "ap"

@movie_desc = MainParser.movie_desc

begin

latest = { :latest => [] }
  MainParser.latest_movies.each do |url|
  cont = {}
  ttv = TogoTVParser.new(url)
  cont[ :url ] = url
  cont[ :mp4file_url ] = ttv.mp4file_url
  cont[ :title ] = ttv.title
  cont[ :tag ] = ttv.tag
  cont[ :thumbnail ] = ttv.thumbnail
  cont[ :date ] = ttv.date
  cont[ :description ] = ttv.text(@movie_desc)
  latest[ :latest ] << cont
  sleep 10
end

ranking = { :ranking => { :yesterday => [], :week => [], :this_month => [], :last_month => [] } }

MainParser.rank( :yesterday ).each do |arr|
  cont = {}
  ttv = TogoTVParser.new("http://togotv.dbcls.jp/#{arr.first}")
  cont[ :url ] = arr.first
  cont[ :mp4file_url ] = ttv.mp4file_url
  cont[ :title ] = ttv.title
  cont[ :tag ] = ttv.tag
  cont[ :thumbnail ] = ttv.thumbnail
  cont[ :date ] = ttv.date
  cont[ :description ] = ttv.text(@movie_desc)
  cont[ :view_count ] = arr[1]
  cont[ :standings ] = arr[2]
  ranking[ :ranking ][ :yesterday ] << cont
  sleep 10
end

MainParser.rank( :week ).each do |arr|
  cont = {}
  ttv = TogoTVParser.new("http://togotv.dbcls.jp/#{arr.first}")
  cont[ :url ] = arr.first
  cont[ :mp4file_url ] = ttv.mp4file_url
  cont[ :title ] = ttv.title
  cont[ :tag ] = ttv.tag
  cont[ :thumbnail ] = ttv.thumbnail
  cont[ :date ] = ttv.date
  cont[ :description ] = ttv.text(@movie_desc)
  cont[ :view_count ] = arr[1]
  cont[ :standings ] = arr[2]
  ranking[ :ranking ][ :week ] << cont
  sleep 10
end

MainParser.rank( :this_month ).each do |arr|
  cont = {}
  ttv = TogoTVParser.new("http://togotv.dbcls.jp/#{arr.first}")
  cont[ :url ] = arr.first
  cont[ :mp4file_url ] = ttv.mp4file_url
  cont[ :title ] = ttv.title
  cont[ :tag ] = ttv.tag
  cont[ :thumbnail ] = ttv.thumbnail
  cont[ :date ] = ttv.date
  cont[ :description ] = ttv.text(@movie_desc)
  cont[ :view_count ] = arr[1]
  cont[ :standings ] = arr[2]
  ranking[ :ranking ][ :this_month ] << cont
  sleep 10
end

MainParser.rank( :last_month ).each do |arr|
  cont = {}
  ttv = TogoTVParser.new("http://togotv.dbcls.jp/#{arr.first}")
  cont[ :url ] = arr.first
  cont[ :mp4file_url ] = ttv.mp4file_url
  cont[ :title ] = ttv.title
  cont[ :tag ] = ttv.tag
  cont[ :thumbnail ] = ttv.thumbnail
  cont[ :date ] = ttv.date
  cont[ :description ] = ttv.text(@movie_desc)
  cont[ :view_count ] = arr[1]
  cont[ :standings ] = arr[2]
  ranking[ :ranking ][ :last_month ] << cont
  sleep 10
end

categories = { :categories => [] }
# categories = { :categories => [ { :subcat_name => [cont, cont..] } ] }

MainParser.categories.each do |url|
  catp = CategoryParser.new(url)
  subcat = catp.subcategories

  if subcat.class == Hash
    subcat_set = {}
    subcat.each_pair do |suburl, title|
      subcat_set[title] = []
      catp.subcat_movielist(suburl).each do |togotvurl|
        cont = {}
        ap togotvurl
        ttv = TogoTVParser.new(togotvurl)
        cont[ :url ] = togotvurl
        cont[ :mp4file_url ] = ttv.mp4file_url
        cont[ :title ] = ttv.title
        cont[ :tag ] = ttv.tag
        cont[ :thumbnail ] = ttv.thumbnail
        cont[ :date ] = ttv.date
        cont[ :description ] = ttv.text(@movie_desc)
        subcat_set[title] << cont
        sleep 10
      end
      categories[ :categories ] << subcat_set
    end
  end
end

rescue Timeout::Error
  retry

end

open("../data/togotv_#{Time.now.strftime("%Y%m%d_%H%M")}.json","w"){|f| JSON.dump([latest, ranking, categories], f)}
