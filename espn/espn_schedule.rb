require 'rubygems'
require 'nokogiri'
require 'open-uri'

module Espn
  class Schedule
    attr_accessor :east
    def initialize(url)
      nokogiri_obj = to_nokogiri(url)
      @east = teams(nokogiri_obj, "east")
      @west = fetch_division(nokogiri_obj, "west")

    end

    def to_nokogiri(url)
      Nokogiri::HTML(open(url))
    end

    def teams(nokogiri_obj, region)
      division = fetch_division(nokogiri_obj, region)
      team_table = division
      team_table.css("tr").each_with_index.map do |tr, i|
        if i >= 2 #removes headers from table
          tr.children.first.text
        end
      end.compact
    end

    def fetch_division(nokogiri_obj, region)
      if region.downcase == "east"
        nokogiri_obj.css("#content td").first
      else
        nokogiri_obj.css("#content td").last
      end
    end

  end
end
