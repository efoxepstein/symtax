class Conductor
  
  def freq(octave, root, offset)
    (12*octave + root + offset).freq
  end
  
  def initialize(max_height)
    @q = []
    @max_height = max_height
  end
  
  def enqueue(name, notes, octave, root, total_duration, height)
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
      puts "Synthing #{name} @ #{start}"
      
      sleep(start - elapsed)
      elapsed = start
      
      Synth.new(name)
      # TODO: deal with note, duration pairs
      #       deal with rests
      #Synth.new(name, opts)
    end
  end
  
end
