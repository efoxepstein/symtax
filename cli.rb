require 'net/http'
require 'uri'
require 'nokogiri'
require 'open-uri'
require 'fssm'
require 'rkelly'
require 'scruby'
require 'fiber'

require './hax'
require './conductor'
require './nodes'

def watch(filename)
  File.open(ARGV[0]) do |f|
	  play f.read
  end
  
  FSSM.monitor(File.dirname(ARGV[0]),File.basename(ARGV[0])) do
  	update do |b,r|
  		File.open(File.join(b, r)) do |f|
  		  play f.read
		  end
  	end
  end
end

@parser = RKelly::Parser.new
Server.new port: 57110 # pray that the server is running and synthdefs loaded

def play(js)
  ast = @parser.parse js
  conductor = Conductor.new(ast.height)
  ast.orchestrate(0, conductor, {})
  
  conductor.commit
end


if ARGV.size == 0
  play STDIN.read
elsif ARGV[0].start_with? 'http'
  
  js = ""
  if ARGV[0].end_with? 'js'  
	  js = open(ARGV[0]).read
	else
	  doc = Nokogiri::HTML(open(ARGV[0]))
    js = ""
  	doc.css('script').each do |script|
  		js << script.content
  	end
	end

  play js
    
else # Load a local file and save it into our symtax.js
	 # since we are confident that our users are loading javascript
	 # we do not pass it through nokogiri
	watch ARGV[0]
end



