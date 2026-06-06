##
# Controller for handling the Flip to Words Challenge verification.
# If want to change wording of messages or logic of verification, you can customize inside dictionary (en.yml etc.)
class FlipToWordsChallengeController < ApplicationController
  # assuming already included FlipToWordsChallengeExtension in ApplicationController

  skip_before_action :check_flip_to_words_challenge

  # The page that has the form of challenge to submit user selection of letter positions.
  def page_with_challenge_form
    root_path(t: Time.now.to_i) 
  end

  ##
  # Required params:
  #   letters: <Array of String> The letters being verified, for example, ["C", "A", "T"]
  #   answers: <Hash of String => Hash of selected checkboxes (1 for checked, 0 or nil for unchecked)>
  #     For example, "A" => { '0' => 1, '1' => 0, '2' => 1 }, "B" => { '0' => 0, '1' => 1, '2' => 0 }, etc.
  def verify
    full_params = params.permit!.to_h
    letters = full_params.delete(:letters) || []
    @verification_results = verify_user_answers(letters, full_params)
    logger.info "Verification results: #{@verification_results.inspect}"
    if @verification_results.size > 0 && @verification_results.values.all?
      session[:flip_to_words_challenge_status] = 'passed'
      flash[:notice] =  t('flip_to_words_challenge.success_message') || "Congratulations! You've successfully completed the Flip to Words Challenge."

      respond_to do |format|
        format.json { render json: { results: @verification_results } }
        format.html { redirect_to session[:return_url] || root_path}
      end
      
    else
      session[:flip_to_words_challenge_status] = 'failed'
      flash[:alert] = t('flip_to_words_challenge.failed_message') || "Your choice of positions for at least one letter is incorrect. Please try again."

      respond_to do |format|
        format.json { render json: { results: @verification_results } }
        format.html { redirect_to page_with_challenge_form }
      end
    end
  end

  private

  # One requirement before validating of the letter's positions is that its mapping exists from source, FlipLetterMap. If the letter doesn't exist in the map, we can skip validation and consider it as incorrect.
  # @user_answers <Hash of String => Hash of selected checkboxes (1 for checked, 0 or nil for unchecked)>
  # @return <Hash of String => Boolean> The actual letter existing in the FlipLetterMap => whether user answers match the expected positions for that letter in mapping.
  def verify_user_answers(letters, user_answers)
    @flip_letter_map ||= FlipLetterMap.load_from_file
    results = {}
    letters.each do |letter|
      flip_letter = @flip_letter_map.get_flip_letter(letter)
      next unless flip_letter # if the letter doesn't exist in the map, we can skip validation and consider it as incorrect.
      selected = ( user_answers[letter] || {} ).select{|k,v| v.to_s == '1' }
      results[letter] = flip_letter.matching_positions?(selected) || false
    end
    results
  end
end
