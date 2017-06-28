# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts 'Cleaning database...'

Education.destroy_all
Experience.destroy_all
Attendance.destroy_all
Event.destroy_all
User.destroy_all

# users
puts 'Creating users...'

10.times do
  user = User.create(
    first_name: Faker::Name.unique.first_name,
    last_name: Faker::Name.unique.last_name,
    headline: Faker::Job.title,
    industry: Faker::Job.field,
    email: Faker::Internet.unique.email(:first_name),
    password: "12345678",
    description:  "I live for tech and innovation. I'm a very entrepreneurial person and currently I'm looking to meet a co-founder for my next startup.",
    location: "Barcelona",
    date_of_birth: "1995-09-23 9:35:35",
  )
  3.times do
    Experience.create(
      company_name: Faker::Company.unique.name,
      job_title: Faker::Job.title,
      start_date: "2017-01-20",
      end_date: "2017-06-20",
      user_id: user.id,
    )
  end
  3.times do
    Education.create(
      school_name: Faker::University.name,
      field: Faker::Educator.course,
      start_date: "2014-09-20",
      end_date: "2016-09-7",
      user_id: user.id,
    )
  end
end

# create admin users for the four of us
# admins = ["charlie.jeppsson1@gmail.com", "wlad@wlad.com", "weronika@weronika.com", "francesca@francesca.com"]

# for i in 0..3 do
#   User.all[i][email: admins[i]]
#   User.all[i].admin = true
# end


# events
puts 'Creating events...'

Event.create(
  title: "Le Wagon Barcelona Demo Day",
  description: "Come to what 23 outstanding people was able to build after only 9 weeks of coding.", # Faker::Matz.quote
  start_time: "2017-06-24 13:00:00",
  end_time: "2017-07-05 18:00:00",
  organization: "Le Wagon",
  category: "Tech",
  location: "Travessera de Dalt, 33 08024 Barcelona",
  user_id: User.all.ids.sample,
)

Event.create(
  title: "Create a community",
  description: "Learn how to create a genuine sense of belonging in a community", # Faker::Matz.quote
  start_time: "2017-06-24 13:00:00",
  end_time: "2017-07-24 18:00:00",
  organization: "Nova",
  category: "Human Resources",
  location: "Carrer d'Arago, 332 08009 Barcelona",
  user_id: User.all.ids.sample,
)

Event.create(
  title: "The power of juices",
  description: "Vitamines, proteins and many more green benefits",
  start_time: "2017-06-28 13:00:00",
  end_time: "2017-06-28 18:00:00",
  organization: "Yumi",
  category: "Food",
  location: "Carrer d'Arago, 202 08009 Barcelona",
  user_id: User.all.ids.sample,
)

Event.create(
  title: "Launch your start-up in an hour",
  description: "Nothing is impossible", # Faker::Matz.quote
  start_time: "2017-08-24 13:00:00",
  end_time: "2017-08-24 18:00:00",
  organization: "Living in clouds",
  category: "Innovation",
  location: "Carrer de Corsega, 103, 08036 Barcelona",
  user_id: User.all.ids.sample,
)

Event.create(
  title: "VivaTech",
  description: "Come to meet 100 start-ups during a day", # Faker::Matz.quote
  start_time: "2017-06-30 13:00:00",
  end_time: "2017-06-30 18:00:00",
  organization: "VivaTechnology",
  category: "Tech",
  location: "Carrer de Corsega, 120, 08036 Barcelona",
  user_id: User.all.ids.sample,
)

Event.create(
  title: "Team Management with Babybell",
  description: "Learn how to manage a team in an efficient and cheesy way", # Faker::Matz.quote
  start_time: "2017-07-30 13:00:00",
  end_time: "2017-07-30 18:00:00",
  organization: "Babybell",
  category: "Psychology",
  location: "Carrer de Valencia, 23, 08009 Barcelona",
  user_id: User.all.ids.sample,
)

Event.create(
  title: "What's design?",
  description: "Everything is design, so what's everything?", # Faker::Matz.quote
  start_time: "2017-09-24 13:00:00",
  end_time: "2017-09-24 18:00:00",
  organization: "Sketch",
  category: 'Design',
  location: "Carrer de Valencia, 301, 08009 Barcelona",
  user_id: User.all.ids.sample,
)

Event.create(
  title: "Learn coding at 4 years old?",
  description: "Coding is now available for schools, come to discover this new way of learning", # Faker::Matz.quote
  start_time: "2017-11-24 13:00:00",
  end_time: "2017-11-24 18:00:00",
  organization: "Catalunya Education",
  category: "Education",
  location: "Carrer de Valencia, 125, 08009 Barcelona",
  user_id: User.all.ids.sample,
)


# events
puts 'Creating attendances...'

10.times do
  Attendance.create(
    user_id: User.all.ids.sample,
    event_id: Event.all.ids.sample,
  )
end

puts 'Finished!'
