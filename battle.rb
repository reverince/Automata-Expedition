class Map
	attr_reader :name
	
	def initialize(name)
		@name = name
	end
	def to_s
		@name
	end
end

def battle(enemy)
	loop do
		clear
		
		puts enemy.status
		puts @party.status
		puts ""
		puts "[0D. 방어] [Q. 종료]"
		played = false
		while !played do
			print ">> "
			case (ipt = input)
				when /^(\d+)D$/
					p = @party.puppets[$1.to_i]
					puts "* " + josa(p.name, "가") + " 방어 대형을 취합니다."
					p.form = GUARDING
				
				else
					next
			end
			played = true
		end
		
	end
end
def battle_sim
	@party = @chara.expeditions[0] if @party.nil?
	battle(Spider.new)
end
