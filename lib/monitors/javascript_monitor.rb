module ScalabilityTest
  module Monitors
    class JavascriptMonitor < ScalabilityMonitor
      def create_data_script
        ''
      end

      def add_handlers_script
        ''
      end

      def start
        @browser.execute_script(create_data_script)
      end

      def setup
        @browser.execute_script(create_data_script)
        @browser.execute_script(add_handlers_script)
      end
    end
  end
end