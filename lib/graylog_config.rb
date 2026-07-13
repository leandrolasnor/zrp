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
    GELF::Notifier.new(host, port, 'WAN', protocol: gelf_protocol, facility: facility)
  end

  def gelf_protocol
    case protocol
    when :tcp then GELF::Protocol::TCP
    else           GELF::Protocol::UDP
    end
  end

  def build_logger
    logger = GELF::Logger.new(host, port, 'WAN', protocol: gelf_protocol, facility: facility)
    logger.level = {
      debug: GELF::DEBUG,
      info: GELF::INFO,
      warn: GELF::WARN,
      error: GELF::ERROR,
      fatal: GELF::FATAL
    }.fetch(level, GELF::INFO)
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
