module ScalabilityTest
  module Monitors
    class ScalabilityMonitor
      def initialize(browser = nil)
        @browser = browser
        @data = 0
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
    end
  end
end
