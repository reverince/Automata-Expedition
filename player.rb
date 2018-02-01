require_relative "puppet"

class Player
	attr_accessor :name, :puppets
	attr_reader :items, :silver, :manade
	
	def initialize(name)
		@name = name
		@puppets = []
		@items = {}
		@silver = 100
		@manade = 100
	end
	def to_s
		@name
	end
	def info
		"[#{puppet_level}]\t#{@name}\t인형 #{@puppets.size}개 | 은화 #{@silver}sv | 마네이드 #{@manade}ml"
	end

	def puppet_level # 인형 총합 레벨
		@puppets.map(&:lvl).reduce(:+) or 0
	end
	
	# 아이템
	def get_item(item, amount=1)
		( i = @items.keys.map(&:name).index(item.name) ) ? ( @items[@items.keys[i]] += amount ) : ( @items[item] = amount )
	end
	def use_item(item, amount=1)
		if ( i = @items.keys.map(&:name).index(item.name) ) && @items[@items.keys[i]] >= amount
			@items[@items.keys[i]] -= amount
			@items.delete(@items.keys[i]) if @items[@items.keys[i]] <= 0
			true
		else
			false
		end
	end
	def has_item(item) # 보유 여부 확인
		@items.keys.map(&:name).index(item.name) ? true : false
	end
	def count_item(item)
		@items[@items.keys[@items.keys.map(&:name).index(item.name)]]
	end
	
	# 실버 / 마네이드
	def get_silver(amount)
		@silver += amount
	end
	def use_silver(amount)
		if @silver >= amount
			@silver -= amount
			true
		else
			false
		end
	end
	def get_manade(amount)
		@manade += amount
	end
	def use_manade(amount)
		if @manade >= amount
			@manade -= amount
			true
		else
			false
		end
	end
	
end
