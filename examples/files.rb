# ruby examples/files.rb

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
  data:  { file: File.new("./examples/data.csv") }
})

File.open("out-file.xls", "wb") { |f| f.write resp }