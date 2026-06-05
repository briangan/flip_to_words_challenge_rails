class HomeController < ApplicationController
  include FlipLettersHelper
  helper_method :allowed_to_manage_flip_letters?

  def index
    session[:flip_to_words_challenge_status] = nil if Rails.env.development? # reset challenge status on page refresh in development for easier testing
    render template: "home/index"
  end
end
