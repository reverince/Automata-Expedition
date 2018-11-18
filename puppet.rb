require_relative "item"

MANADE_PER_POINT = 10 # 마네이드 비용
BASE_HP = 100
MAX_HP = 1000
MIN_HP = 100
BASE_ATK = 0
MAX_ATK = 100
BASE_AMR = 0
MAX_AMR = 100
BASE_AGL = 0
MAX_AGL = 100
BASE_RET = 50
MAX_RET = 100
MIN_RET = 0
NORMAL, GUARDING, GAINING = 0, 1, 2

class Character
	attr_accessor :name, :form, :chp
	attr_reader :lvl, :hp, :atk, :amr, :agl, :ret
	
	def initialize(name, hp=BASE_HP, atk=BASE_ATK, amr=BASE_AMR, agl=BASE_AGL, ret=BASE_RET)
		@name = name
		@form = NORMAL
		@lvl = 0
		@exp = 0
		@chp = @hp = hp
		@atk = atk
		@amr = amr
		@agl = agl
		@ret = ret
	end
  
	def to_s
		@name
	end
  
	def info
		"[#{@lvl}]\t#{@name}\t[EXP #{@exp}] [HP #{@chp}/#{@hp}] [ATK #{@atk}] [AMR #{@amr}] [AGL #{@agl}] [RET #{@ret}]"
	end
	
	def form
		case @form
			when NORMAL
				"평상"
			when GUARDING
				"방어"
			when GAINING
				"준비"
		end
	end
	def alive?
		@chp > 0
	end
	def dead?
		@chp <= 0
	end
	
end

class Puppet < Character
	attr_reader :exp
	
	def initialize(name, hp=BASE_HP, atk=BASE_ATK, amr=BASE_AMR, agl=BASE_AGL, ret=BASE_RET)
		super(name, hp, atk, amr, agl, ret)
	end
  
	def status
		p_chp = (@chp * 10 / @hp).round
		"[#{@lvl}] #{@name}\t[#{form}]\t[HP " + "■" * p_chp + "□" * (10 - p_chp) + " #{@chp}/#{@hp}] [#{@atk}|#{@amr}|#{@agl}]"
	end
	
	def get_exp(amount)
		raise "[!] get_exp 파라미터가 #{amount}입니다." if amount < 0
		@exp += amount
		if @exp >= 100
			up = @exp / 100
			@lvl += up
			@exp %= 100
			while up > 0 do
				@hp = (1.1 * @hp).round
				@atk = (1.1 * @atk).round
				@amr = (1.1 * @amr).round
				@agl = (1.1 * @agl).round
				up -= 1
			end
			puts "* #{@name}의 레벨이 " + josa(@lvl, "로") + " 올랐어요!"
			sleep(1)
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
		"[#{puppets_level}]\t#{@name}\t[ #{puppets_level_name} ]"
	end
	
	# 인형
	
	def puppets_level # 인형 총합 레벨
		@puppets.map(&:lvl).reduce(:+) or 0
	end
  
	def puppets_level_name
		ret = ""
		@puppets.each do |puppet|
			ret += "[#{puppet.lvl}] #{puppet.name} / "
		end
		
		ret[0..-4]
	end
	
	# 전투
	
	def status
		ret = ""
		@puppets.each_with_index do |puppet, i|
			ret += "#{i.to_s}.\t" + puppet.status + "\n"
		end
		
		ret[0..-2]
	end
  
	def defeated? # lag??
		ret = false
		@puppets.each do |puppet|
			if puppet.dead?
				ret = true
				break
			end
		end
		
		ret
	end
	
end

# 적

class Enemy < Character
	
	def initialize(name, hp=BASE_HP, atk=BASE_ATK, amr=BASE_AMR, agl=BASE_AGL, ret=BASE_RET)
		super(name, hp, atk, amr, agl, ret)
		@lvl = [(hp - 100) / 100 + atk + amr + agl, 0].max
	end
  
	def status
		p_chp = (@chp * 10 / @hp).round
		"ENEMY\t[#{@lvl}] #{@name}\t[#{form}]\t[HP " + "■" * p_chp + "□" * (10 - p_chp) + " #{@chp}/#{@hp}]"
	end
	
end

class Spider < Enemy
  
	def initialize
		super("거미", hp=100, atk=20, amr=0, agl=10)
	end
  
end
