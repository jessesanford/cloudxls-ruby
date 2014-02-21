# Installation

    gem install cloudxls

Or in your Gemfile

    gem 'cloudxls', '~> 0.7.0'

To get started, add the following to your PHP script:

# Useage

There are various sample code snippets in the examples folder.

## Async

```ruby
CloudXLS.api_key = "YOUR-API-KEY"

response = CloudXLS.async({
  :data => {
    :text => "Greeting,Greetee\nHello,World"
  }
})

redirect_to response.url
```

## Inline

```ruby
CloudXLS.api_key = "YOUR-API-KEY"

response = CloudXLS.inline(:data => {
  :text => "Greeting,Greetee\nHello,World"
})

File.open("report.xls", 'wb') {|f| f << response }
```
