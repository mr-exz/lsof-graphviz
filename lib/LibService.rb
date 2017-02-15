require "fosl/parser"


class Service
  attr_accessor :map_object,
                :name,
                :ip,
                :port

  def initialize(ip,port)
    @map_object = nil
    @name = "#{ip}:#{port}"
    @ip = ip
    @port = port
  end
end

class Services
  attr_accessor :services
  def initialize
    @services = []
  end

  def get_service(ip,port)
    @services.each do |service|
      if service.ip == ip and service.port == port
        return service
      end
    end
  end

  def add(ip,port)
    @services.push(Service.new(ip,port))
  end
end
