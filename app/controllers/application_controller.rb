class ApplicationController < ActionController::Base
  include FlipToWordsChallengeHelper
  
  helper FlipToWordsChallengeHelper
  
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  layout 'application'

  before_action :check_flip_to_words_challenge
end
