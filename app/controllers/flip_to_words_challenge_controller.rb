class FlipToWordsChallengeController < ApplicationController
  include FlipToWordsChallengeHelper

  def verify
    @flip_letters = read_flip_letters_from_file
    @user_answers = params[:answers] || []
    @verification_results = verify_user_answers(@user_answers, @flip_letters)
    render json: { results: @verification_results }
  end

  def 
end