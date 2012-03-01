# -*- coding: utf-8 -*-

require "nokogiri"
require "./togotvcurated_parser"
require "./togotv_parser"
require "ap"

build = Nokogiri::XML::Builder.new(:encoding => 'utf-8') do |xml|
  xml.xml {
    xml.latest {
      MainParser.latest_movies.each do |url|
        xml.movie {
          ttv = TogoTVParser.new(url)
          ap url
          xml.url url
          xml.mp4file_url ttv.mp4file_url
          xml.title ttv.title
          xml.tag ttv.tag
          xml.thumbnail ttv.thumbnail
          xml.date ttv.date
          xml.description ttv.text
        }
      end
    }
    xml.ranking {
      [ :yesterday, :week, :this_month, :last_month ].each do |term|
        xml.term term
        ttv = MainParser.rank(term).each do |arr|
          xml.movie {
            url = "http://togotv.dbcls.jp/#{arr[0]}"
            ttv = TogoTVParser.new(url)
            ap url
            xml.url url
            xml.mp4file_url ttv.mp4file_url
            xml.title ttv.title
            xml.tag ttv.tag
            xml.thumbnail ttv.thumbnail
            xml.date ttv.date
            xml.description ttv.text
            xml.view_count arr[1]
            xml.standings arr[2]
          }
        end
      end
    }
    xml.categories {
      MainParser.categories.each do |url|
        xml.category {
          xml.category_url url
          catp = CategoryParser.new(url)
          catp.subcategories.each_pair do |url, title|
            xml.subcategory {
              xml.subcategory_url url
              xml.subcategory_title title
              catp.subcat_movielist(url).each do |url|
                xml.movie {
                  ttv = TogoTVParser.new(url)
                  ap url
                  xml.url url
                  xml.mp4file_url ttv.mp4file_url
                  xml.title ttv.title
                  xml.tag ttv.tag
                  xml.thumbnail ttv.thumbnail
                  xml.date ttv.date
                  xml.description ttv.text
                }
              end
            }
          end
        }
      end
    }
  }
end

puts build.to_xml
