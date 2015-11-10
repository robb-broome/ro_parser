require 'strscan'
class TokenParser
  attr_reader :parseable, :value
  def initialize parseable
    @parseable = StringScanner.new parseable.strip
    @value = []
  end

  def parse_to_token
    parseable
  end
end
