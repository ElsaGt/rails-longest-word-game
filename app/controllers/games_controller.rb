require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    alphabet = ("a".."z").to_a
    @letters = alphabet.sample(10)
  end

  def score
    @letters = params[:letters].upcase
    @answer = params[:answer].upcase
    @final_answer = score_and_message(@answer, @letters)
  end

  private

  def score_and_message(attempt, grid)
    if included?(attempt.upcase, grid)
      if english_word?(attempt)
        "Congratulations! #{@answer} is a valid English word!"
      else
        "Sorry but #{@answer} does not seem to be a valid English word..."
      end
    else
      "Sorry but #{@answer} can't be buit out of #{@letters}"
    end
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
