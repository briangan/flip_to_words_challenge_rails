class FlipLetter
  attr_accessor :letter, :positions

  COLUMNS_FOR_LETTER = 5
  ROWS_FOR_LETTER = 5
  TOTAL_POSITIONS_FOR_LETTER = COLUMNS_FOR_LETTER * ROWS_FOR_LETTER
  COLOR_CLASSES_COUNT = 6

  POSITION_VALUES = [ 1, 2 ]
  POSITION_VALUE_MEANINGS = {
    0 => "not chosen",
    1 => "chosen",
    2 => "optional choice"
  }

  # @param letter [String] The letter to flip (e.g., 'C')
  # @param positions
  #   either Array - [true, false, true, ...] where each index represents a position to flip (true means chosen)
  #   or Hash or ActionController::Parameters of position => choice_value (POSITION_VALUE_MEANINGS), for example, {0 => 1, 2 => 2, 7 => 0}
  def initialize(letter, positions)
    @letter = letter
    @positions = self.class.parse_positions(positions)
  end

  # Compare self positions with other positions to determine if they match.
  # TODO: Within @positions position value switched to integer: 0 for false, 1 for true, 2 for optional choice.
  #
  # @param other_positions
  #   either Array - [true, false, true, ...] where each index represents a position to flip (true means chosen)
  #   or Hash or ActionController::Parameters of position => choice_value (POSITION_VALUE_MEANINGS), for example, {0 => 1, 2 => 2, 7 => 0}
  # @return [Boolean]
  def matching_positions?(other_positions)
    other_positions = self.class.parse_positions(other_positions)
    index = 0
    @positions.all? do|pos|
      other_value = other_positions[index] || 0
      index += 1
      pos == 2 || pos == other_value
    end
  end


  # Within @positions position value switched to integer value of POSITION_VALUE_MEANINGS
  # This ensures @positions has the same length for comparison.
  # @return <Array> with TOTAL_POSITIONS_FOR_LETTER length
  def self.parse_positions(positions)
    if positions.is_a?(Hash) || positions.is_a?(ActionController::Parameters)
      a = Array.new(TOTAL_POSITIONS_FOR_LETTER, 0)
      positions.each do |pos, chosen|
        a[pos.to_i] = chosen.to_i
      end
      a

    elsif positions.is_a?(Array)
      a = positions.collect { |pos| pos.to_i }
      if a.length < TOTAL_POSITIONS_FOR_LETTER
        a += Array.new(TOTAL_POSITIONS_FOR_LETTER - a.length, 0)
      end
      a
    else
      Array.new(TOTAL_POSITIONS_FOR_LETTER, 0)
    end
  end
end
