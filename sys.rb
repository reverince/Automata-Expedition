require "base64"
require_relative "josa"
require_relative "player"
require_relative "item"

SAVE_FILE = "save.dat"

def clear
	system "cls" or system "clear"
end
def input
	while true
		ipt = gets
		if ipt.valid_encoding?
			break
		else
			print "다시 입력해 주세요. >> "
		end
	end
	ipt.chop.upcase
end
def no_command
	typing "그런 명령어는 없어요."
end

def typing(str) # 한 글자씩 출력
	str.chars.each { |c| print c; sleep(0.05)}
	sleep(0.1)
	puts ""
end

def gauge(value, max) # 0 ~ max
	per = value / max
	"[" + "*" * (10 * per) + "." * [10 * (1-per), 0].max + "]"
end
def percent(value, max=100, sosu=2)
	"#{( value.to_f / max * 100 ).round(2)}%"
end

# 시스템 커맨드

def load_file
	begin
		f = File.read(SAVE_FILE).split('|')
		@chara = Marshal.load(Base64.decode64(f[0]))
		#@map.tiles = Marshal.load(Base64.decode64(f[1]))
		@chara ? ( typing "* 데이터를 불러왔어요! 어서오세요, #{@chara.name}님." ) : ( raise StandardError )
	rescue Errno::ENOENT
		#puts "* 저장 파일을 찾을 수 없어요."
		new_file
	rescue StandardError
		puts "! 저장 파일이 손상되었습니다."
		exit(1)
	end
end
def new_file
	print "이름을 입력하세요. >> "
	name = input
	@chara = Player.new(name)
	save_file
end
def save_file
	f = File.open(SAVE_FILE, "w")
	f.puts Base64.encode64(Marshal.dump(@chara))
	#f.write "|"
	#f.puts Base64.encode64(Marshal.dump(@map.tiles))
	f.close
	typing "* 데이터를 저장했어요!"
end
def quit_game
	save_file
	exit(0)
end

# 지휘본부 커맨드

def menu_expedition # 원정대
	loop do
		clear
		typing "< 원정대 관리 >"
		if @chara.expeditions.empty?
			typing "* 구성한 원정대가 없어요."
		end
		
		@chara.expeditions.each do |expedition|
			puts expedition.info
		end
		puts "[N. 신규]\t[E. 변경]\t[Q. 본부]"
		print ">> "
		case (ipt = input)
			when "N"
				new_expedition
			
			when "E"
				edit_expedition
			
			when "Q"
				return
		end
	end
end

def menu_puppet # 인형
	clear
	typing "< 인형 목록 >"
	
	if @chara.puppets.empty?
		typing "* 인형이 하나도 없어요."
		return
	end
	
	@chara.puppets.each do |puppet|
		puts puppet.info
	end
	print ">> "
	ipt = input
end

def menu_item # 아이템
	clear
	typing "< 아이템 목록 >"
	
	if @chara.items.empty?
		typing "* 아이템이 하나도 없어요."
		return
	end
	
	@chara.items.each do |item, amount|
		puts "[#{amount.to_s}개]\t" + item.info
	end
	print ">> "
	ipt = input
end

def menu_workshop # 공방
	loop do
		clear
		
		typing "< 공방 >"
		puts "[C. 인형 제작]\t[Q. 본부]"
		print ">> "
		case (ipt = input)
			when "C"
				make_puppet
			
			when "Q"
				return
		end
	end
end

def menu_shop # 상점
	loop do
		clear
		typing "< 상점 >"
		
		puts "[B. 아이템 구매]\t[S. 아이템 판매]\t[Q. 본부]"
		print ">> "
		case (ipt = input)
			when "B"
				buy_item
			
			when "S"
				sell_item
			
			when "Q"
				return
		end
	end
end

# 원정대 관리 커맨드

def new_expedition # 원정대 추가
	if @chara.puppets.empty?
		typing "* 인형이 하나도 없어요."
		return
	end
	
	name = ""
	loop do
		print "이름 >> "
		return if (name = input) == "Q"
		if @chara.expeditions.map(&:name).include? name
			puts "[!] 같은 이름의 원정대가 있어요."
		else
			break
		end
	end
	
	expedition = Expedition.new(name)
	
	loop do
		clear
		
		puppets_name = ""
		expedition.puppets.each_with_index do |puppet, i|
			puppets_name += "[#{i.to_s}] #{puppet.name}, "
		end
		puts "#{expedition} 대원: " + puppets_name[0..-3]
		puts ""
		@chara.puppets.each_with_index do |puppet, i|
			puts "[#{i.to_s}]\t" + puppet.info
		end
		puts ""
		puts "[!] 원정대가 비었어요." unless expedition.puppets.any?
		puts "[D. 완료]\t[Q. 취소]\t[0+. 인형 추가]\t[0-. 인형 제외]\t[H. 도움말]"
		print ">> "
		case (ipt = input)
		when /^(\d+)\+$/
			if expedition.puppets.map(&:name).include? @chara.puppets[$1.to_i].name
				typing "[!] 이미 추가한 인형이에요."
			else
				expedition.puppets << @chara.puppets[$1.to_i]
			end
		
		when /^(\d+)\-$/
			expedition.puppets.delete_at($1.to_i)
		
		when "D"
			if expedition.puppets.any?
				@chara.expeditions << expedition
				typing "* 새 원정대 " + josa(expedition.name, "를") + " 만들었어요."
			else
				typing "[!] 원정대에 아무 인형도 추가하지 않았어요."
				next
			end
		
		when "H"
			typing "[?] 인형 번호 뒤에 '+', '-'를 붙여 입력하면 추가 또는 제외할 수 있어요..."
		when "Q"
			return
		end
	end
