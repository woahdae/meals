# patch to make features run when require 'mathn' is present

module ActionController
  module Integration #:nodoc:
    class Session
      def redirect?
        (status/100).to_i == 3
      end
    end
  end
end