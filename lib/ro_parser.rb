require_relative 'delimiters'
require 'strscan'
require 'pry'

class UnbalancedError < StandardError; end
class UnknownError < StandardError; end
class RoParser

  include Delimiters

  attr_reader :scanner, :parsed

  def initialize parseable, parsed={}
    @scanner = StringScanner.new parseable.strip
    @parsed = parsed
  end

  def parse
    parsed.merge! Hash[[parse_chunk]]
  end

  def parse_chunk
    split_chunk.map {|piece| value_for(piece)}
  end

  def chunk
    open_pointer = scanner.pointer + 1
    counter = 0
    found = scanner.scan_until( open_object )
    loop do
      case found
      when open
        counter += 1
      when close
        counter -= 1
      else
        puts 'none'
      end
      break if counter == 0
      va = scanner.scan_until(open_or_close)
      found = scanner.string[scanner.pointer - 1]

      raise UnbalancedError.new(message: {counter_overflow: counter}) if counter > 5
    end

    close_pointer = scanner.pointer - 2
    scanner.string[open_pointer..close_pointer]
  end

  def split_chunk
    match = chunk.match name_value_matcher
    [match[1].strip,match[2].strip]
  end

  def value_for piece
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
