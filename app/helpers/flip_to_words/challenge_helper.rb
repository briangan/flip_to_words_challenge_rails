##
# Module contains both the controller and helper level methods
#   to check if the user has passed the Flip to Words Challenge before allowing access to certain pages.
#   check_flip_to_words_challenge - Alternatively, you can write custom method that uses the logic
#     in check_flip_to_words_challenge to check the challenge status or react differently.
module FlipToWords
  module ChallengeHelper
    def flip_to_words_challenge_status
      session[:flip_to_words_challenge_status] || "not_attempted"
    end

    ##
    # Encrypts a parameter name to make it unrecognizable
    # @param param_name [String] The parameter name to encrypt
    # @return [String] The encrypted parameter name
    def encrypt_param_name(param_name)
      FlipToWords::ParameterEncryptor.encrypt_param_for_view(param_name)
    end

    def flip_to_words_challenge_passed?
      flip_to_words_challenge_status == "passed"
    end

    def flip_to_words_challenge_failed?
      flip_to_words_challenge_status == "failed"
    end

    # TODO: check if the user has finished the challenge too fast compared to
    #   an actual human can do.  Use some session variable to store last challenge issued.
    def unrealistically_too_fast_to_answer?
    end

    def generate_random_combo_of_flip_letters(count = 3)
      flip_letter_map = FlipToWords::FlipLetterMap.load_from_file
      letters = flip_letter_map.map.keys.sample(count)
      letters.map { |letter| flip_letter_map.map[letter] }
    end

    # before_action method to check if the user has passed the challenge before allowing access to certain pages, which checks
    #   session[:flip_to_words_challenge_status] for already passed status.
    #   If not passed, will be redirected to the home page with an alert message;
    #   and would also set sessin[:return_url] to the originally requested URL so that after passing the challenge,
    #   user can be redirected back to the originally requested page.
    def check_flip_to_words_challenge
      logger.info "flip_to_words_challenge_status: #{flip_to_words_challenge_status}"
      unless flip_to_words_challenge_passed?
        session[:return_url] = request.fullpath
        redirect_to root_path, alert: t("flip_to_words_challenge.must_pass_message") || "You must pass the Flip to Words Challenge to access this page."
      end
    end
  end
end
