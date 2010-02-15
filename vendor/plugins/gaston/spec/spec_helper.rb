$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'gaston'

require 'rubygems'
require 'ruby-debug'
require 'spec'
require 'spec/autorun'
require 'matchers/array_matcher'

Spec::Runner.configure do |config|
  
end

module Gaston
  module Spec
    # Just to define necessary methods.
    # Must be stubbed if you actually expect results
    class FakeActiveRecord
      class << self
        # We do it this way so we can mock find and not worry about
        # the block
        def find_each(*args)
          self.find(:all, *args).each {|res| yield res}
        end

        def all
          []
        end

        def method_missing(sym, *args, &block)
          if sym =~/^find/
            []
          end
        end
      end
    end
  end
end
