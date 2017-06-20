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

10.times do
  Event.create(
    title: Faker::App.name,
    description: Faker::Company.bs, # Faker::Matz.quote
    start_time: "2017-06-24 13:00:00",
    end_time: "2017-06-24 18:00:00",
    organization: Faker::Company.unique.name,
    category: Faker::Job.field,
    location: Faker::Address.unique.street_address,
    user_id: User.all.ids.sample,
  )
end

# events
puts 'Creating attendances...'

10.times do
  Attendance.create(
    user_id: User.all.ids.sample,
    event_id: Event.all.ids.sample,
  )
end

puts 'Finished!'
