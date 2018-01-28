class Item
	attr_reader :name, :desc, :value
	
	def initialize(name, desc="", value=nil)
		@name = name
		@desc = desc
		@value = value
	end
	def to_s
		@name
	end
	def info
		"#{@name} : #{@desc} [#{@value}sv]"
	end
	
end

@doll = Item.new("인형 소체", "마네이드를 주입할 일반적인 인형입니다.", 10)
class Doll < Item
	def initialize
		super("인형 소체", "마네이드를 주입할 일반적인 인형입니다.", 10)
	end
end

class Weapon < Item
	attr_reader :part
	
	def initialize(name, desc, value, part)
		super(name, desc, value)
		@part = part
	end
	
end
