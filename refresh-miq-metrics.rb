#!/opt/rh/rh-ruby23/root/usr/bin/ruby
#
## Load Rails
#
begin
  require 'config/environment'
rescue LoadError
  DIR = File.dirname(__FILE__)
  require DIR + '/config/environment'
end


ContainerNode.all.each { |n| n.perf_capture('realtime') }
ContainerGroup.all.each { |n| n.perf_capture('realtime') }
Container.all.each { |n| n.perf_capture('realtime') }

(0..72).each { |h| ContainerNode.all.each { |n| n.perf_rollup(h.hour.ago.utc.beginning_of_hour.iso8601, "hourly") } }
(0..10).each { |d| ContainerNode.all.each { |n| n.perf_rollup(d.days.ago.utc.beginning_of_day.iso8601, "daily", TimeProfile.first) } }
(0..72).each { |h| ManageIQ::Providers::ContainerManager.all.each { |n| n.perf_rollup(h.hour.ago.utc.beginning_of_hour.iso8601, "hourly") } }
(0..10).each { |d| ManageIQ::Providers::ContainerManager.all.each { |n| n.perf_rollup(d.days.ago.utc.beginning_of_day.iso8601, "daily", TimeProfile.first) } }
