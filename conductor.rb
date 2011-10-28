class Enumerator
  def finished?
    !peek
  rescue StopIteration
    true
  end
end


require 'awesome_print'

class Conductor
  
  def freq(octave, root, offset)
    (12*octave + root + offset).freq
  end
  
  def amp(height)
    [(Math.log(1.1-height/@max_height)+4)/4, 1].min
  end
  
  def initialize(max_height, tempo=2.0)
    @enumerators = []
    @max_height  = max_height.to_f
    @tempo       = tempo.to_f
  end
  
  def enqueue(name, notes, octave, root, total_duration, delay, height)    
    puts "enqueuing #{name}, #{delay}, #{height}, #{@max_height}"
    
    enumerator = Enumerator.new do |yielder|
      sleep_time = 0
      elapsed = 0
      notes.cycle do |(offset, duration)|
        break if elapsed + duration > total_duration
      
        unless offset == nil
          d = [(elapsed+delay)/@tempo, name, { freq: freq(octave, root, offset), 
                                               dur:  duration / @tempo,
                                               amp:  amp(height)}]
          yielder.yield d
        end
      
        elapsed += duration
      end
    end
    
    @enumerators << [delay..delay+total_duration, enumerator]
    
  end
  
  
  def self.fits?(end_time, arr)
    end_time >= arr[0]+arr[2][:dur]
  end
  
  def commit
    elapsed = 0
        
    until @enumerators.delete_if {|_, enum| enum.finished? }.empty?
      
      # Find the next note to play
      next_enum = @enumerators.min_by do |_, enum|
        enum.peek[0]
      end
      
      # This shouldn't happen
      if next_enum.nil?
        puts "DONE"
        break
      end
      
      # Sleep until next note
      sleep next_enum[1].peek[0] - elapsed
      elapsed = next_enum[1].peek[0]
      
      puts "Time: #{elapsed}"

      # Get all notes that play at this time
      notes = @enumerators.inject([]) do |ns, (_, e)|
        while !e.finished? and e.peek[0] == elapsed
          ns << e.next
        end
        ns
      end
            
       
      # Play em    
      for (start, name, opts) in notes
        puts "Synthing #{name}, #{opts.inspect}"
        Synth.new(name, opts)
      end
    end
  end
    
end
