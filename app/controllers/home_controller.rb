class HomeController < ApplicationController
  include FlipLettersHelper
  helper_method :allowed_to_manage_flip_letters?

  def index
    render template: "home/index"
  end
end
