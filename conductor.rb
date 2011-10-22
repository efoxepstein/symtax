class Conductor
  
  def freq(octave, root, offset)
    (12*octave + root + offset).freq
  end
  
  def amp(height)
    [(Math.log(1.1-height/@max_height)+4)/4, 1].min
  end
  
  def initialize(max_height, tempo=2.0)
    @q = []
    @max_height = max_height.to_f
    @tempo = tempo
  end
  
  def enqueue(name, notes, octave, root, total_duration, delay, height)
    sleep_time = 0
    elapsed = 0
    notes.cycle do |(offset, duration)|
      puts [duration, elapsed, total_duration].join("\t")
      break if elapsed + duration > total_duration
      
      unless offset == nil
        @q << [(elapsed+delay)/@tempo, name, { freq: freq(octave, root, offset), 
                                      dur:  duration / @tempo,
                                      amp:  amp(height)}]
      end
      
      elapsed += duration
    end
  end
  
  def commit 
    elapsed = 0
    for (start, name, opts) in @q.sort_by {|x| x[0]}
      #puts "Synthing #{name} @ #{start} / #{opts}"
      
      sleep(start - elapsed)
      elapsed = start
      
      Synth.new(name, opts)
    end
  end
  
end
