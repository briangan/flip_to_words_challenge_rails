# Attributes:
# @map <Hash {String => FlipLetter}> - A hash mapping: 'C' => FlipLetter instance
class FlipLetterMap
  attr_reader :map

  def initialize
    @map = {}
  end

  # Add a letter and its corresponding positions to flip.
  # @param letter [String] The letter to flip (e.g., 'C')
  # @param positions either 
  #   Array - [true, false, true, ...] where each index represents a position to flip (true means chosen)
  #   Hash or ActionController::Parameters - {0 => true, 2 => true, 7 => true} where each key represents a position chosen
  def add_letter(letter, positions)
      flip_letter = FlipLetter.new(letter, positions)
      @map[letter.upcase] = flip_letter
      flip_letter
  end

  # @return <Array> An array of boolean values representing the positions to flip for the given letter.
  def [](letter)
    @map[letter.upcase]&.positions || []
  end

  # @return <FlipLetterMap>
  def self.load_from_file
    m = new
    file_path = Rails.root.join('config', 'flip_letters.csv')
    if File.exist?(file_path)
      CSV.foreach(file_path) do |row|
        letter, *positions = row
        m.add_letter(letter, positions || [])
      end
    end
    m
  end

  def to_csv(sort_or_not = true)
    keys = sort_or_not ? @map.keys.sort : @map.keys
    keys.map do |letter|
      flip_letter = @map[letter]
      "#{letter.upcase},#{flip_letter.positions.join(',')}"
    end.join("\n")
  end

  # 
  def save_to_file(sort_or_not = true)
    file_path = Rails.root.join('config', 'flip_letters.csv')
    File.write(file_path, to_csv)
  end
end