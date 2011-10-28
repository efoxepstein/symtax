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

@worker = nil

Server.new port: 57110 # pray that the server is running and synthdefs loaded

def watch(filename)
  File.open(ARGV[0]) do |f|
	  play f.read
  end
  
  FSSM.monitor(File.dirname(ARGV[0]),File.basename(ARGV[0])) do |m|
  	m.update do |b,r|
  		File.open(File.join(b, r)) do |f|
		    play f.read
		  end
  	end
  end
end

def play(js)
  ast = RKelly::Parser.new.parse js

  conductor = Conductor.new(ast.height)
  ast.orchestrate(0, conductor, {})
  
  @worker.terminate unless @worker.nil?
  @worker = Thread.start do
    conductor.commit
  end
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
    
else
	watch ARGV[0]
end



