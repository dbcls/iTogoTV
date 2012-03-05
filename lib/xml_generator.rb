# -*- coding: utf-8 -*-

require "nokogiri"
require "./togotvcurated_parser"
require "./togotv_parser"
require "ap"

build = Nokogiri::XML::Builder.new(:encoding => 'utf-8') do |xml|
  xml.xml {
    xml.latest {
    ap "latest"
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
      sleep 10
      end
    }
    xml.ranking {
    ap "ranking"
      [ :yesterday, :week, :this_month, :last_month ].each do |term|
        xml.term term
        ap term
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
        sleep 10
        end
      end
    }
    xml.categories {
    ap "categories"
      MainParser.categories.each do |url|
      ap url
        xml.category {
          xml.category_url url
          catp = CategoryParser.new(url)
          subcat = catp.subcategories
          if subcat.class == Hash
            subcat.each_pair do |url, title|
              xml.subcategory {
                xml.subcategory_url url
                xml.subcategory_title title
                ap url
                catp.subcat_movielist(url).each do |url|
                  ap url
                  if url.length == 36
                  xml.movie {
                    ttv = TogoTVParser.new(url)
                    xml.url url
                    xml.mp4file_url ttv.mp4file_url
                    xml.title ttv.title
                    xml.tag ttv.tag
                    xml.thumbnail ttv.thumbnail
                    xml.date ttv.date
                    xml.description ttv.text
                  }
                  else
                    ap "pass"
                  end
                sleep 10
                end
              }
            end
          else
            subcat.each do |arr|
              xml.subcategory {
                xml.subcategory_url arr.last
                xml.subcategory_title arr.first.first
                xml.subcategory_event arr.first.last
                ap arr.last
                catp.subcat_movielist_lecture(arr.last).each do |url|
                  ap url
                  xml.movie {
                    ttv = TogoTVParser.new(url)
                    xml.url url
                    xml.mp4file_url ttv.mp4file_url
                    xml.title ttv.title
                    xml.tag ttv.tag
                    xml.thumbnail ttv.thumbnail
                    xml.date ttv.date
                    xml.description ttv.text
                  }
                sleep 10
                end
              }
            end
          end
        }
      end
    }
  }
end

puts build.to_xml
