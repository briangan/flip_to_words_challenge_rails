class FlipToWordsChallengeController < ApplicationController
  include FlipToWordsChallengeHelper

  ##
  # Required params:
  #   letters: <Array of String> The letters being verified, for example, ["C", "A", "T"]
  #   answers: <Hash of String => Hash of selected checkboxes (1 for checked, 0 or nil for unchecked)>
  #     For example, "A" => { '0' => 1, '1' => 0, '2' => 1 }, "B" => { '0' => 0, '1' => 1, '2' => 0 }, etc.
  def verify
    full_params = params.permit!.to_h
    letters = full_params.delete(:letters) || []
    @verification_results = verify_user_answers(letters, full_params)
    logger.debug "Verification results: #{@verification_results.inspect}"
    if @verification_results.values.all?
      session[:flip_to_words_challenge_status] = 'passed'
      flash[:notice] = "Congratulations! You've successfully completed the Flip to Words Challenge."
    else
      flash[:alert] = "Your choice of positions for at least one letter is incorrect. Please try again."
    end
    respond_to do |format|
      format.json { render json: { results: @verification_results } }
      format.html { redirect_to root_path, t: Time.now.to_i }
    end
  end

  # One requirement before validating of the letter's positions is that its mapping exists from source, FlipLetterMap. If the letter doesn't exist in the map, we can skip validation and consider it as incorrect.
  # @user_answers <Hash of String => Hash of selected checkboxes (1 for checked, 0 or nil for unchecked)>
  def verify_user_answers(letters, user_answers)
    @flip_letter_map ||= FlipLetterMap.load_from_file
    results = {}
    letters.each do |letter|
      flip_letter = @flip_letter_map.get_flip_letter(letter)
      selected = ( user_answers[letter] || {} ).select{|k,v| v.to_s == '1' }
      results[letter] = flip_letter.matching_positions?(selected) || false
    end
    results
  end
end