end

def edit_expedition
	
end

# 공방 커맨드

def make_puppet # 인형 제작
	unless @chara.has_item(@doll)
		typing "[!] 인형 소체가 부족해요."
		return
	end
	
	puts "인형 소체 1개를 사용해 인형을 제작합니다. [Q. 취소]"
	
	loop do
		print "이름 >> "
		return if (name = input) == "Q"
		if @chara.puppets.map(&:name).include? name
			puts "[!] 같은 이름의 인형이 있어요."
		else
			break
		end
	end
	
	hp = BASE_HP; atk = BASE_ATK; amr = BASE_AMR; agl = BASE_AGL; ret = BASE_RET
	point = price = 0
	done = false
	
	loop do
		clear
		
		point = (hp-BASE_HP)/10 + (atk-BASE_ATK) + (amr-BASE_AMR) + (agl-BASE_AGL) + (ret-BASE_RET)/5
		price = point * MANADE_PER_POINT
		
		puts "HP\t#{sprintf("%4d", hp.to_s)}\t(#{sprintf("%6.2f%", hp.to_f / MAX_HP * 100)})"
		puts "ATK\t#{sprintf("%4d", atk.to_s)}\t(#{sprintf("%6.2f%", atk.to_f / MAX_ATK * 100)})"
		puts "AMR\t#{sprintf("%4d", amr.to_s)}\t(#{sprintf("%6.2f%", amr.to_f / MAX_AMR * 100)})"
		puts "AGL\t#{sprintf("%4d", agl.to_s)}\t(#{sprintf("%6.2f%", agl.to_f / MAX_AGL * 100)})"
		puts "RET\t#{sprintf("%4d", ret.to_s)}\t(#{sprintf("%6.2f%", ret.to_f / MAX_RET * 100)})"
		puts ""
		puts "[!] 주입 수준이 0 미만이에요. 제작할 수 없어요." if point < 0
		puts "[!] 마네이드가 부족해요. 제작할 수 없어요." if price > @chara.manade
		puts "주입 포인트: [#{point}pt]\t소모 마네이드: [#{price}/#{@chara.manade}]"
		puts "[D. 완료]\t[Q. 취소]\t[H. 도움말]"
		
		case (ipt = input)
			when /HP(\+*)(\-*)/
				hp += 10 * ($1.length - $2.length)
			when /ATK(\+*)(\-*)/
				atk += 1 * ($1.length - $2.length)
			when /AMR(\+*)(\-*)/
				amr += 1 * ($1.length - $2.length)
			when /AGL(\+*)(\-*)/
				agl += 1 * ($1.length - $2.length)
			when /RET(\+*)(\-*)/
				ret += 5 * ($1.length - $2.length)
			
			when "D"
				if point < 0
					typing "[!] 주입 수준이 0 미만이에요."
					next
				elsif price > @chara.manade
					typing "[!] 마네이드가 부족해요."
					next
				end
				done = true
			
			when "H"
			typing "[?] 'HP+++', 'ATK--' 등 명령어로 능력 주입치를 조절할 수 있어요..."
			when "Q"
			return
		end
		hp = MAX_HP if hp > MAX_HP
		atk = MAX_ATK if atk > MAX_ATK
		atk = -MAX_ATK if atk < -MAX_ATK
		break if done
	end
	
	if @chara.use_manade(price)
		puppet = Puppet.new(name, hp, atk, amr, agl, ret)
		@chara.use_item(@doll)
		@chara.puppets << puppet
		typing "* 새 인형 " + josa(name, "를") + " 만들었어요."
	else
		typing "[!] 마네이드가 부족해요."
	end
end

# 상점 커맨드

def buy_item # 아이템 구매
	items = [@doll]
	
	loop do
		clear
		
		items.each_with_index do |item, i|
			puts "[#{i.to_s}]\t" + item.info
		end
		puts "번호를 입력하세요. [Q. 뒤로]"
		print ">> "
		case (ipt = input)
			when /^(\d+)$/
				if item = items[$1.to_i]
					puts "* " + josa(item.name, "는") + " #{item.value}sv인데, 몇 개 사시겠어요?"
					amount = input.to_i
					price = item.value * amount
					
					if @chara.use_silver(price)
						typing "* #{price}sv 받았어요. #{item.name} #{amount}개 드릴게요."
						@chara.get_item(item, amount)
					else
						typing "* 돈이 부족한 것 같은데요."
					end
				end
			
			when "Q"
			return
		end
	end
end

def sell_item # 아이템 판매
	if @chara.items.empty?
		typing "* 아이템이 하나도 없어요."
		return
	end
	
	loop do
		clear
		
		@chara.items.keys.each_with_index do |item, i|
			puts "[#{i.to_s}]\t[#{@chara.count_item(item)}개]\t#{item.info}"
		end
		puts "번호를 입력하세요. [Q. 뒤로]"
		print ">> "
		case (ipt = input)
			when /^(\d+)$/
				if item = @chara.items.keys[$1.to_i]
					if item.value.nil?
						typing "* 그건 안 사요."
						next
					end
					
					puts "* " + josa(item.name, "는") + " #{item.value}sv인데, 몇 개 파시겠어요?"
					amount = input.to_i
					price = item.value * amount
					
					if @chara.use_item(item, amount)
						typing "* #{item.name} #{amount}개 받았어요. #{price}sv 드릴게요."
						@chara.get_silver(price)
					else
						typing "* 그만큼은 가지고 있지 않은 것 같은데요."
					end
				end
			
			when "Q"
			return
		end
	end
end
