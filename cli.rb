require 'net/http'
require 'uri'
require 'nokogiri'
require 'open-uri'
require 'fssm'
require 'rkelly'

require './hax'
require './conductor'
require './nodes'

def watch(filename)
  FSSM.monitor(File.dirname(ARGV[0]),File.basename(ARGV[0])) do
  	update do |b,r|
  		File.open(File.join(b, r)) do |f|
  		  play f.read
		  end
  	end
  end
end

@parser = RKelly::Parser.new
def play(js)
  ast = @parser.parse js
  conductor = Conductor.new(ast.height)
  ast.orchestrate(0, conductor, {})
end


if ARGV[0].start_with? 'http'
  doc = Nokogiri::HTML(open(ARGV[0]))
  js = ""
	doc.css('script').each do |script|
		js << script.content
	end

  play js
  
else # Load a local file and save it into our symtax.js
	 # since we are confident that our users are loading javascript
	 # we do not pass it through nokogiri
	watch ARGV[0]
end



