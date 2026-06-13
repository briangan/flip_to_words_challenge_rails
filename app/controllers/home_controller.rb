class HomeController < ApplicationController
  include FlipToWords::FlipLettersHelper
  helper_method :allowed_to_manage_flip_letters?

  # Don't know why the option below, only:[:index] doesn't work, but this does yet this would be messy if many methods.
  skip_before_action :check_flip_to_words_challenge, except: [ :test_account_page ]

  # Home page that shows the Flip to Words Challenge if the user has not passed it yet.
  def index
    logger.debug "HomeController#index - flip_to_words_challenge_status: #{flip_to_words_challenge_status}"
    # session[:flip_to_words_challenge_status] = nil if Rails.env.development? # reset challenge status on page refresh in development for easier testing
    render template: "home/index"
  end

  def test_account_page
    render template: "home/test_account_page"
  end
end
