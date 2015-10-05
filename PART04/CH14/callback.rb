#!/usr/bin/env ruby
require 'webrick'
require 'json'
require 'net/http'

MARATHON_SERVER = 'mesos1'
MARATHON_PORT = 8080
NGX_CONF_DIR = "/etc/nginx/conf.d"

def update_nginx_conf(event)
  generate_nginx_conf event["appID"]
  reload_nginx
end

def generate_nginx_conf(app)
  @erb ||= ERB.new(DATA.read)
  servers = fetch_app_servers app
  File.open("#{NGX_CONF_DIR}/#{app}.conf", 'w') do |f|
    f.puts @erb.result(binding)
  end
end

def fetch_app_servers(app)
  apps = JSON.parse(
    Net::HTTP.get(
      MARATHON_SERVER, "/v2/apps",
      MARATHON_PORT))
  unless apps["apps"].any? { |a| a["id"] == app }
    return []
  end
  app_info = JSON.parse(
    Net::HTTP.get(
      MARATHON_SERVER, "/v2/apps/#{app}/tasks",
      MARATHON_PORT))
  servers = app_info["tasks"].map do |t|
    t["host"] + ":" + t["ports"].first.to_s
  end
  return servers
end

def reload_nginx
  system '/etc/init.d/nginx reload'
end

def activate(app)
  File.open("#{NGX_CONF_DIR}/ii.conf", 'w') do |f|
    f.puts <<EOS
server {
    listen 80;
    server_name 'ii-production.example.com';
    location / {
        proxy_pass http://#{app};
    }
}
EOS
  end
  reload_nginx
end

server = WEBrick::HTTPServer.new(
  :BindAddress => '0.0.0.0',
  :Port => 18000,
)

server.mount_proc('/callback') do |req, res|
  event = JSON.parse req.body
  puts event
  if event["eventType"] == 'status_update_event'
    update_nginx_conf event
  end
end

server.mount_proc('/activate') do |req, res|
  app = req.query['app'] || ''
  if File.exists? "#{NGX_CONF_DIR}/#{app}.conf"
    activate app
  end
end

trap(:INT){server.shutdown}
server.start

__END__
<% unless servers.empty? %>
upstream <%= app %> {
<% servers.each do |server| %>
  server <%= server %>;
<% end %>
}
<% end %>
