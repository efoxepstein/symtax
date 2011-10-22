require 'net/http'
require 'uri'


class HttpTest
	def downloadWebPage(weburl)
		http_response = Net::HTTP.get_response(URI.parse(weburl))
		puts http_response.body
	end
end

if ARGV[0].match(/^http/) 
	
	puts "is an http url"
	test = HttpTest.new
	test.downloadWebPage(ARGV[0].to_s)	
	# url = URL.parse('http://www.google.com/index.html')
	# res = Net::HTTP.start(url.host,url.port){|http|
	# http.get('/index.html')
	# }
elsif ARGV[0].match(/^www/)
	puts "is a www url"
	test = HttpTest.new
	test.downloadWebPage("http://"+ARGV[0].to_s)
else
	puts "not a url"
end

