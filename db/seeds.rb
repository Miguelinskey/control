admin = User.find_or_create_by!(email: "admin@forum.local") do |u|
  u.username = "admin"
  u.password = "password"
  u.password_confirmation = "password"
  u.role = "administrator"
end

puts "Admin user: #{admin.email} / password"

[
  { name: "General",       description: "General discussion" },
  { name: "Announcements", description: "Official announcements" },
  { name: "Help",          description: "Ask for help here" },
  { name: "Off-Topic",     description: "Anything goes" }
].each do |attrs|
  Category.find_or_create_by!(name: attrs[:name]) do |c|
    c.description = attrs[:description]
  end
end

puts "Created #{Category.count} categories"
