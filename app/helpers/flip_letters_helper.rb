module FlipLettersHelper
  def allowed_to_manage_flip_letters?
    # Placeholder for actual permission logic
    # For example, you could check if the user is logged in and has a specific role
    session[:user_id] || [ "localhost", "127.0.0.1" ].include?(request.host)
  end

  # <%= check_box_tag "positions[#{pos}]", (positions[pos] || 0).to_s, mulivalues.include?(positions[pos].to_s), { class: "letter-position-checkbox", data: { 'bs-toggle': 'tooltip', 'bs-title': 'Empty, Must, Optional', multiple_values: mulivalues }, onclick: "toggleMultivalueCheckbox(event)" } %>
  def multiple_values_checkbox(name, muliple_values, value, is_checked, options = {})
    multi_value_string =  muliple_values.join(",")
    check_box_tag name, value, is_checked, options.merge({ data: { 'bs-toggle': 'tooltip', 'bs-title': 'Empty, Must, Optional', multiple_values: multi_value_string }, onclick: "toggleMultivalueCheckbox(event)" })
  end
end
