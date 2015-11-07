
class Router

	attr_accessor :name
	attr_accessor :ports
	attr_accessor :arp_table
	attr_accessor :neighbors
	attr_accessor :router_table

	def to_s
		"#{name},#{ports.size},#{ports.join ','}"
	end

	def initialize
		@arp_table = Hash.new
		@neighbors = Array.new
	end

	# Messages abstraction

	def send_message ip_origin, ip_dest, ttl
		# find next hop
		if has_network ip_dest
			port = find_port_by_net ip_dest
			next_ip = ip_dest
		else
			# find next hop some other way
			# port = ?
			# next_ip = ?
		end

		# check arp table
		if !arp_table.has_key?(next_ip)
			puts "é nos"
			# send_arp_request destination
		end

	end

	# ARP

	def receive_arp_request origin, ip_dest
		if has_ip ip_dest
			port = get_port ip_dest
			send_arp_reply port, origin
		end
	end

	def send_arp_reply port, origin
		puts "ARP_REPLY|#{port.mac},#{origin.mac}|#{port.ip},#{origin.ip}"
		origin.receive_arp_reply port
	end

	# ICMP

	def send_icmp_request ip_origin, ip_final, mac_next, ttl
	end

	def receive_icmp_request ip_origin, ip_final, ttl
		# not considering ttl == 0 for now
		send_message ip_origin, ip_final, ttl
	end

	# Auxiliar Functions

	def has_mac mac
		ports.each do |port|
			if port.mac == mac
				return true
			end
		end
		return false
	end

	def has_ip ip
		ports.each do |port|
			if port.ip == ip
				return true
			end
		end
		return false
	end

	def get_port ip
		ports.each do |port|
			if port.ip == ip
				return port
			end
		end
		return nil
	end

	def has_network ip_dest
		ports.each do |port|
			port_net = addr_to_network port.ip, port.prefix
			ip_net = addr_to_network ip_dest, port.prefix
			if port_net == ip_net
				return true
			end
		end
		return false
	end

	def find_port_by_net ip_dest
		ports.each do |port|
			port_net = addr_to_network port.ip, port.prefix
			ip_net = addr_to_network ip_dest, port.prefix
			if port_net == ip_net
				return port
			end
		end
		return nil
	end

end
