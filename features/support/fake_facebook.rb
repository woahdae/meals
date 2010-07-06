FakeWeb.register_uri(:get,
'https://graph.facebook.com/oauth/access_token?client_id=155983016790&redirect_uri=http://www.meallife.com/session/from_facebook&client_secret=948accac0c5db5a8de4b030e1a4cd586&code=NastyCode',
  :body =>  File.read('features/fakeweb/graph.facebook.com.access_token')
)

FakeWeb.register_uri(:get,
"https://graph.facebook.com/me?access_token=155983016790%7C2.xE3x6o0zoAA0Mbvww_q47g__.3600.1278403100-10712629%7CtXeSLmlst6XNtnoZYekUUlcTKac.",
  :body => File.read("features/fakeweb/graph.facebook.com.me.json")
)
