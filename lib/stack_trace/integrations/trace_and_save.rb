# frozen_string_literal: true

require_relative 'presenters/html'

module StackTrace
  module Integrations
    module TraceAndSave
      def trace_and_save(&block)
        StackTrace.trace(&block)

        html = Presenters::HTML.new
        html.add(StackTrace.current)
        html.save
      end
    end
  end
end

StackTrace.extend(StackTrace::Integrations::TraceAndSave)
