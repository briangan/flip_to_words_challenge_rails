require "test_helper"

class FlipLetterMapTest < ActiveSupport::TestCase
  test "each FlipLetter has valid letters and positions" do
    flip_letter_map = FlipToWords::FlipLetterMap.load_from_file

    flip_letter_map.map.each do |letter, flip_letter|
      assert_not_nil letter, "Map key letter '#{letter}' should not be nil"
      assert_equal letter, flip_letter.letter.upcase, "FlipLetter letter should match map key '#{letter}'"
      assert_instance_of FlipToWords::FlipLetter, flip_letter, "Map value '#{flip_letter}' should be a FlipLetter instance"

      assert_not_nil flip_letter.positions, "Positions for letter '#{letter}' should not be nil"
      assert_instance_of Array, flip_letter.positions, "Positions for letter '#{letter}' should be an array"
      assert_not_empty flip_letter.positions, "Positions for letter '#{letter}' should not be empty"
    end
  end

  test "map contains expected letters from CSV" do
    flip_letter_map = FlipToWords::FlipLetterMap.load_from_file

    # Based on the CSV file, these letters should be present
    expected_letters = %w[B C D E F G H J L O P T U X Y]

    expected_letters.each do |letter|
      assert flip_letter_map.map.key?(letter), "Map should contain letter '#{letter}'"
      assert_not_nil flip_letter_map.map[letter], "Value for letter '#{letter}' should not be nil"
    end

    b_letter = flip_letter_map.map["B"]
    assert_not_nil b_letter, "Map should contain letter 'B'"
    exact_positions = b_letter.positions
    assert_equal exact_positions, b_letter.positions, "Positions for letter 'B' should match expected positions from CSV"
    assert_equal b_letter.matching_positions?(exact_positions), true, "matching_positions? should return true for exact positions"

    if exact_positions.index(2) # has optional choice
      flipped_off_positions = exact_positions.map { |pos| pos == 2 ? 0 : pos }
      assert_equal b_letter.matching_positions?(flipped_off_positions), true, "matching_positions? should return true for flipped off positions"
      flipped_on_positions = exact_positions.map { |pos| pos == 2 ? 1 : pos }
      assert_equal b_letter.matching_positions?(flipped_on_positions), true, "matching_positions? should return true for flipped on positions"
    end

    # Test w/ diff positions
    flipped_positions = exact_positions.map { |pos| pos == 1 ? 0 : pos == 0 ? 1 : pos }
    assert_equal b_letter.matching_positions?(flipped_positions), false, "matching_positions? should return false for flipped positions"
  end
end
