class FlipLettersController < ApplicationController
  include FlipLettersHelper

  before_action :authenticate_user!

  def index
    map = FlipLetterMap.load_from_file
    @flip_letters = map.map
    if params[:letter]
      @letter = params[:letter]
      @positions = map[@letter]
    end
    render template: "flip_letters/index"
  end

  def show
    @letter = params[:letter]
    map = FlipLetterMap.load_from_file
    @positions = map[@letter]
    respond_to do |format|
      format.html { redirect_to flip_letters_path + "?letter=#{@letter}" }
      format.json { render json: { letter: @letter, positions: @positions } }
      # turbo stream response to update the letter cells in the UI
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace("letter_form", partial: "flip_letters/form", locals: { letter: @letter, positions: @positions })
      }
    end
  end

  # Update the local file to define which letters and which positions should be flipped for the challenge.
  # Expects params: { letter: 'C', positions: [0, 2, 7] }
  def update
    p = params.permit(:letter, positions: {})
    @letter = p[:letter]
    @positions = p[:positions] || {}
    map = FlipLetterMap.load_from_file
    map.add_letter(@letter, @positions)

    map.save_to_file

    @flip_letters = map.map

    respond_to do |format|
      format.json { render json: { status: "success", flip_letters: @flip_letters } }
      format.turbo_stream # write a turbo stream file to update the #flip_letters_list
    end
  end

  def destroy
    @letter = params[:letter]
    map = FlipLetterMap.load_from_file
    map.map.delete(@letter.upcase)
    map.save_to_file

    @flip_letters = map.map
    @letter = ""

    respond_to do |format|
      format.json { render json: { status: "success", flip_letters: @flip_letters } }
      format.turbo_stream # write a turbo stream file to update the #flip_letters_list
    end
  end

  private

  def authenticate_user!
    # Placeholder for authentication logic
    # In a real application, you would check if the user is logged in and has the necessary permissions
    unless allowed_to_manage_flip_letters?
      flash[:alert] = "Unauthorized access. Please look for help to access."
      respond_to do |format|
        format.json { render json: { error: "Unauthorized" }, status: :unauthorized }
        format.html { render template: "flip_letters/index", status: :unauthorized }
      end
    end
  end
end
