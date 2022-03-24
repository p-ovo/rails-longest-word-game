require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a.shuffle[0..9]

  end

  def score
    url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"

    response = URI.open(url).read
    json = JSON.parse(response)
    failed = false
    if session[:score].nil?
      session[:score] = 0
    end

    # checks if its an english word, then if has no duplicates
    if json['found'] == false
      failed = true
      @error_message = "That's not an english word!"
    elsif !(params[:word].split('').uniq.size == params[:word].split('').size)
      failed = true
      @error_message = 'There are no duplicate letters dude!!'
    end

    # checks if each character in chosen word is in the initial 10 letters
    params[:word].split('').each do |char|
      if !params['letters'].split(" ").include?(char)
        failed = true
        @error_message = 'You picked the wrong letters!'
      end
    end

    if json['found'] == true && failed != true
      @final_score = json['length']
      if session[:score] == 0
        session[:score] = @final_score
      else
        session[:score] += @final_score
      end
    end
        @total_score = session[:score]
  end
end
