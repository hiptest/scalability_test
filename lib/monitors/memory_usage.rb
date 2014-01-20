module ScalabilityTest
  module Monitors
    class MemoryUsageMonitor < ScalabilityMonitor
      def self.key
        :memory
      end

      def results
        memory = `pmap #{Process.pid} | tail -1`[10,40].strip
        {
          :values => [{
            :v => memory,
            :title => 'memory'
          }]
        }
      end
    end
  end
end