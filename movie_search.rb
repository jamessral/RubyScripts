require 'rubygems'
require 'bundler/setup'
require 'awesome_print'
require 'rest-client'
require 'json'

class MovieSearch
  attr_accessor :titles, :release_dates, :posters, :data
  attr_reader :key, :headers, :base_uri

  @base_uri = 'http://api.themoviedb.org/3/search/movie'
  @headers = {:accept => 'application/json'}
  @key = ENV['SECRET_API_KEY']

  def initialize(titles, release_dates, posters)
    self.titles = titles
    self.release_dates = release_dates
    self.posters = posters
  end

  def self.find(title, year = '')
    title_words = CGI::escape(title)
    response = RestClient.get "#{@base_uri}?api_key=#{@key}&query=#{title_words}", @headers
    if response.succ!
      @data = JSON.parse(response)
      results = @data["results"]

      movies = []
      results.each do |result|
        movie = {}
        movie["id"] = result["id"]
        movie["original_title"] = result["original_title"]
        movie["release_date"] = result["release_date"]
        movie["poster_path"] = result["poster_path"]
        movies.push(movie)
      end
    end

    return movies
  end

  def fetch(param)
    fetch_param = param.downcase
    case fetch_param
    when "title"
      self.titles
    when "release date"
      self.release_dates
    when "poster"
      self.posters
    end
  end
end

ap movie = MovieSearch.find("Star Trek")
# ap movie.fetch("release date")
