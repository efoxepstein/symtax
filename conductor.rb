class Conductor
  
  def freq(octave, root, offset)
    (12*octave + root + offset).freq
  end
  
  def initialize
    @q = []
  end
  
  def enqueue(name, notes, octave, root, total_duration)
      sleep_time = 0
      elapsed = 0
      notes.cycle do |(offset, duration)|
        break if elapsed + duration > total_duration

        @q << [elapsed, name, {freq: freq(octave, root, offset), dur: duration}]
          
        elapsed += duration
      end
  end
  
  def commit 
    elapsed = 0
    for (start, name, opts) in @q.sort_by(&:first)
      sleep(start - elapsed)
      elapsed = start
      Synth.new(name, opts)
    end
  end
  
end
