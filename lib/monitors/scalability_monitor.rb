module ScalabilityTest
  module Monitors
    class ScalabilityMonitor
      def initialize(browser = nil)
        @browser = browser
        @data = 0
      end

      def self.key
        raise NotImplementedError
      end

      def setup
      end

      def teardown
      end

      def start
        @data = 0
      end

      def stop
      end

      def results
      end

      private

      def duration(events)
        events.inject(0) {|d, event| d += event['end'] - event['start'] }.round(3)
      end
    end
  end
end
