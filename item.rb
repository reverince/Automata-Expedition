class Item
	attr_reader :name, :desc
	
	def initialize(name, desc="", value=nil)
		@name = name
		@desc = desc
	end
	
end

class Weapon < Item
	attr_reader :part
	
	def initialize(name, desc, value, part)
		super(name, desc, value)
		@part = part
	end
	
end
