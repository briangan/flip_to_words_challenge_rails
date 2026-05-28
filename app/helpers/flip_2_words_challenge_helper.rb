module Flip2WordsChallengeHelper
  def flip_2_words_challenge_status
    session[:flip_2_words_challenge_status] || 'not_attempted'
  end

  def flip_2_words_challenge_passed?
    flip_2_words_challenge_status == 'passed'
  end

  def flip_2_words_challenge_failed?
    flip_2_words_challenge_status == 'failed'
  end
end