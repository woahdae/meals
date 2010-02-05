Factory.define(:user) do |user|
  user.login "ghent"
  user.name  "Ghent Pettit"
  user.email "ghent.pettit@example.com"
  user.password "password"
  user.password_confirmation "password"
end