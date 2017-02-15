#!/bin/env ruby
require '../lib/LibConnections'
require '../lib/LibMap'
require '../lib/LibHost'
require '../lib/LibService'

localhost = {
    :ips => ['127.0.0.1']
}

h = Hosts.new
c = Connections.new
map = Map.new()

h.add_host(Host.new(localhost))

c.prepare_hosts(h)

h.hosts.each do |host|
  map.add_host(host)
end

c.connections.each do |connection|
  src_host = h.get_host(connection.ip_src)
  dst_host = h.get_host(connection.ip_dst)

  src_service = src_host.get_service(connection.ip_src,connection.port_src)
  dst_service = dst_host.get_service(connection.ip_dst,connection.port_dst)

  map.add_connection(src_service,dst_service)
end

map.save