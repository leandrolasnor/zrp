# frozen_string_literal: true

# Graylog (GELF) logging configuration
# Uses the GELF gem to send logs to a Graylog server via UDP or TCP.
#
# Required environment variables:
#   GRAYLOG_HOST        - Graylog server hostname or IP (default: localhost)
#   GRAYLOG_PORT        - Graylog server port (default: 12201)
#   GRAYLOG_PROTOCOL    - Transport protocol: 'udp' or 'tcp' (default: udp)
#   GRAYLOG_ENABLED     - Set to 'true' to enable Graylog logging (default: false)
#   GRAYLOG_FACILITY    - Facility name for log source identification (default: Rails app name)
#   GRAYLOG_LEVEL       - Minimum log level to send to Graylog (default: info)

module GraylogConfig
  module_function

  def enabled?
    ENV.fetch('GRAYLOG_ENABLED', 'false') == 'true'
  end

  def host
    ENV.fetch('GRAYLOG_HOST', 'localhost')
  end

  def port
    ENV.fetch('GRAYLOG_PORT', '12201').to_i
  end

  def protocol
    ENV.fetch('GRAYLOG_PROTOCOL', 'udp').to_sym
  end

  def facility
    ENV.fetch('GRAYLOG_FACILITY', Rails.application.class.module_parent_name || 'rails_app')
  end

  def level
    ENV.fetch('GRAYLOG_LEVEL', 'info').downcase.to_sym
  end

  def build_notifier
    GELF::Notifier.new(host, port, protocol, facility: facility)
  end

  def build_logger
    notifier = build_notifier
    notifier.level = GELF::Logger::INFO if level == :info
    notifier.level = GELF::Logger::DEBUG if level == :debug
    notifier.level = GELF::Logger::WARN if level == :warn
    notifier.level = GELF::Logger::ERROR if level == :error
    notifier.level = GELF::Logger::FATAL if level == :fatal

    logger = GELF::Logger.new(notifier)
    logger.formatter = graylog_formatter
    logger
  end

  def graylog_formatter
    @graylog_formatter ||= proc do |severity, datetime, _progname, msg|
      {
        timestamp: datetime.iso8601(3),
        level: severity,
        facility: facility,
        message: msg.is_a?(String) ? msg : msg.inspect,
        environment: Rails.env,
        hostname: Socket.gethostname
      }
    end
  end
end

# Monkey-patch GELF::Logger to support tagged logging
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
