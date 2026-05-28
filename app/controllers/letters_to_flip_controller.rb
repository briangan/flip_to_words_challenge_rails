class LettersToFlipController < ApplicationController

  before_action :authenticate_user!
  
  def index
    @letters_to_flip = read_letters_to_flip_from_file
    render template: 'letters_to_flip/index'
  end

  def update
    @letters_to_flip = params[:letters_to_flip]
    write_letters_to_flip_to_file(@letters_to_flip)
    respond_to do |format|
      format.json { render json: { status: 'success', letters_to_flip: @letters_to_flip } }
    end
  end

  private

  def authenticate_user!
    # Placeholder for authentication logic
    # In a real application, you would check if the user is logged in and has the necessary permissions
    unless session[:user_id] || ['localhost', '127.0.0.1'].include?(request.host)
      flash[:alert] = 'Unauthorized access. Please look for help to find.'
      respond_to do |format|
        format.json { render json: { error: 'Unauthorized' }, status: :unauthorized }
        format.html { redirect_to root_path, alert: 'Unauthorized' }
      end
    end
  end

  def read_letters_to_flip_from_file
    file_path = Rails.root.join('storage', 'letters_to_flip.csv')
    if File.exist?(file_path)
      File.read(file_path).split("\n").map(&:to_i)
    else
      []
    end
  end

  def write_letters_to_flip_to_file(letters)
    file_path = Rails.root.join('storage', 'letters_to_flip.csv')
    File.open(file_path, 'w') do |file|
      file.puts(letters.join("\n"))
    end
  end
end