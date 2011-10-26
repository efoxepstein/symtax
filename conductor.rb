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
        
    until @enumerators.empty?      
      @enumerators.select! {|_, enum| not enum.finished? }
      
      next_enum = @enumerators.min_by do |_, enum|
        enum.peek[0]
      end
      
      if next_enum.nil? # this really shouldn't happen!
        puts "DONE"
        break
      end
      
      sleep next_enum[1].peek[0] - elapsed
      elapsed = next_enum[1].peek[0]
      
      puts "Time: #{elapsed}"

      notes = @enumerators.inject([]) do |ns, (_, e)|
        while !e.finished? and e.peek[0] == elapsed
          ns << e.next
        end
        ns
      end
            
           
      for (start, name, opts) in notes
        puts "Synthing #{name}, #{opts.inspect}"
        Synth.new(name, opts)
      end
    end
  end
  
  # def commit 
  #   elapsed = 0
  #   backlog = [1]
  #       
  #   until backlog.empty?
  #     backlog = []
  #     puts "A"
  #     @fibers.select! &:alive?
  #     unless @fibers.empty?
  #     
  #       for fiber in @fibers
  #         n = fiber.resume 
  #         puts "fiber output: #{n.inspect}"
  #         backlog << n unless n.nil?
  #       end
  #       puts "B"
  #       unless backlog.empty?
  #         max = backlog.max[0]
  #     
  #         for fiber in @fibers
  #           while fiber.alive?
  #             n = fiber.resume
  #             unless n.nil?
  #               backlog << n
  #               break if n[0] > max
  #             end
  #           end
  #         end
  #         puts "C"
  #         backlog.sort_by! {|x|x[0]}
  #         for (start, name, opts) in backlog
  #           sleep(start - elapsed + 0.00001)
  #           elapsed = start
  #           Synth.new(name, opts)
  #         end
  #       end
  #     end
  #   end
  #   puts "DONE"
  # end
  
end
