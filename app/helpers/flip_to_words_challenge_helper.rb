module FlipToWordsChallengeHelper
  def flip_to_words_challenge_status
    session[:flip_to_words_challenge_status] || 'not_attempted'
  end

  def flip_to_words_challenge_passed?
    flip_to_words_challenge_status == 'passed'
  end

  def flip_to_words_challenge_failed?
    flip_to_words_challenge_status == 'failed'
  end
end