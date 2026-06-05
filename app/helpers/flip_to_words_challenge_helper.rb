module FlipToWordsChallengeHelper
  def flip_to_words_challenge_status
    session[:flip_to_words_challenge_status] || "not_attempted"
  end

  def flip_to_words_challenge_passed?
    flip_to_words_challenge_status == "passed"
  end

  def flip_to_words_challenge_failed?
    flip_to_words_challenge_status == "failed"
  end

  def generate_random_combo_of_flip_letters(count = 3)
    flip_letter_map = FlipLetterMap.load_from_file
    letters = flip_letter_map.map.keys.sample(count)
    letters.map { |letter| flip_letter_map.map[letter] }
  end
end
