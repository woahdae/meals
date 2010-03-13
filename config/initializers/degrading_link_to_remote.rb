module Bezurk #:nodoc:
  module ActionView #:nodoc:
    module PrototypeHelperExtensions
      def self.included(base)
        base.alias_method_chain :link_to_remote, :degradation
      end

      def link_to_remote_with_degradation(name, options = {}, html_options = {})
        html_options[:href] = url_for(options[:url]) if !html_options.has_key?(:href)
        link_to_remote_without_degradation(name, options, html_options)
      end
    end
  end
end

ActionView::Helpers::PrototypeHelper.send(:include,
  Bezurk::ActionView::PrototypeHelperExtensions)