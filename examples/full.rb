# ruby examples/full.rb
#
# With all the options

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
      data: {
        text: "Greeting;Greetee;Date\nHello;World;2011-01-02",
        separator: ";",
        date_format: "YYYY-MM-DD", # is default
        encoding: "UTF-8", # is default
      },
      sheet: {
        cell: "C3",    # define cell
        filters: true, # adds filter boxes
        auto_size_columns: true, # adjust column width (experimental)
        cell_formats: "@,@,dd-mmm-yyyy"
      }
    },
    "Sheet3!B2" => {data: {file: File.new("./examples/data.csv") }},
  },
  doc: {
    filename: "output",
    template: File.new("./examples/template.xls")
  }
})

File.open("out-full.xls", "wb") { |f| f.write resp }
puts "File saved: ./out-full.xls"
