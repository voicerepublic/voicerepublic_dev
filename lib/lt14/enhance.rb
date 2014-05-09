require 'nokogiri'

content = File.read(ARGV[0])

links = content.split("\n").inject({}) do |result, line|
  id = line.match(/(e\d+),/)[1]
  link = line.match(/https:\/\/voicerepublic.com\/talk\/\d+/)[0]
  result.merge id => link
end

doc = Nokogiri::HTML(File.read(ARGV[1]))

links.each do |id, link|
  inject = " <a href='#{link}'>audio stream & archive</a>"
  doc.at_css("##{id} .textcell").append(inject)
end
    
