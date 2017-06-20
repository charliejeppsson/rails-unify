# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts 'Cleaning database...'
User.destroy_all

# users
puts 'Creating users...'

10.times do
  User.create(
    first_name: Faker::Name.unique.first_name,
    last_name: Faker::Name.unique.last_name,
    headline: Faker::Job.title,
    industry: Faker::Job.field,
    email: Faker::Internet.unique.email(:first_name),
    password: "12345678",
    description:  "I live for tech and innovation. I'm a very entrepreneurial person and currently I'm looking to meet a co-founder for my next startup.",
    location: "Barcelona",
    my_experiences: {
      company_name: Faker::Company.unique.name,
      position: Faker::Job.title,
      start_time: "2017-01-20 00:00:00",
      end_time: "2017-06-20 00:00:00",
    },
    my_educations: {
      school_name: Faker::Educator.university,
      degree: Faker::Educator.course,
      start_time: "2014-09-20 00:00:00",
      end_time: "2016-09-7 00:00:00",
    },
    date_of_birth: "1995-09-23 9:35:35",
  )
end

puts 'Finished!'
