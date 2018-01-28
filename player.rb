require_relative "puppet"

class Player
	attr_accessor :name, :puppets, :items, :silver, :manade
	
	def initialize(name)
		@name = name
		@puppets = []
		@items = []
		@silver = 100
		@manade = 100
	end
	def to_s
		@name
	end
	def info
		"[#{puppet_level}]\t#{@name}\t인형 #{@puppets.size}개 | 은화 #{@silver}sv | 마네이드 #{@manade}ml"
	end
	
	def puppet_level
		@puppets.map(&:lvl).reduce(:+)
	end
	
end
