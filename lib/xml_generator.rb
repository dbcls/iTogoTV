# -*- coding: utf-8 -*-

require "nokogiri"
require "./togotvcurated_parser"
require "./togotv_parser"
require "fileutils"
require "ap"

@movie_desc = MainParser.movie_desc

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
          xml.description ttv.text(@movie_desc)
        }
      sleep 10
      end
    }
    xml.ranking {
    ap "ranking"
      xml.yesterday {
        ap "yesterday"
        ttv = MainParser.rank( :yesterday ).each do |arr|
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
            xml.description ttv.text(@movie_desc)
            xml.view_count arr[1]
            xml.standings arr[2]
          }
        sleep 10
        end
      }
      xml.week {
        ap "week"
        ttv = MainParser.rank( :week ).each do |arr|
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
            xml.description ttv.text(@movie_desc)
            xml.view_count arr[1]
            xml.standings arr[2]
          }
        sleep 10
        end
      }
      xml.this_month {
        ap "this_month"
        ttv = MainParser.rank( :this_month ).each do |arr|
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
            xml.description ttv.text(@movie_desc)
            xml.view_count arr[1]
            xml.standings arr[2]
          }
        sleep 10
        end
      }
      xml.last_month {
        ap "last_month"
        ttv = MainParser.rank( :last_month ).each do |arr|
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
            xml.description ttv.text(@movie_desc)
            xml.view_count arr[1]
            xml.standings arr[2]
          }
        sleep 10
        end
      }
    }
    xml.categories {
    ap "categories"
      MainParser.categories.each do |url|
      ap url
        xml.category( :url => url ) {
          catp = CategoryParser.new(url)
          subcat = catp.subcategories
          if subcat.class == Hash
            subcat.each_pair do |url, title|
              xml.subcategory( :url => url, :title => title) {
                ap url
                catp.subcat_movielist(url).each do |url|
                  ap url
                  xml.movie {
                    ttv = TogoTVParser.new(url)
                    xml.url url
                    xml.mp4file_url ttv.mp4file_url
                    xml.title ttv.title
                    xml.tag ttv.tag
                    xml.thumbnail ttv.thumbnail
                    xml.date ttv.date
                    xml.description ttv.text(@movie_desc)
                  }
                sleep 10
                end
              }
            end
=begin
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
                    xml.description ttv.text(@movie_desc)
                  }
                sleep 10
                end
              }
            end
          end
=end
          end
        }
      end
    }
  }
end

FileUtils.mv("/Library/WebServer/Document/togotv.xml","../data/togotv_#{Time.now.strftime("%Y%m%d%H%M%S")}.xml")
open("/Library/WebServer/Document/togotv.xml","w"){|f| f.puts(build.to_xml)}
