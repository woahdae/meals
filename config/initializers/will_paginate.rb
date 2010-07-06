require 'will_paginate/finders/active_record'
WillPaginate::Finders::ActiveRecord.enable!

if defined? ::ActionDispatch::ShowExceptions
  ActionDispatch::ShowExceptions.rescue_responses['WillPaginate::InvalidPage'] = :not_found
end

require 'will_paginate/view_helpers/action_view'
ActionView::Base.send(:include, WillPaginate::ViewHelpers::ActionView)
