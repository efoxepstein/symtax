require 'fssm'

start_time = Time.new
total_changes = 0
changes_per_minute = 0


# Search for changes within our current directory
FSSM.monitor(File.dirname(ARGV[0]),File.basename(ARGV[0])) do
	# Someone changes or saves the file
	update do |b,r|
		total_changes = total_changes + 1
		puts "Change in file '#{r}' into '#{b}'"
		puts "Changes per minute"
		time_now = Time.now
		puts (((time_now - start_time)%60)/total_changes).to_s
		
	end
	
end