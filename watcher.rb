require 'fssm'

start_time = Time.new
total_changes = 0
changes_per_minute = 0


# Search for changes within our current directory
FSSM.monitor('./') do
	# Someone changes or saves the file
	update do |b,r|
	  puts b + "\t" + r 
	end
	
end