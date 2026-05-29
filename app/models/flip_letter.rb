class FlipLetter
  attr_accessor :letter, :positions

  COLUMNS_FOR_LETTER = 5
  ROWS_FOR_LETTER = 5
  TOTAL_POSITIONS_FOR_LETTER = COLUMNS_FOR_LETTER * ROWS_FOR_LETTER


  # @param letter [String] The letter to flip (e.g., 'C')
  # @param positions
  #   either Array - [true, false, true, ...] where each index represents a position to flip (true means chosen)
  #   or Hash or ActionController::Parameters - {0 => true, 2 => true, 7 => true} where each key represents a position chosen
  def initialize(letter, positions)
    @letter = letter
    @positions = self.class.parse_positions(positions)
  end

  # Compare self positions with other positions to determine if they match.
  # TODO: Within @positions position value switched to integer: 0 for false, 1 for true, 2 for optional choice.
  #
  # @param other_positions
  #   either Array - [true, false, true, ...] where each index represents a position to flip (true means chosen)
  #   or Hash or ActionController::Parameters - {0 => true, 2 => true, 7 => true} where each key represents a position chosen
  def matching_positions?(other_positions)
    other_positions = self.class.parse_positions(other_positions)
    @positions == other_positions
  end


  # TODO: Within @positions position value switched to integer: 0 for false, 1 for true, 2 for optional choice.
  # @return <Array> with TOTAL_POSITIONS_FOR_LETTER length
  def self.parse_positions(positions)
    if positions.is_a?(Hash) || positions.is_a?(ActionController::Parameters)
      a = Array.new(TOTAL_POSITIONS_FOR_LETTER, false)
      positions.each do|pos, chosen|
        a[pos.to_i] = %w(true).include?(chosen.to_s)  # Set the position to true if chosen, false otherwise
      end
      a

    elsif positions.is_a?(Array)
      a = positions.collect{|pos| %w(true).include?(pos.to_s) } # Set the position to true if chosen, false otherwise
      if a.length < TOTAL_POSITIONS_FOR_LETTER
        a += Array.new(TOTAL_POSITIONS_FOR_LETTER - a.length, false)
      end
      a
    else
      Array.new(TOTAL_POSITIONS_FOR_LETTER, false)
    end
  end
end