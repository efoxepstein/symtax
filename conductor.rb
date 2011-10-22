class Conductor
  
  def freq(octave, root, offset)
    (12*octave + root + offset).freq
  end
  
  def amp(height)
    [(Math.log(1.1-height/@max_height)+4)/4, 1].min
  end
  
  def initialize(max_height)
    @q = []
    @max_height = max_height.to_f
  end
  
  def enqueue(name, notes, octave, root, total_duration, delay, height)
    sleep_time = 0
    elapsed = 0
    notes.cycle do |(offset, duration)|
      break if elapsed + duration > total_duration
      
      unless offset == nil
        @q << [elapsed+delay, name, { freq: freq(octave, root, offset), 
                                      dur:  duration,
                                      amp:  amp(height)}]
      end
      
      elapsed += duration
    end
  end
  
  def commit 
    elapsed = 0
    for (start, name, opts) in @q.sort_by {|x| x[0]}
      puts "Synthing #{name} @ #{start} / #{opts}"
      
      sleep(start - elapsed)
      elapsed = start
      
      Synth.new(name, opts)
    end
  end
  
end
