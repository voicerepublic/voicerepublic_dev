task :translations do
  # read log
  path = File.expand_path('../../../log/translations.log', __FILE__)
  lines = File.read(path).split("\n")
  
  # aggregate
  stats = Hash.new { |h, k| h[k] = 0 }
  pattern = /(\d{4}-\d\d-\d\d \d\d:\d\d:\d\d \+\d{4}) (\w\w) ([\w.]+) ({.*})/
  lines.each do |line|
    _, time, locale, key, opts = line.match(pattern).to_a
    stats[key] += 1 unless key.nil?
  end
  
  # sort
  sorted = stats.to_a.sort_by { |a| a.last }.reverse
  w2 = sorted.first.last.to_s.length

  # fetch keys from locale files and add with 0
  locales = I18n.available_locales
  locales.each do |locale|
    nested = { locale => I18n.backend.translate(locale, '') }
    c = Class.new.tap { |t| t.extend(I18n::Backend::Flatten) }
    flat = c.flatten_translations(locale, nested, true, false)
    flat.each do |key, value|
      key = key.to_s[3..-1] # slice locale
      if stats[key] == 0
        sorted << [key, 0]
      end
    end
  end

  w1 = sorted.size.to_s.length

  # output
  sorted.each_with_index do |e, index|
    puts "% #{w1}s\t% #{w2}s\t%s" % ([ index+1 ] + e.reverse)
  end
end
