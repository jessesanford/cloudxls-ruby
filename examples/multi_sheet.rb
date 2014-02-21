# ruby examples/multi_sheet.rb

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
  sheets: {
    "Sheet1" => {
      data: {text: "Greeting,Greetee\nHello,World" },
      sheet: {cell: "C3" }
    },
    "Sheet2!D4" => {data: {text: "Greeting,Greetee\nHello,World" }},
    "Sheet3!B2" => {data: {file: File.new("./examples/data.csv") }},
  }
})


File.open("out-multi_sheet.xls", "wb") { |f| f.write resp }
puts "File saved"
