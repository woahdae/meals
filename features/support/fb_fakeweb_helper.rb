User.before_save do |user|
  @user_hash = "123"
  FakeWeb.register_uri(:get, 'http://api.facebook.com/restserver.php', 
    :body =>  ERB.new(File.read('features/fakeweb/facebook.connect.registerUsers.xml.erb')).result
  )
end
