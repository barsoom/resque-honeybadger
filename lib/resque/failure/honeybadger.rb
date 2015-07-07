require "resque"
require "honeybadger"

module Resque
  module Failure
    class Honeybadger < Base
      def count
        # We don't want to ask Honeybadger for the total # of errors,
        # so we fake it by asking Resque instead.
        Stat[:failed]
      end

      def save
        notify_honeybadger
      end

      private

      def notify_honeybadger
        # Honeybadger.notify returns a String UUID reference to the notice within Honeybadger or false when ignored.
        # Read more: http://www.rubydoc.info/gems/honeybadger/Honeybadger#notify-instance_method
        ::Honeybadger.notify(
          exception,
          parameters: {
            payload_class: payload['class'].to_s,
            payload_args:  payload['args'].inspect,
          }
        )
      end
    end
  end
end
