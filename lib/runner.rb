require 'fileutils'

require 'monitors/*'

module ScalabilityTest
  class Runner
    def initialize(browser, monitored = nil)
      @frames = []
      monitored ||= [:sql, :render, :total]

      ::Monitors.constants
      monitors_mapping = {
        :ajax => AjaxCallsMonitor,
        :sql => SqlTimeMonitor,
        :parsing => ParsingTimeMonitor,
        :render => EmberRenderingTimeMonitor,
        :total => TotalTimeMonitor,
        :memory => MemoryUsageMonitor
      }

      @monitors = [IndexMonitor.new]
      @monitors += monitors_mapping.values_at(*monitored).compact.map {|m| m.new(browser)}
    end

    def add_monitor(monitor)
      @monitors << monitor
    end

    def perf_data
      titles = @frames.first.flat_map {|results| results[:values].map {|v| v[:title]} }
      rows = @frames.collect do |frame|
        frame.flat_map {|results| results[:values].map {|v| v[:v]} }
      end
      {
        :titles => titles,
        :rows => rows,
        :frames => @frames
      }
    end

    def export_dir
      now = Time.now
      "tmp/perfs/#{now.year}-#{now.month}-#{now.day}"
    end

    def save_stats(title)
      dir = export_dir
      FileUtils.mkdir_p(dir)
      File.open("#{dir}/#{title}.json", 'w') { |file| file.write(perf_data.to_json)}
    end

    def run count, &test_block
      @monitors.each(&:setup)
      count.times do |i|
        @monitors.each(&:start)
        test_block.call(i)
        @monitors.each(&:stop)
        frame = @monitors.map(&:results)
        @frames << frame
      end
      @monitors.each(&:teardown)
    end
  end
end

