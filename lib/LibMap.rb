require "ruby-graphviz"
require "graphviz"
require 'resolv'

class Map
  def initialize
    @map = GraphViz::new(
        "G",
        :rankdir => "LR",
        :style => "rounded",
        :splines => "ortho",
        :overlap => "scalexy",
        :compound => true,
        :sep => +1,
        :type => "strict digraph"
      )
  end

  def add_host(host)
    begin
      label = Resolv.getname(host.ips[0])
    rescue
      label = "host#{host.id}"
    end
    map_object = @map.add_graph("cluster#{host.id}",:label=>label)

    host.map_object = map_object
    self.add_service(host)
  end

  def add_service(host)
    host.services.services.each do |service|
      #FIXME move to config (host ips)
      #if service.port.to_i > 30000 then service.name="10.0.0.1" end
      map_object = host.map_object.add_nodes(
          service.name,
          :label=>service.name,
          :shape=>"record"
      )
      service.map_object = map_object
    end
  end

  def add_connection(src,dst)
    @map.add_edges(src.map_object,dst.map_object)
  end

  def save
    #FIXME move to config
    @map.output( :png => "../tmp/map.png" )
  end
end