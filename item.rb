class Item
	attr_reader :name, :desc, :weight, :value
	
	def initialize(name, desc, weight, value=nil)
		@name = name
		@desc = desc
    @weight = weight
		@value = value
	end
	def to_s
		@name
	end
	def info
		"#{@name} : #{@desc} [#{@weight}g] [#{@value}sv]"
	end
	
end


class Doll < Item
  attr_reader :atk, :amr, :agl, :ret
  
  def initialize(name, desc, weight, value, atk, amr, agl, ret=50)
    super(name, desc, weight, value)
    @atk = atk
    @amr = amr
    @agl = agl
    @ret = ret
  end
  
end

@dolls = []
@dolls << @doll_proto = Doll.new("인형 소체 프로토", "마네이드를 주입할 일반적인 인형.", 50, 10, 10, 0, 0)
@dolls << @doll_alpha = Doll.new("인형 소체 알파", "공격 성능이 향상된 인형.", 50, 20, 20, 0, 0)
@dolls << @doll_beta = Doll.new("인형 소체 베타", "방어 성능이 향상된 인형.", 50, 20, 10, 5, 0)

class Equipment < Item
	attr_reader :part, :atk, :amr, :agl, :ret
	
	def initialize(name, desc, weight, value, part, atk: 0, amr: 0, agl: 0, ret: 0)
		super(name, desc, weight, value)
		@part = part
    @atk = atk
    @amr = amr
    @agl = agl
    @ret = ret
	end
	
end

@equipments = []
@equipments << @sword = Equipment.new("검", "표준적인 무기.", 5, 10, atk: 5)
