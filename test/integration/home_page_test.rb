require "test_helper"

class HomePageTest < ActionDispatch::IntegrationTest

  test "Flip the letters and fail the challenge with incorrect positions" do
    initial_visit_to_see_challenge()

    flip_letters = find_flip_letters
    letters = flip_letters.collect(&:letter)

    # Simulate submitting the form with incorrect positions for the letters
    post verify_flip_to_words_challenge_path, params: {
      letters: letters,
      letters[0] => { '0' => 1, '1' => 0, '2' => 0 },
      letters[1] => { '0' => 0, '1' => 1, '2' => 0 },
      letters[2] => { '0' => 0, '1' => 0, '2' => 1 }
    }

    follow_redirect!

    # Check that an alert message is displayed indicating failure
    assert_select (".alert-danger"), text: /choice\s+of\s+positions.+is\s+incorrect/i
  end

  test 'Flip the letters and pass the challenge with correct positions' do
    initial_visit_to_see_challenge()

    flip_letters = find_flip_letters
    # Simulate submitting the form with correct positions for the letters
    
    params = { letters: flip_letters.collect(&:letter) }
    flip_letters.each do |flip_letter|
      expected_positions = flip_letter.positions.each_with_index.select{ |pos, index| pos == 1 }.map{ |pos, index| index }
      user_answers = {}
      expected_positions.each{ |pos| user_answers[pos.to_s] = 1 }
      params[flip_letter.letter] = user_answers
    end

    post verify_flip_to_words_challenge_path, params: params

    follow_redirect!

    # Return to orginal page
    assert_equal test_account_page_path, path

    # Check that a success message is displayed indicating the challenge was passed
    assert_select (".alert-success"), text: /successfully completed/i
  end

  private 

  def initial_visit_to_see_challenge
    get root_path
    assert_response :success
    assert_select "#flip-to-words-challenge"
    assert_select "#flip-to-words-challenge .flip-letter", minimum: 1
    assert_select "#flip-to-words-challenge input[name='letters[]']", minimum: 1

    get test_account_page_path
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "#flip-to-words-challenge"
    assert_not_equal 'passed', session[:flip_to_words_challenge_status]
    assert session[:return_url].present?, "Expected session[:return_url] to be set to the originally requested URL"
  end

  # @return <Array of FlipLetter>
  def find_flip_letters
    # This method can be implemented to parse the HTML response and find the letters and their corresponding positions to flip for testing purposes.
    hidden_inputs = css_select("#flip-to-words-challenge input[name='letters[]']")
    assert_not_empty hidden_inputs, "Expected to find hidden inputs for letters to flip"

    # Make sure the letters actually exists in the FlipLetterMap for the test to be meaningful
    flip_letter_map = FlipLetterMap.load_from_file
    flip_letters = []
    hidden_inputs.each do |input|
      letter = input["value"]
      flip_letter = flip_letter_map.get_flip_letter(letter)
      assert_not_nil flip_letter, "Expected letter #{letter} to exist in FlipLetterMap"
      flip_letters << flip_letter
    end
    flip_letters
  end

end