module ScalabilityTest
  module Monitors
    class AjaxCallsMonitor < ScalabilityMonitor
      def self.key
        :ajax
      end

      def setup
        @browser.execute_script(%Q#
          $(document).ajaxStart(function() {
            ajaxStartTime = +new Date();
          });

          $(document).ajaxStop(function() {
            var event = {
              start: ajaxStartTime,
              end: +new Date(),
              key: "ajax.time",
              title: "Ajax time"
            };
            ajaxPerfs.events.push(event);
          });

          $(document).ajaxSend(function(event, jqXHR, ajaxOptions) {
            var url = ajaxOptions.url;
            ajaxPerfs.calls[url] = ajaxPerfs.calls[url] || {};
            ajaxPerfs.calls[url].start = event.timeStamp;
          });

          $(document).ajaxComplete(function(event, jqXHR, ajaxOptions) {
            var url = ajaxOptions.url;
            ajaxPerfs.calls[url].end = event.timeStamp;
            var event = {
              start: ajaxPerfs.calls[url].start,
              end: ajaxPerfs.calls[url].end,
              key: "ajax.call",
              title: "Ajax call to " + url
            };
            ajaxPerfs.events.push(event);
          });
        #)
      end

      def start
        @browser.execute_script(%Q#
          ajaxPerfs = {
            'calls': {},
            'events': [],
            'durations': []
          };
          ajaxStartTime = null;
        #)
      end

      def results
        ajax_perfs = JSON.parse(@browser.execute_script "return JSON.stringify(ajaxPerfs);")
        events = ajax_perfs["events"]
        {
          :values => [{
            :v => duration(events.select {|e| e['key'] == 'ajax.time'}),
            :title => 'Ajax total duration'
          }, {
            :v => duration(events.select {|e| e['key'] == 'ajax.call'}),
            :title => 'Ajax total requests time'
          }],
          :events => events
        }
      end
    end
  end
end