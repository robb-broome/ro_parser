require_relative 'delimiters'
class RoLexer
  include Delimiters
  attr_reader :piece
  def initialize piece
    @piece = piece
  end

  def value
    if piece.match open_matcher
      RoParser.new(piece).parse
    elsif match = piece.match(string_matcher)
      match[1]
    elsif piece.match floating_point_number_matcher
      piece.to_f
    else
      piece.to_i
    end
  end

end
