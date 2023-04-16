# frozen_string_literal: true

require_relative 'presenters/html'

RSpec.configuration.after(:suite) do
  StackTrace::Integrations::Rspec.finish_tracing
end

RSpec.configuration.around(:each) do |example|
  StackTrace.trace { example.run }

  StackTrace::Integrations::Rspec.store_trace(StackTrace.current, example)
end

module StackTrace
  module Integrations
    module Rspec
      EXAMPLE_META_KEYS = %i[file_path line_number scoped_id description full_description].freeze

      class << self
        def finish_tracing
          html.save
        end

        def store_trace(trace, example)
          html.add(trace, **example.metadata.slice(*EXAMPLE_META_KEYS))
        end

        private

        def html
          @html ||= Presenters::HTML.new
        end
      end
    end
  end
end
