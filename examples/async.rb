# ruby examples/async.rb
#
# Use this in a Rails/Sinatra action to redirect user
# directly to the file download (expires after 10min).

require_relative '../lib/cloudxls'

unless ENV["CLOUDXLS_API_KEY"]
  puts "--- WARNING ---"
  puts "Please add environment variable CLOUDXLS_API_KEY"
  puts "export CLOUDXLS_API_KEY=YOUR_API_KEY"
  puts "---------------"
  exit
end

CloudXLS.api_key = ENV["CLOUDXLS_API_KEY"];

resp = CloudXLS.async({
  data:  { text: "Greeting,Greetee\nHello,World" },
  sheet: { name: 'Hello World' },
  doc:   { filename: 'hello-world' }
})

puts "Download file from: #{resp.url}"