require_relative "item"

HD, BD, LA, RA, LG = 0, 1, 2, 3, 4

class Puppet
	attr_accessor :name, :lvl, :exp, :hp, :atk, :amr, :agl, :ret, :head, :body, :left_arm, :right_arm, :leg
	
	def initialize(name, hp=100, atk=10, amr=0, agl=0, ret=50)
		@name = name
		@lvl = 0
		@exp = 0
		@hp = hp
		@atk = atk
		@amr = amr
		@agl = agl
		@ret = ret
		@head = @body = @left_arm = @right_arm = @leg = true
	end
	def to_s
		@name
	end
	def info
		"[#{@lvl}]\t#{@name}\t[EXP #{@exp}] [HP #{@hp}] [ATK #{@atk}] [AMR #{@amr}] [AGL #{@agl}] [RET #{@ret}]"
	end
	
	def broken(part)
		case part
			when HD
				@head = false
			when BD
				@body = false
			when LA
				@left_arm = false
			when RA
				@right_arm = false
			when LG
				@leg = false
		end
	end
	
end

class Expedition
	attr_accessor :name, :puppets
	
	def initialize(name)
		@name = name
		@puppets = []
	end
	
end
