# This file should contain all the record creation needed to seed the
# database with its default values.
#
# The data can then be loaded with the rake db:seed (or created
# alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.destroy_all

user = User.create!( firstname: 'kluuu',
                     lastname: 'master',
                     email: 'admin@kluuu.com',
                     password: 'aendere_mich',
                     password_confirmation: 'aendere_mich' )
