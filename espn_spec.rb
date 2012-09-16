require_relative 'espn_schedule'
require 'rubygems'
require 'nokogiri'
require 'vcr'
require 'webmock'
include WebMock::API

VCR.configure do |c|
  c.cassette_library_dir = 'espn'
  c.hook_into :webmock
  c.configure_rspec_metadata!
end

RSpec.configure do |c|
  # so we can use `:vcr` rather than `:vcr => true`;
  # in RSpec 3 this will no longer be necessary.
  c.treat_symbols_as_metadata_keys_with_true_values = true
end

describe Espn::Schedule, :vcr => {:record => :new_episodes} do
  let (:url) {"http://games.espn.go.com/ffl/standings?leagueId=1166249&seasonId=2012"}
  let (:espn) { Espn::Schedule.new(url) }

  it 'takes a url and returns nokogiri object', :vcr => {:record => :new_episodes} do
    espn.should_not be_nil
  end

  it 'will grab the schedule as nokogiri object', :vcr => {:record => :new_episodes} do
    espn.to_nokogiri(url).should be_a_kind_of Nokogiri::HTML::Document
  end

  specify 'a team is a ruby object', :vcr => {:record => :new_episodes}do
    espn.east.first.should be_a_kind_of Espn::Team
  end

  specify 'user can access the team name' do 
    espn.east.first.name.should == "K Cavs Baby AMIRITE"
  end

  specify 'user can access the team name' do 
    espn.east.first.abbreviation.should == "SCHL"
  end

  it 'knows the name of each team', :vcr => {:record => :new_episodes} do
    espn.east.count.should == 5
  end

end

describe Espn::Team, :vcr do 
  let (:team_url) {"http://games.espn.go.com/ffl/clubhouse?leagueId=1193126&teamId=1&seasonId=2012"}
  let (:team) { Espn::Team.new(team_url, OpenStruct.new(:wins => 0)) }
  it 'should have stats', :vcr do 
    agent = WWW::Mechanize.new
    agent.get(team_url)
    form = agent.page.forms.first
    form.username = "voodoologic"
    form.password = "doom45"
    form.submit
    team.stats.wins.should == 0
  end
end
