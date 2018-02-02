require_relative "item"

MANADE_PER_POINT = 10 # 마네이드 비용
BASE_HP = 100
MAX_HP = 1000
BASE_ATK = 10
MAX_ATK = 100
BASE_AMR = 0
MAX_AMR = 100
BASE_AGL = 0
MAX_AGL = 100
BASE_RET = 50
MIN_RET = 0
MAX_RET = 100

class Puppet
	attr_accessor :name, :lvl, :exp, :head, :body, :left_arm, :right_arm, :leg
	attr_reader :hp, :atk, :amr, :agl, :ret
	
	def initialize(name, hp=BASE_HP, atk=BASE_ATK, amr=BASE_AMR, agl=BASE_AGL, ret=BASE_RET)
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
	def info_part
		if @head && @body && @left_arm && @right_arm && @leg
			"ALL GREEN"
		else
			
		end
	end
	
end

class Expedition
	attr_accessor :name, :puppets
	
	def initialize(name, puppets=[])
		@name = name
		@puppets = []
	end
	def to_s
		@name
	end
	def info
		"[#{puppets_level}]\t#{@name}\t[[ #{puppets_level_name} ]]"
	end
	
	# 인형
	
	def puppets_level # 인형 총합 레벨
		@puppets.map(&:lvl).reduce(:+) or 0
	end
	def puppets_level_name
		res = ""
		@puppets.each do |puppet|
			res += "[#{puppet.level}]\t#{puppet.name} / "
		end
		res = res[0..-4]
		
		res
	end
	
end
