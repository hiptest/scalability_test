module ScalabilityTest
  module Monitors
    class IndexMonitor < ScalabilityMonitor
      def start
        @data += 1
      end

      def results
        {
          :values => [{
            :v => @data,
            :title => 'index'
          }]
        }
      end
    end
  end
end
