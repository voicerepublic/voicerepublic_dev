# Uses binary search to determine the penalty required to make the
# given talk not show up among popular talks and then applies that
# value to the owner of the talk.
#
# Usage
#
#     rails runner "PenaltyTool.run Talk.find('slug goes here')"
#
class PenaltyTool

  class << self
    def run(talk, limit=5, min_steps=10)

      puts 'Conducting binary search to find appropriate penalty.'
      puts

      upper = Talk.maximum(:popularity)
      lower = Talk.minimum(:popularity)

      puts '  Upper Bound/Max Popularity: %s' % upper
      puts '  Lower Bound/Min Popularity: %s' % lower
      puts '  Popularity Limit:           %s' % limit
      puts '  Minimum Steps (Precision):  %s' % min_steps
      puts
      puts 'Searching...'
      puts 'Step Upper       Split       Lower       Dir'

      steps = 0
      popular = true
      history = []

      while popular or steps < min_steps
        steps += 1
        split = (upper + lower) / 2
        talk.set_penalty! split
        popular = Talk.popular.limit(limit).pluck(:id).include?(talk.id)
        dir = popular ? :down : :up
        puts "% 4s % 2.8f % 2.8f % 2.8f %s" % [steps, upper, split, lower, dir]
        lower = split if dir == :up
        upper = split if dir == :down
      end

      puts
      puts 'After %s steps, found %s to be a good penalty.' % [steps, split]

      user =  talk.venue.user

      puts
      puts 'Applying penalty to user: %s' % user.name
      puts 'Applying penalty %s series and %s talks.' % [ user.venues.count,
                                                          user.talks.count ]
      puts
      print  'Do not interrupt! This might take a while...'

      user.set_penalty! split

      puts 'done.'
    end
  end

end
