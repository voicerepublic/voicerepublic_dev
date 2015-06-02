# to be deleted after transition to markdown
namespace :transition do
  desc 'Transcend to markdown'
  task to_markdown: :environment do
    total = Talk.count
    index = 0
    Talk.find_each do |talk|
      index += 1
      print "#{index}/#{total} "
      if talk.description_has_html?
        puts "Convert html to md for talk #{talk.id}."
        talk.update_attribute :description, talk.description_as_markdown
      else
        puts "Skipping talk #{talk.id}. Found no html tags in description."
      end
    end
  end
end
