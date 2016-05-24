
# node: [1, 8, 16, 3, 2, 4, 9, 6, 4, 7, 9, 3],
# parent_id: [1, 18, 116, 13, 12, 184, 189, 186, 1164, 1167, 139, 123],

require 'portal_gate/tree_generator'

MAP={
    1 => 'master',
    2 => 'undergraduate'
}


#  seeding user
# ----------------------------------------------------------------------------------


User.create!(name: 'peng1',
             email: 'user1@test.com',
             password: 'password',
             password_confirmation: 'password',
             role: 'undergraduate',
             number: Faker::Number.number(10),
             department: 'Information Science',
             icon: File.open(File.join(Rails.root, 'app/assets/images/user_icon/default.png')),
             activated: true,
             activated_at: Time.zone.now)

User.create!(name: 'peng2',
             email: 'user2@test.com',
             password: 'password',
             password_confirmation: 'password',
             role: 'master',
             number: Faker::Number.number(10),
             department: 'Mechanical Engineering',
             icon: File.open(File.join(Rails.root, 'app/assets/images/user_icon/default.png')),
             activated: true,
             activated_at: Time.zone.now)

# user2.create_access!(
#     node: ApplicationHelper::AUTHENTICATE_TREE[:master][:node],
#     path: ApplicationHelper::AUTHENTICATE_TREE[:master][:path],
#     node_update: ApplicationHelper::AUTHENTICATE_TREE[:master][:node],
#     path_update: ApplicationHelper::AUTHENTICATE_TREE[:master][:path],
#     approved: true
# )

20.times do
  role = MAP[Random.rand(1..2)]
  name = Faker::Name.name
  email = Faker::Internet.email
  password = 'password'
  department =Faker::Commerce.department
  number= Faker::Number.number(10)
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               role: role,
               number: number,
               department: department,
               icon: File.open(File.join(Rails.root, 'app/assets/images/user_icon/default.png')),
               activated: true,
               activated_at: Time.zone.now)
end


User.all.each do |user|
  user.create_resource!(name: user.name)
end


#  seeding cooperator
# ----------------------------------------------------------------------------------

cooperator1= Cooperator.create!(
    name: Faker::Name.name,
    belongings: Faker::Company.name,
    email: 'cooperator1@test.com',
    password: 'password',
    icon: File.open(File.join(Rails.root, 'app/assets/images/user_icon/default.png')),
    password_confirmation: 'password')

app1=cooperator1.oauth_applications.create!(
    :name => 'app1',
    :redirect_uri => 'https://localhost:3000/auth/doorkeeper/callback',
    :homepage => 'http://localhost:3000',
    :description => Faker::Lorem.paragraph(2),
    :user_oriented => 'master',
    :picture => File.open(File.join(Rails.root, 'app/assets/images/icon/16.png'))
)

User.filter_by_type('master').each do |u|
  app1.users<<u
end

app1.users.each do |u|
  u.resource.accesses.create!(
      app_id: app1.id,
      node: [1, 5, 1, 6, 10, 4, 1, 2, 2, 1, 9, 8, 1, 2, 8, 1, 7, 5, 4, 8, 1, 2, 4, 5, 1, 4, 8, 1, 5, 5, 1, 6, 4, 1, 10, 2, 10, 1, 8, 2, 6, 1, 5, 10, 1, 5, 6, 9, 5, 1, 9, 9, 1, 6, 7, 3, 4, 1, 8, 10, 3, 6, 1, 3, 5, 10, 8, 1, 4, 2, 1, 8, 6, 10],
      path: [1, 15, 11, 16, 110, 154, 151, 152, 112, 111, 119, 168, 161, 162, 1108, 1101, 1107, 1105, 1104, 1548, 1541, 1542, 1544, 1515, 1511, 1514, 1528, 1521, 1525, 1125, 1121, 1126, 1114, 1111, 11110, 1112, 11910, 1191, 1198, 1192, 1686, 1681, 1685, 16110, 1611, 1615, 1616, 1619, 1625, 1621, 1629, 11089, 11081, 11086, 11087, 11083, 11014, 11011, 11018, 110110, 11013, 11076, 11071, 11073, 11075, 110710, 11058, 11051, 11054, 11042, 11041, 11048, 11046, 110410]
  )
end

