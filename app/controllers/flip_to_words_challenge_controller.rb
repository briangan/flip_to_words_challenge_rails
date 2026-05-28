class FlipToWordsChallengeController < ApplicationController
  include FlipToWordsChallengeHelper

  def verify
    @letters_to_flip = read_letters_to_flip_from_file
    @user_answers = params[:answers] || []
    @verification_results = verify_user_answers(@user_answers, @letters_to_flip)
    render json: { results: @verification_results }
  end

  def 
end