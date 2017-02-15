require "fosl/parser"
require '../lib/LibHost'

class Connection
  attr_accessor :ip_src, :ip_dst, :port_dst, :port_src
  def initialize (ip_s,port_s,ip_d,port_d)
    @ip_src = ip_s
    @port_src = port_s
    @ip_dst = ip_d
    @port_dst = port_d
  end
end

class Connections
  attr_accessor :connections
  def initialize
    @parser = FOSL::Parser.new
    #FIXME move to config
    @data = @parser.lsof("-Pn -i TCP:1-65535")
    @connections = []
  end

  def prepare_hosts(hosts)
    @h = hosts
    self.prepare_connections

    @connections.each do |con|
      convert_to_host(con)
    end
  end

  def convert_to_host(con)
    if src_host = @h.get_host(con.ip_src)
      if !src_host.get_service(con.ip_src,con.port_src)
        src_host.add_service(con.ip_src,con.port_src)
      end
    else
      src_host = Host.new({:ips => [con.ip_src]})
      src_host.add_service(con.ip_src,con.port_src)
      @h.add_host(src_host)
    end

    if dst_host = @h.get_host(con.ip_dst)
      if !dst_host.get_service(con.ip_dst,con.port_dst)
        dst_host.add_service(con.ip_dst,con.port_dst)
      end
    else
      dst_host = Host.new({:ips => [con.ip_dst]})
      dst_host.add_service(con.ip_dst,con.port_dst)
      @h.add_host(dst_host)
    end
  end

  def prepare_connections
    raw_connections = []

    @data.each do |pid,process|
      process.files.each do |file|
        if file[:state] == "ESTABLISHED"
          raw_connections.push(file[:name])
        end
      end
    end

    raw_connections = raw_connections.uniq

    raw_connections.each do |conection|
      @connections.push(Connection.new(
          conection.split("->")[0].split(":")[0],
          conection.split("->")[0].split(":")[1],
          conection.split("->")[1].split(":")[0],
          conection.split("->")[1].split(":")[1]
      ))
    end
  end

end



