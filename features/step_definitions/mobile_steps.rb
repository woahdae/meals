Given "I am browsing on an iphone" do
  agent = "Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en)" +
    " AppleWebKit/420+ (KHTML, like Gecko) Version/3.0" +
    " Mobile/1A543a Safari/419.3"
  add_headers("HTTP_USER_AGENT" => agent)
end
