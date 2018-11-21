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
    puts "[0A. 공격] [0G. 방어] [D. 종료]"
    played = false
    while !played do
      print ">> "
      case (ipt = input)
        when /^(\d+)A$/
          p = @party.puppets[$1.to_i]
          puts "* " + josa(p.name, "가") + " 공격 준비를 합니다."
          p.form = ATTACK
        when /^(\d+)G$/
          p = @party.puppets[$1.to_i]
          puts "* " + josa(p.name, "가") + " 방어 대형을 취합니다."
          p.form = GUARD
        when "D"
          break
        else
          next
      end
    end
    
  end
end

def battle_sim
  @party = @chara.expeditions[0] if @party.nil?
  battle(Spider.new)
end
