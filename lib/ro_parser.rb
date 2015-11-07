require_relative 'delimiters'
require_relative 'ro_lexer'
require 'strscan'
require 'pry'
require 'logger'

class UnbalancedError < StandardError; end
class UnknownError < StandardError; end
class RoParser
   VERBOSE = false

  include Delimiters

  attr_reader :scanner, :parsed, :logger

  def initialize parseable, parsed={}
    @scanner = StringScanner.new parseable.strip
    @parsed = parsed
    @logger = Logger.new STDOUT
    @logger.level = Logger::INFO
  end

  def parse
    parsed.merge! Hash[[parse_chunk]]
  end

  def parse_chunk
    split_chunk.map do |piece|
      RoLexer.new(piece).value
    end
  end

  def chunk
    logger.debug "Initial string: #{scanner.string}"
    open_pointer = scanner.pointer + 1
    counter = 0
    loop do
      va = scanner.scan_until(open_or_close)
      logger.debug "after scan, value = #{va[-1]}, pointer is now: #{scanner.pointer}, counter is: #{counter}" rescue nil
      found = scanner.string[scanner.pointer - 1]
      case found
      when open
        counter += 1
        logger.debug "Counter Incremented to: #{counter}"
      when close
        counter -= 1
        logger.debug "Counter Decremented to: #{counter}"
      when scanner.eos?
        logger.error "EOS reached"
        break
      else
        logger.error 'none'
      end
      break if counter == 0

      if counter > 100
        logger.error 'threshhold'
        raise UnbalancedError.new(message: {counter_overflow: counter})
      end
    end
    logger.debug "Done: Counter: #{counter}"

    close_pointer = scanner.pointer - 2
    scanner.string[open_pointer..close_pointer].tap {|endval| logger.debug "End value is #{endval}"}
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
