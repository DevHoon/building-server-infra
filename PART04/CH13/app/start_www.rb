#! /usr/bin/env ruby
require 'docker'

app = ['localhost', 'localhost']
image = ARGV.shift

puts <<END
defaults
  contimeout 5000
  clitimeout 50000
  srvtimeout 50000

listen www
  bind 0.0.0.0:80
  mode http
END

count = 0
app.each do |s|
  Docker.url = "http://#{s}:4243"
  container = Docker::Container.create('Image' => image)
  container.start('PortBindings' => {'4567/tcp' => [{}]})

  container.json["NetworkSettings"]["Ports"].each_value do |v|
    port = v[0]["HostPort"]
    puts "  server srv#{count+=1} #{s}:#{port}"
  end
end

