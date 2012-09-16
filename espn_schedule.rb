require_relative 'espn_team'
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'ostruct'

module Espn
  class Schedule
    attr_accessor :east, :west, :stats
    def initialize(url)
      nokogiri_obj ||= to_nokogiri(url)
      @base_url = basic_domain(url)
      @east = teams(nokogiri_obj, "east")
      @west = teams(nokogiri_obj, "west")
    end

    def to_nokogiri(url)
      Nokogiri::HTML(open(url))
    end

    def teams(nokogiri_obj, region)
      division = fetch_division(nokogiri_obj, region)
      team_table = division
      team_table.css("tr").each_with_index.map do |tr, i|
        if i >= 2 #removes headers from table
          team_stats = OpenStruct.new(
            :wins         => tr.children[1].text.to_i,
            :losses       => tr.children[2].text.to_i,
            :ties         => tr.children[3].text.to_i,
            :percetage    => tr.children[4].text.to_f,
            :games_behind => tr.children[5].text.to_i
          )
          Espn::Team.new(@base_url + tr.children.first.children.first.attributes["href"].value, team_stats)
        end
      end.compact
    end

    class Stat
    end

    def fetch_division(nokogiri_obj, region)
      if region.downcase == "east"
        nokogiri_obj.css("#content td").first
      else
        nokogiri_obj.css("#content td").last
      end
    end

    def basic_domain(url)
      url.match(/(.+\.com)/)[1]
    end

  end
end
