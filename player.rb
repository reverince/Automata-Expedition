require_relative "puppet"

class Player
	attr_accessor :name, :puppets, :expeditions
	attr_reader :items, :silver, :manade
	
	def initialize(name)
		@name = name
		@puppets = []
		@expeditions = []
		@items = {}
		@silver = 100
		@manade = 100
	end
	def to_s
		@name
	end
	def info
		"[#{puppets_level}]\t#{@name}\t인형 #{@puppets.size}개 | 은화 #{@silver}sv | 마네이드 #{@manade}ml"
	end

	# 인형
	def puppets_info(with_index: false)
		ret = ""
		@puppets.each_with_index do |puppet, i|
			ret += "#{i.to_s}.\t" if with_index
			ret += "#{puppet.info}\n"
		end
		
		ret
	end
	def puppets_level # 인형 총합 레벨
		@puppets.sum(&:lvl) or 0
	end
	
	# 원정대
	def expeditions_info(with_index: false)
		ret = ""
		@expeditions.each_with_index do |expedition, i|
			ret += "#{i.to_s}.\t" if with_index
			ret += "#{expedition.info}\n"
		end
		
		ret
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
	def has_item?(item) # 보유 여부 확인
		@items.keys.map(&:name).index(item.name) ? true : false
	end
  def has_item_type?(type) # @dolls 등
    type.each { |item| has_item?(item) ? (return true) : next }
    false
  end
	def count_item(item)
		@items[@items.keys[@items.keys.map(&:name).index(item.name)]]
	end
  def show_items(type=nil, with_index: false)
    i = 0
    type = type.map(&:name) unless type.nil?
    @items.each do |item, amount|
      if type.nil? || type.include?(item.name)
        print "#{i.to_s}.\t" if with_index
        puts "[#{amount.to_s}개]\t" + item.info
        i += 1
      end
    end
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
