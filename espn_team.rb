require 'mechinize'
require 'nokogiri'
module Espn
  class Team

    attr_accessor :name, :abbreviation, :stats
    def initialize(url, team_stats)
      nokogiri_obj     = to_nokogiri(url)
      @name            = get_name(nokogiri_obj)
      @abbreviation    = get_abbreviation(nokogiri_obj)
      @stats           = team_stats
    end

    def to_nokogiri(url)
      Nokogiri::HTML(open(url))
    end

    def get_name(nokogiri_obj)
      nokogiri_obj.css("h3").first.children.first.text.strip
    end

    def get_abbreviation(nokogiri_obj)
      nokogiri_obj.css("h3").first.children.last.text.strip.gsub(/\(|\)/, "")
    end

    def get_wins(nokogiri_obj)
      nokogiri_obj.css("h3").first.children.first.text.strip
    end

    def get_losses(nokogiri_obj)

    end

    def get_ties(nokogiri_obj)
    end

    def get_percentage(nokogiri_obj)
    end

    def get_games_behind(nokogiri_obj)
    end

  end
end
