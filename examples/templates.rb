# ruby examples/templates.rb
#
# Merge data into excel files.

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
  doc:   { template: File.new("./examples/template.xls") }
})


File.open("out-template.xls", "wb") { |f| f.write resp }
puts "File saved: ./out-template.xls"

resp = CloudXLS.inline({
  data:  { text: "Greeting,Greetee\nHello,World" },
  sheet: { name: 'Hello World' },
  doc:   { template: File.new("./examples/template.xlsx") }
})

File.open("out-template.xlsx", "wb") { |f| f.write resp }
puts "File saved: ./out-template.xlsx"
