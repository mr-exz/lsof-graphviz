require 'socket'

class Host
  attr_accessor :map_object,
                :name,
                :ips,
                :ports,
                :services,
                :id


  def initialize (args)
    @map_object = nil
    @id = nil
    @name = args[:name] || @id
    @ips = args[:ips]
    @ports = args[:ports] || []
    @services = Services.new
  end

  def get_service(ip,port)
    if ports.include?(port)
      return services.get_service(ip, port)
    else
      return false
    end
  end

  def add_service(ip,port)
      @ports.push(port)
      @services.add(ip,port)
  end
end

class Hosts
  attr_accessor :hosts, :last_id
  def initialize
    @hosts = []
    @last_id = 0
  end

  def add_host(host)
    host.id = @last_id
    @last_id+=1
    @hosts.push(host)
  end

  def get_host(ip)

    @hosts.each do |host|
      if host.ips.include?(ip)
        return host
      end
    end

    return false
  end

end