# frozen_string_literal: true

if defined?(GELF)
  module GELF
    class Logger
      def tagged(*tags)
        if tags.flatten.any?
          @tags = (@tags || []) + tags.flatten
        end
        yield self
      ensure
        tags.flatten.each { |t| @tags&.delete(t) } if tags.flatten.any?
      end

      def add_tags(*tags)
        @tags ||= []
        @tags.concat(tags.flatten)
      end

      def clear_tags!
        @tags = []
      end

      private

      def notify_with_tags(severity, message, options = {})
        options[:_tags] = @tags.dup if @tags&.any?
        notify_without_tags(severity, message, options)
      end
      alias notify_without_tags notify
      alias notify notify_with_tags
    end
  end
end
