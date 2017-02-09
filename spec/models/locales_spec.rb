require 'rails_helper'

describe I18n do

  def cumulate_values(data)
    case data
    when Array then data
    when Hash then data.map { |key, value| cumulate_values(value) }
    else [ data ]
    end.flatten
  end

  it 'should test properly' do
    values = cumulate_values(a: '1', b: %w(2 3), c: {d: '4', e: '5'})
    expect(values).to eq(%w(1 2 3 4 5))
  end

  # This spec doesn't use `expect` nor `should` since comparing with
  # cumulated translation values  would yield unreadable amounts of
  # output upon failure.
  #
  # This is a rather naive check, which ignores multiline entries.
  #
  # Since it originally barfed on urls its will ignore those too.
  #
  # This spec also only works with the default i18n backend.
  it 'has no naming collisions' do
    # collect the values of all translations
    translations = I18n.backend.send(:translations)
    translations = cumulate_values(translations)

    # scan the locale files for translation values
    files = Dir.glob(Rails.root.join('config/locales/*.yml'))
    errors = []
    files.each do |file|
      File.read(file).split("\n").each do |line|
        next unless line.match(/^\s+\w+:\s*(.+)\s*$/)
        next if line.match(/https?:\/\//)
        begin
          value = YAML.load($1)
        rescue
          puts 'ERROR PARSING...'
          puts line
        end
        # and check if these exist in the translations
        unless translations.include?(value)
          errors << "Blocked: '#{value}'"
        end
      end
    end

    expect(errors).to be_empty
  end

end
