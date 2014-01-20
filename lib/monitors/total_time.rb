module ScalabilityTest
  module Monitors
    class TotalTimeMonitor < ScalabilityMonitor
      def self.key
        :total
      end

      def setup
        @index = 0
      end

      def start
        @index += 1
        @start = Time.now.to_ms
      end

      def stop
        @stop = Time.now.to_ms
        @total_time = (@stop - @start).round(3)
      end

      def results
        {
          :values => [{
            :v => @total_time,
            :title => "Total time frame #{@index}"
          }],
          :events => [{
            'start' => @start,
            'end' => @stop,
            'key' => 'total.time',
            'title' => "Total time frame #{@index}",
          }]
        }
      end
    end
  end
end