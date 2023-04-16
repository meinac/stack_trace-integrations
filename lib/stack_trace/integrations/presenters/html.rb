# frozen_string_literal: true

require "stack_trace/viz"
require "pathname"
require "securerandom"

module StackTrace
  module Integrations
    module Presenters
      class HTML
        FINAL_MESSAGE = <<~TEXT
          \e[1m
          StackTrace:

          Trace information is saved into \e[32m%<file_path>s\e[0m
          \e[22m
        TEXT

        def add(trace, **options)
          html.add(trace, **options)
        end

        def save
          ensure_path_is_created!

          html.save(file_path)
              .then { |path| print_message(path) }
        end

        private

        def html
          @html ||= StackTrace::Viz::HTML.new
        end

        def ensure_path_is_created!
          Dir.mkdir(file_dir) unless File.directory?(file_dir)
        end

        def print_message(path)
          puts format(FINAL_MESSAGE, file_path: path)
        end

        def file_path
          file_dir.join("#{SecureRandom.uuid}.html")
        end

        def file_dir
          Pathname.new(Dir.pwd).join("stack_trace")
        end
      end
    end
  end
end
