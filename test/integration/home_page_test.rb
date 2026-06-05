require "test_helper"

class HomePageTest < ActionDispatch::IntegrationTest
  test "homepage renders flip-letter containers" do
    # Visit the homepage
    get root_path

    # Assert the response is successful
    assert_response :success

    # Check that the flip-2-words-challenge container exists
    assert_select "div#flip-2-words-challenge.challenge-container"

    # Check that flip-letter containers are rendered
    assert_select "div.flip-letter", minimum: 1
  end
end
