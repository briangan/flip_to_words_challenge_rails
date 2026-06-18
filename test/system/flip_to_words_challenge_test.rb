require "application_system_test_case"

class FlipToWordsChallengeTest < ApplicationSystemTestCase
  include FlipToWords::FlipLettersHelper

  test "Complete flip to words challenge with UI interactions - failure scenario" do
    # Visit the home page first to see the challenge
    visit root_path
    assert_selector "#flip_to_words_challenge"
    assert_selector "#flip_to_words_challenge .flip-letter", minimum: 1

    # Try to visit the test account page, should be redirected to challenge
    visit test_account_page_path
    assert_selector "#flip_to_words_challenge"

    # Get the letters from the form
    flip_letters = find_flip_letters_from_page

    # Fill out the form with INCORRECT positions
    flip_letters.each do |flip_letter|
      # Select wrong positions (just select the first position for each letter)
      all(".flip-letter").each do |letter_card|
        within(letter_card) do
          if letter_card.has_text?(flip_letter.letter)
            # Click on a wrong position in the grid (just click first checkbox)
            first("input.letter-position-checkbox").click
            break
          end
        end
      end
    end

    # Submit the form
    click_button "Submit"

    # Should see error message
    assert_selector ".alert-danger"
    assert_text(/choice\s+of\s+positions.+is\s+incorrect/i)
  end

  test "Complete flip to words challenge with UI interactions - success scenario" do
    # Visit the home page first to see the challenge
    visit root_path
    assert_selector "#flip_to_words_challenge"

    # Try to visit the test account page, should be redirected to challenge
    visit test_account_page_path
    assert_selector "#flip_to_words_challenge"

    # Get the letters and their correct positions
    flip_letters = find_flip_letters_from_page

    # Fill out the form with CORRECT positions by clicking checkboxes
    flip_letters.each do |flip_letter|
      # Get the correct positions for this letter
      expected_positions = flip_letter.positions.each_with_index.select { |pos, _| pos == 1 }.map { |_, index| index }
      
      # Find the card for this letter and click the correct checkboxes
      all(".flip-letter").each do |letter_card|
        within(letter_card) do
          if letter_card.has_text?(flip_letter.letter)
            expected_positions.each do |position_index|
              find("input[name='#{flip_letter.letter}[#{position_index}]']", visible: :all).click
            end
            break
          end
        end
      end
    end

    # Submit the form
    click_button "Submit"

    # Should see success message and be redirected to test account page
    assert_text(/successfully completed/i)
    assert_current_path test_account_page_path
    assert_selector ".alert-success"

    # Visit test account page again - should NOT see the challenge
    visit test_account_page_path
    assert_current_path test_account_page_path
    assert_no_selector "#flip_to_words_challenge"
  end

  test "Navigate and interact with flip letters challenge grid" do
    visit root_path
    visit test_account_page_path

    # Verify the challenge UI structure
    assert_selector "#flip_to_words_challenge"
    assert_selector "#flip_to_words_challenge form"
    
    flip_letters = find_flip_letters_from_page
    
    flip_letters.each do |flip_letter|
      # Verify each letter has a grid
      all(".flip-letter").each do |letter_card|
        within(letter_card) do
          if letter_card.has_text?(flip_letter.letter)
            # Should have the expected number of checkboxes (grid cells)
            assert_selector "input.letter-position-checkbox", count: FlipToWords::FlipLetter::TOTAL_POSITIONS_FOR_LETTER
            
            # Test clicking and unclicking a checkbox
            first_checkbox = first("input.letter-position-checkbox", visible: :all)
            first_checkbox.click
            assert first_checkbox.checked?
            
            first_checkbox.click
            assert_not first_checkbox.checked?
            
            break
          end
        end
      end
    end
  end


  private

  # Extract flip letters from the current page
  def find_flip_letters_from_page
    # Get letters from hidden inputs
    letter_inputs = all("input[name='letters[]']", visible: :all)
    assert_not_empty letter_inputs, "Expected to find hidden inputs for letters"

    flip_letter_map = FlipToWords::FlipLetterMap.load_from_file
    flip_letters = []

    letter_inputs.each do |input|
      letter = input.value
      flip_letter = flip_letter_map.get_flip_letter(letter)
      assert_not_nil flip_letter, "Expected letter #{letter} to exist in FlipLetterMap"
      flip_letters << flip_letter
    end

    flip_letters
  end
end
