Webrat.configure do |config|
  config.mode = :selenium
  # Selenium defaults to using the selenium environment. Use the following to override this.
  config.application_environment = :test

  if ENV['use_passenger']
    config.application_address = 'frontend.local'
    config.application_port = 80
  elsif ENV['use_stage']
    config.application_address = 'stage.crystalcommerce.com'
    config.application_port = 80
  end
  
  #The following is for a fix where in 2.3.2 sessions apparently do not work for selenium
  # config.action_controller.session = { :session_http_only => false }
end

# this is necessary to have webrat "wait_for" the response body to be available
# when writing steps that match against the response body returned by selenium
World(Webrat::Selenium::Matchers)

Before do
  # truncate your tables here, since you can't use transactional fixtures
  # For truncating your DB take a look at DatabaseCleaner
end

# patching webrat to... well, work
class Webrat::SeleniumSession
  
  ## lib code, doesn't work ##
  
  # def fill_in(field_identifier, options)
  #   locator = "webrat=#{Regexp.escape(field_identifier)}"
  #   selenium.wait_for_element locator, :timeout_in_seconds => 5
  #   selenium.type(locator, "#{options[:with]}")
  # end
  
  ## works ##
  
  def fill_in(field_identifier, options)
    selenium.wait_for_element field_identifier, :timeout_in_seconds => 5
    selenium.type(field_identifier, "#{options[:with]}")
  end
end

