require 'nokogiri'

content = File.read(ARGV[1])

links = content.split("\n").inject({}) do |result, line|
  begin
    id = line.match(/(e\d+),/)[1]
    link = line.match(/https:\/\/voicerepublic.com\/talk\/\d+/)[0]
    result.merge id => link
  rescue Exception => e
    puts line
    exit
  end
end

doc = Nokogiri::HTML(File.read(ARGV[0]))

links.each do |id, link|
  inject = " <a href='#{link}'>audio stream & archive</a>"
  doc.at_css("##{id} .textcell").append(inject)
end
