module ScalabilityTest
  module Monitors
    class EmberRenderingTimeMonitor < JavascriptMonitor
      def self.key
        :emberjs_render
      end

      def create_data_script
        "emberjsScalabilityStats = [];"
      end

      def add_handlers_script
        %Q|
          emberjsScalabilityStats = [];
          navigationStart = performance.timing.navigationStart;

          Ember.subscribe("render", {
            before: function(name, start, payload) {
              return start;
            },

            after: function(name, end, payload, start) {
              if (payload.template) {
                emberjsScalabilityStats.push({
                  start: start + navigationStart,
                  end: end + navigationStart,
                  key: "ember.render.template",
                  title: payload.template
                });
              }
            }
          });|
      end

      def results
        events = JSON.parse(@browser.execute_script "return JSON.stringify(emberjsScalabilityStats);")
        {
          :values => [{
            :v => duration(events),
            :title => 'Ember rendering time'
          }],
          :events => events
        }
      end
    end
  end
end
