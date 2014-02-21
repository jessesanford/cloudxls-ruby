# ruby examples/inline.rb
#
# Use to directly download file.

require_relative '../lib/cloudxls'

unless ENV["CLOUDXLS_API_KEY"]
  puts "--- WARNING ---"
  puts "Please add environment variable CLOUDXLS_API_KEY"
  puts "export CLOUDXLS_API_KEY=YOUR_API_KEY"
  puts "---------------"
  exit
end

CloudXLS.api_key = ENV["CLOUDXLS_API_KEY"];

resp = CloudXLS.inline({
  data:  { text: "Greeting,Greetee\nHello,World" },
  sheet: { name: 'Hello World' },
  doc:   { filename: 'hello-world' }
})


File.open("out.xls", "wb") { |f| f.write resp }
puts "File saved"
