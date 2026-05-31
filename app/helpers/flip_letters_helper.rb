module FlipLettersHelper
  def allowed_to_manage_flip_letters?
    # Placeholder for actual permission logic
    # For example, you could check if the user is logged in and has a specific role
    session[:user_id] || [ "localhost", "127.0.0.1" ].include?(request.host)
  end
end
