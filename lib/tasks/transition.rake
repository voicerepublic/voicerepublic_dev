# to be deleted after transition to markdown
namespace :transition do
  desc 'Transcend to markdown'
  task to_markdown: :environment do

    total = User.count
    index = 0
    User.find_each do |user|
      index += 1
      print "#{index}/#{total} "
      if user.about_has_html?
        puts "Convert html to md for user #{user.id}."
        user.update_attribute :about, user.about_as_markdown
      else
        puts "Skipping user #{user.id}. Found no html tags in `about`."
      end
    end

    total = Venue.count
    index = 0
    Venue.find_each do |venue|
      index += 1
      print "#{index}/#{total} "
      if venue.description_has_html?
        puts "Convert html to md for venue #{venue.id}."
        venue.update_attribute :description, venue.description_as_markdown
      else
        puts "Skipping venue #{venue.id}. Found no html tags in `description`."
      end
    end

    total = Talk.count
    index = 0
    Talk.find_each do |talk|
      index += 1
      print "#{index}/#{total} "
      if talk.description_has_html?
        puts "Convert html to md for talk #{talk.id}."
        talk.update_attribute :description, talk.description_as_markdown
      else
        puts "Skipping talk #{talk.id}. Found no html tags in `description`."
      end
    end

  end
end
