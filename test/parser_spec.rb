require_relative '../lib/ro_parser'

describe RoParser do
  let(:json_example) do
    # big sample copied from somewhere. Use later.
    {
      "glossary": {
        "title": "example glossary",
        "GlossDiv": {
          "title": "S",
          "GlossList": {
            "GlossEntry": {
              "ID": "SGML",
              "SortAs": "SGML",
              "GlossTerm": "Standard Generalized Markup Language",
              "Acronym": "SGML",
              "Abbrev": "ISO 8879:1986",
              "GlossDef": {
                "para": "A meta-markup language, used to create markup languages such as DocBook.",
                "GlossSeeAlso": ["GML", "XML"]
              },
              "GlossSee": "markup"
            }
          }
        }
      }
    }
  end

  it 'should work' do
    expect(true).to be_truthy
    expect(false).to be_falsey
  end

  it 'should chunk' do
    parser = RoParser.new("{'a': {'b': {'x': 3}}}")
    chunk = parser.chunk
    expect(chunk).to eq("'a': {'b': {'x': 3}}")
  end

  it 'should split chunks into name: value pairs' do
    parser = RoParser.new("{'a': {'b': {'x': 3}}}")
    split = parser.split_chunk
    expect(split.first).to eq "'a'"
    expect(split[1]).to eq "{'b': {'x': 3}}"
  end

  it 'does not go forever if malformed json is encountered' do
    missing_closing_bracket = "{'a': 'robb'"
    parser = RoParser.new missing_closing_bracket
    expect{parser.parse}.to raise_error(UnbalancedError)
  end

  it 'can parse an array' do
  end

  it 'can extract a number' do
    parser = RoParser.new("{'a': 'robb'}")
    expect(parser.value_for '1').to eq(1)
  end

  it 'can extract a float' do
    parser = RoParser.new("{'a': 'robb'}")
    expect(parser.value_for '1.01').to eq(1.01)
  end

  it 'should find a character value' do
    parser = RoParser.new("{'a': 'robb'}")
    expect(parser.parse).to eq({'a' => 'robb'})
  end

  it 'should find a number' do
    parser = RoParser.new("{'a': 1}")
    expect(parser.parse).to eq({'a' => 1})
  end

  it 'should find a nested item' do
    parser = RoParser.new("{'a': {'b': 1}}")
    expect(parser.parse).to eq({'a' => {'b' => 1}})
  end

  it 'should find a nested nested item' do
    parser = RoParser.new("{'a': {'b': {'x': 3}}}")
    expect(parser.parse).to eq({'a' => {'b' => {'x' => 3}}})
  end
end
