# node: [1, 8, 16, 3, 2, 4, 9, 6, 4, 7, 9, 3],
# parent_id: [1, 18, 116, 13, 12, 184, 189, 186, 1164, 1167, 139, 123],

require 'portal_gate/tree_generator'

STUDENT_ROLE=%w(master undergraduate doctor)
TEACHER_ROLE=['professor', 'associate professor', 'executive stuff']

class AppGenreator

  def self.user_oriented
    user_oriented=""
    STUDENT_ROLE.to_a.sort { rand()-0.5 }[1..rand(1..2)].each do |role|
      user_oriented<< " #{role}"
    end

    TEACHER_ROLE.to_a.sort { rand()-0.5 }[1..rand(1..2)].each do |role|
      user_oriented<<" #{role}"
    end

    return user_oriented
  end

end

#  seeding students and teachers
# ----------------------------------------------------------------------------------

100.times do |index|
  User.create!(name: Faker::Name.name,
               email: "student#{index}@test.com",
               password: 'password',
               password_confirmation: 'password',
               role: STUDENT_ROLE.sample,
               major: Faker::Lorem.word,
               number: Faker::Number.number(10),
               department: Faker::Educator.secondary_school,
               icon: File.open(File.join(Rails.root, 'app/assets/images/user_icon/default.png')),
               activated: true,
               activated_at: Time.zone.now)
end

20.times do |index|
  User.create!(name: Faker::Name.name,
               email: "teacher#{index}@test.com",
               password: 'password',
               password_confirmation: 'password',
               role: TEACHER_ROLE.sample,
               major: Faker::Lorem.word,
               number: Faker::Number.number(10),
               department: Faker::Educator.secondary_school,
               icon: File.open(File.join(Rails.root, 'app/assets/images/user_icon/default.png')),
               activated: true,
               activated_at: Time.zone.now)
end

#  seeding developer
# ----------------------------------------------------------------------------------


count =1
5.times do
  developer=User.create!(name: Faker::Name.name,
                         email: "developer#{count}@test.com",
                         password: 'password',
                         password_confirmation: 'password',
                         company: Faker::Company.name,
                         developer: true,
                         activated: true,
                         icon: File.open(File.join(Rails.root, 'app/assets/images/user_icon/default.png')),
                         activated_at: Time.zone.now)

  3.times do
    url =Faker::Internet.url
    # node2, path2=ParserHelper::newtree(4, 4, 7, 2, 10)
    node, path=PortalGate::TreeGenerator.newtree(4, 1, 2, 1, 4)
    user_oriented=AppGenreator.user_oriented
    app=developer.oauth_applications.create!(
        :name => Faker::App.name,
        :redirect_uri => "#{url}/auth/doorkeeper/callback",
        :homepage => url,
        :description => Faker::Lorem.paragraph(2),
        :user_oriented => user_oriented,
        :picture => File.open(File.join(Rails.root, "app/assets/images/icon/#{count}.png"))
    )

    User.certain_roles(user_oriented).each do |u|
      app.users<<u
      u.accesses.create!(
          app_id: app.id,
          node: node,
          path: path
      )
    end
    count=count+1
  end
end

User.create(
    name: "zhaoqing",
    email: "admin@test.com",
    password: "password",
    password_confirmation: "password",
    admin: true,
    activated: true,
    activated_at: Time.zone.now
)

#-------------------------special case---------------------

ENTRANCE_DOMAIN="http://localhost:3000"

app=User.find_by(:email => 'developer1@test.com').oauth_applications.first
app.update(
    homepage: ENTRANCE_DOMAIN,
    redirect_uri: "#{ENTRANCE_DOMAIN}/auth/doorkeeper/callback",
    name: "Course Selection")

student=User.find_by(:email => 'student1@test.com')
unless app.users.find_by(id: student.id)
  app.users<<student
  student.accesses.create!(
      app_id: app.id,
      node: [1],
      path: [1]
  )
end

teacher=User.find_by(:email => 'teacher1@test.com')
unless app.users.find_by(id: teacher.id)
  app.users<<teacher
  teacher.accesses.create!(
      app_id: app.id,
      node: [1],
      path: [1]
  )
end