#####################################
# User.first 是undergraduate,加入master的app
app1.users<<User.first
User.first.resource.accesses.create(
    app_id: app1.id,
    node: [1, 7, 1, 8, 9, 10, 7, 1, 6, 2, 4, 9, 1, 6, 10, 3, 1, 10, 8, 1, 2, 6, 9, 10, 1, 6, 3, 10, 1, 7, 3, 6, 2, 1, 5, 7, 1, 4, 5, 2, 1, 5, 8, 10, 1, 3, 6, 4, 1, 5, 4, 1, 5, 3, 1, 2, 6, 9, 7, 1, 8, 5, 1, 4, 4, 1, 2, 5, 1, 7, 7, 1, 9, 4, 10, 4, 1, 3, 5, 2, 10, 1, 5, 6, 1, 3, 9, 4, 1, 3, 10, 1, 4, 5, 6, 1, 5, 3, 10, 10, 1, 5, 3, 1, 7, 9],
    path: [1, 17, 11, 18, 19, 110, 177, 171, 176, 172, 174, 119, 111, 116, 1110, 183, 181, 1810, 198, 191, 192, 196, 199, 11010, 1101, 1106, 1103, 17710, 1771, 1777, 1773, 1776, 1712, 1711, 1715, 1767, 1761, 1764, 1765, 1722, 1721, 1725, 1728, 17410, 1741, 1743, 1746, 1194, 1191, 1195, 1114, 1111, 1115, 1163, 1161, 1162, 1166, 1169, 11107, 11101, 11108, 1835, 1831, 1834, 1814, 1811, 1812, 18105, 18101, 18107, 1987, 1981, 1989, 1984, 19810, 1914, 1911, 1913, 1915, 1912, 19210, 1921, 1925, 1966, 1961, 1963, 1969, 1994, 1991, 1993, 1101010, 110101, 110104, 110105, 11016, 11011, 11015, 11013, 110110, 110610, 11061, 11065, 11033, 11031, 11037, 11039]
)
#####################################

app2=cooperator1.oauth_applications.create!(
    :name => 'app2',
    :redirect_uri => 'https://localhost:3003/auth/doorkeeper/callback',
    :homepage => 'http://localhost:3003',
    :description => Faker::Lorem.paragraph(2),
    :user_oriented => 'undergraduate',
    :picture => File.open(File.join(Rails.root, 'app/assets/images/icon/17.png'))
)

User.filter_by_type('undergraduate').each do |u|
  app2.users<<u
end

app2.users.each do |u|
  u.resource.accesses.create!(
      app_id: app2.id,
      node: [1, 7, 1, 8, 9, 10, 7, 1, 6, 2, 4, 9, 1, 6, 10, 3, 1, 10, 8, 1, 2, 6, 9, 10, 1, 6, 3, 10, 1, 7, 3, 6, 2, 1, 5, 7, 1, 4, 5, 2, 1, 5, 8, 10, 1, 3, 6, 4, 1, 5, 4, 1, 5, 3, 1, 2, 6, 9, 7, 1, 8, 5, 1, 4, 4, 1, 2, 5, 1, 7, 7, 1, 9, 4, 10, 4, 1, 3, 5, 2, 10, 1, 5, 6, 1, 3, 9, 4, 1, 3, 10, 1, 4, 5, 6, 1, 5, 3, 10, 10, 1, 5, 3, 1, 7, 9],
      path: [1, 17, 11, 18, 19, 110, 177, 171, 176, 172, 174, 119, 111, 116, 1110, 183, 181, 1810, 198, 191, 192, 196, 199, 11010, 1101, 1106, 1103, 17710, 1771, 1777, 1773, 1776, 1712, 1711, 1715, 1767, 1761, 1764, 1765, 1722, 1721, 1725, 1728, 17410, 1741, 1743, 1746, 1194, 1191, 1195, 1114, 1111, 1115, 1163, 1161, 1162, 1166, 1169, 11107, 11101, 11108, 1835, 1831, 1834, 1814, 1811, 1812, 18105, 18101, 18107, 1987, 1981, 1989, 1984, 19810, 1914, 1911, 1913, 1915, 1912, 19210, 1921, 1925, 1966, 1961, 1963, 1969, 1994, 1991, 1993, 1101010, 110101, 110104, 110105, 11016, 11011, 11015, 11013, 110110, 110610, 11061, 11065, 11033, 11031, 11037, 11039]
  )
end

count =1
5.times do
  name = Faker::Name.name
  email = Faker::Internet.email
  password = 'password'
  company = Faker::Company.name
  cooperator=Cooperator.create!(name: name,
                                email: email,
                                password: password,
                                password_confirmation: password,
                                belongings: company)

  3.times do
    app_name=Faker::App.name
    url =Faker::Internet.url
    user_oriented=MAP[Random.rand(1..2)]
    # node2, path2=ParserHelper::newtree(4, 4, 7, 2, 10)
    node, path=PortalGate::TreeGenerator.newtree(4)
    app=cooperator.oauth_applications.create!(
        :name => app_name,
        :redirect_uri => "#{url}/auth/doorkeeper/callback",
        :homepage => url,
        :description => Faker::Lorem.paragraph(2),
        :user_oriented => user_oriented,
        :picture => File.open(File.join(Rails.root, "app/assets/images/icon/#{count}.png"))
    )

    User.filter_by_type(user_oriented).each do |u|
      app.users<<u
    end

    app.users.each do |u|
      u.resource.accesses.create!(
          app_id: app.id,
          node: node,
          path: path
      )
    end

    count=count+1

  end
end


# t.string "name"
# t.string "email"
# t.string "password_digest"
# t.string "remember_digest"

Admin.create(
    name: "peng",
    email: "admin@test.com",
    password: "password",
    password_confirmation: "password"
)


