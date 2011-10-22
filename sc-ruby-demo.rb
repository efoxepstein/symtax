require 'scruby'



s = Server.new
s.boot


s = Synth.new :fm, :freq => 220, :amp => 0.4, :dur => 1
Synth.after s, :fm, :freq => 440, :amp => 0.5, :dur => 1, :delay => 2

sleep 5

# instrument
# notes, durations

