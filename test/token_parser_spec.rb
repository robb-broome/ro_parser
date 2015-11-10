require_relative '../lib/token_parser'
require_relative '../lib/token_parser'

describe TokenParser do

  let(:simple) {"{ 'key': 'value'}}"}
  describe 'simpleparsing' do

    subject {TokenParser.new(simple)}

    it 'converts json into tokens' do
      skip 'need a reasonable ast description for json'
      subject.parse_to_token
      expect(subject.value).to eq [:object, :str_literal, 'key', :str_literal, 'value', :close]
    end
  end
end

