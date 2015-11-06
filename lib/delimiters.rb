module Delimiters
  def open; '{'; end
  def close; '}'; end
  def open_object; /\{/ ; end
  def close_object;  /}/ ; end
  def open_or_close; /\{|}/; end
  def open_array;  /\[/ ; end
  def close_array;  /]/; end
  def name_delimiter;  /:/; end
  def string_matcher; /\A["|'](.+)["|']\z/; end
  def open_matcher; /\A#{open_object}/; end
  def name_value_matcher; /(\A.*?):(.*?\z)/; end
  def floating_point_number_matcher; /\./; end
end
