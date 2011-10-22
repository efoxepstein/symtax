class Conductor
  
  def freq(octave, root, offset)
    (12*octave + root + offset).freq
  end
  
  def amp(height)
    [(Math.log(1.1-height/@max_height)+4)/4, 1].min
  end
  
  def initialize(max_height, tempo=2.0)
    @fibers = []
    @max_height = max_height.to_f
    @tempo = tempo
  end
  
  def enqueue(name, notes, octave, root, total_duration, delay, height)    
    @fibers << Fiber.new do
      sleep_time = 0
      elapsed = 0
      notes.cycle do |(offset, duration)|
        break if elapsed + duration > total_duration
      
        unless offset == nil
          d = [(elapsed+delay)/@tempo, name, { freq: freq(octave, root, offset), 
                                               dur:  duration / @tempo,
                                               amp:  amp(height)}]
          Fiber.yield d
        end
      
        elapsed += duration
      end
    end
  end
  
  def commit 
    
    elapsed = 0
    backlog = [1]
    until backlog.empty?
      backlog = []
      
      @fibers.select! &:alive?
      unless @fibers.empty?
      
        for fiber in @fibers
          n = fiber.resume 
          backlog << n unless n.nil?
        end
      
        unless backlog.empty?
          max = backlog.max[0]
      
          for fiber in @fibers
            while fiber.alive?
              n = fiber.resume
              backlog << n
              break if n[0] > max
            end
          end
      
          backlog.sort_by! {|x|x[0]}
          puts backlog.inspect
          for (start, name, opts) in backlog
            sleep(start - elapsed + 0.00001)
            elapsed = start
            Synth.new(name, opts)
          end
        end
      end
    end
  end
  
end
