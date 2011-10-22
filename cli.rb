require 'net/http'
require 'uri'
require 'nokogiri'
require 'open-uri'
# This is the file where javascript will be stored locally on our machine.
$outputFileName = "symtax.js"

class HttpTest
	def downloadWebPage(weburl)
		#http_response = Net::HTTP.get_response(URI.parse(weburl))
		
		outfile = File.new($outputFileName.to_s,"w")
		# Use Nokogiri library to write javascript into
		# our file
		# For now, we create a document, and just look for the script tags...
		doc = Nokogiri::HTML(open(weburl))
		doc.css('script').each do |script|
			outfile << script.content #http_response.body #if we use http_response.body we get everything!
			puts 
		end
		
		outfile.close() # Close our file because we're done
	end
end

if ARGV[0].match(/^http/) 
	# Load up a http page here
	puts "is an http url"
	test = HttpTest.new # Create a new instance of our class
						# to load our webpage in.
	test.downloadWebPage(ARGV[0].to_s)	
elsif ARGV[0].match(/^www/)	
	# Same code as above, but appends a http:// to the file
	# This saves us an error message...
	puts "is a www url"
	test = HttpTest.new
	test.downloadWebPage("http://"+ARGV[0].to_s)
else # Load a local file and save it into our symtax.js
	 # since we are confident that our users are loading javascript
	 # we do not pass it through nokogiri in our webpage class.
		inputFile = File.new(ARGV[0].to_s,"r")
			outfile = File.new($outputFileName.to_s,"w")
				inputFile.each{|i|
								outfile.write i
				}
			outfile.close()
		inputFile.close()
end

