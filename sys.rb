require "base64"
require_relative "josa"
require_relative "player"
require_relative "battle"

SAVE_FILE = "save.dat"

def clear
	system "cls" or system "clear"
end
def input
	while true
		ipt = gets
		if ipt.valid_encoding? && ipt != "\n"
			break
		else
			print "다시 입력해 주세요. >> "
		end
	end
	ipt.chop.upcase
end
def alerting
	unless @alert.nil?
		puts @alert
		@alert = nil
	end
end

# 시스템 커맨드

def load_file
	begin
		f = File.read(SAVE_FILE).split('|')
		@chara = Marshal.load(Base64.decode64(f[0]))
		#@map.tiles = Marshal.load(Base64.decode64(f[1]))
		@chara ? ( puts "* 데이터를 불러왔어요! 어서오세요, #{@chara.name}님." ) : ( raise StandardError )
	rescue Errno::ENOENT
		#puts "* 저장 파일을 찾을 수 없어요."
		new_file
	rescue StandardError
		puts "[!] 저장 파일이 손상되었습니다."
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
	puts "* 데이터를 저장했어요!"
	sleep(1)
end
def quit_game
	save_file
	exit(0)
end

# 지휘본부 커맨드

def menu_go # 출정
	
end

def menu_expedition # 원정대
	loop do
		clear
		
		puts "< 원정대 관리 >"
		alerting
		puts ""
		if @chara.expeditions.any?
			puts @chara.expeditions_info(with_index=true)
		else
			puts "* 구성한 원정대가 없어요."
		end
		puts ""
		puts "[N. 추가] [0E. 편집] [0R. 이름 변경] [0D. 삭제] [Q. 본부]"
		print ">> "
		case (ipt = input)
			when "N"
				new_expedition
			
			when /^(\d+)E$/
				edit_expedition($1.to_i)
			
			when /^(\d+)R$/
				rename_expedition($1.to_i)
			
			when /^(\d+)D$/
				delete_expedition($1.to_i)
			
			when "Q"
				return
		end
	end
end

def menu_workshop # 공방
	loop do
		clear
		
		puts "< 공방 >"
		alerting
		puts ""
		puts @chara.puppets_info(with_index=true)
		
		puts "[C. 인형 제작] [Q. 본부]"
		print ">> "
		case (ipt = input)
			when "C"
				make_puppet
			
			when "Q"
				return
		end
	end
end

def menu_item # 아이템
	clear
	
	puts "< 아이템 목록 >"
	puts ""
	if @chara.items.empty?
		@alert = "* 아이템이 하나도 없어요."
		return
	end
	
	@chara.items.each do |item, amount|
		puts "[#{amount.to_s}개]\t" + item.info
	end
	puts ""
	print ">> "
	ipt = input
end

def menu_shop # 상점
	loop do
		clear
		puts "< 상점 >"
		alerting
		puts ""
		puts "[B. 아이템 구매] [S. 아이템 판매] [Q. 본부]"
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
		@alert = "[!] 인형이 하나도 없어요."
		return
	end
	
	name = ""
	loop do
		clear
		
		puts "< 원정대 추가 >"
		alerting
		puts ""
		puts "[Q. 취소]"
		print "이름 >> "
		return if (name = input) == "Q"
		if @chara.expeditions.map(&:name).include? name
			@alert = "[!] 같은 이름의 원정대가 있어요."
		else
			break
		end
	end
	
	expedition = Expedition.new(name)
	
	loop do
		clear
		
		puts "< 원정대 추가 >"
		puts ""
		puppets_name = ""
		expedition.puppets.each_with_index do |puppet, i|
			puppets_name += "#{i.to_s}. #{puppet.name} / "
		end
		puts "#{expedition} 대원: " + puppets_name[0..-4]
		puts ""
		@chara.puppets.each_with_index do |puppet, i|
			puts "#{i.to_s}.\t" + puppet.info
		end
		puts ""
		puts "[!] 원정대가 비었어요." unless expedition.puppets.any?
		alerting
		puts "[D. 완료] [Q. 취소] [0+. 인형 추가] [0-. 인형 제외] [H. 도움말]"
		print ">> "
		case (ipt = input)
		when /^(\d+)\+$/
			if expedition.puppets.map(&:name).include? @chara.puppets[$1.to_i].name
				@alert = "[!] 이미 추가한 인형이에요."
			else
				expedition.puppets << @chara.puppets[$1.to_i]
			end
		
		when /^(\d+)\-$/
			expedition.puppets.delete_at($1.to_i)
		
		when "D"
			if expedition.puppets.any?
				@chara.expeditions << expedition
				@alert = "* 새 원정대 " + josa(expedition.name, "를") + " 만들었어요."
				return
			else
				@alert = "[!] 원정대에 아무 인형도 추가하지 않았어요."
				next
			end
		
		when "H"
			@alert = "[?] 인형 번호 뒤에 '+', '-'를 붙여 입력하면 추가 또는 제외할 수 있어요..."
		when "Q"
			return
		end
	end
end

def edit_expedition(i)
	if @chara.expeditions[i].nil?
		return
	end
	
	# TODO
end

def rename_expedition(i)
	if @chara.expeditions[i].nil?
		return
	end
	
	name = ""
	loop do
		clear
		
		puts "< 원정대 이름 변경 >"
		puts ""
		alerting
		puts "[Q. 취소]"
		print "이름 >> "
		return if (name = input) == "Q"
		if @chara.expeditions.map(&:name).include? name
			@alert = "[!] 같은 이름의 원정대가 있어요."
		else
			break
		end
	end
	
	@chara.expeditions[i].name = name
	@alert = "* 원정대 이름을 " + josa(name, "로") + " 바꿨어요."
end

def delete_expedition(i)
	if @chara.expeditions[i].nil?
		return
	end
	
	name = @chara.expeditions[i].name
	puts "* 정말 원정대 " + josa(name, "를") + " 삭제할까요?"
	print "[Y/N] >> "
	
	if input == "Y"
		@chara.expeditions.delete_at(i)
		@alert = "* 원정대 " + josa(name, "를") + " 삭제했어요."
	end
end

# 공방 커맨드

def make_puppet # 인형 제작
	unless @chara.has_item(@doll)
		@alert = "[!] 인형 소체가 부족해요."
		return
	end
	
	alert = "* 인형 소체 1개를 사용해 인형을 제작합니다."
	name = ""
	loop do
		clear
		
		puts "< 인형 제작 >"
		puts ""
		puts alert
		puts "[Q. 취소]"
		print "이름 >> "
		return if (name = input) == "Q"
		if @chara.puppets.map(&:name).include? name
			alert = "[!] 같은 이름의 인형이 있어요."
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
		
		puts "< 인형 제작 >"
		puts ""
		puts name
		puts "HP\t#{sprintf("%4d", hp.to_s)}\t(#{sprintf("%6.2f%", hp.to_f / MAX_HP * 100)})"
		puts "ATK\t#{sprintf("%4d", atk.to_s)}\t(#{sprintf("%6.2f%", atk.to_f / MAX_ATK * 100)})"
		puts "AMR\t#{sprintf("%4d", amr.to_s)}\t(#{sprintf("%6.2f%", amr.to_f / MAX_AMR * 100)})"
		puts "AGL\t#{sprintf("%4d", agl.to_s)}\t(#{sprintf("%6.2f%", agl.to_f / MAX_AGL * 100)})"
		puts "RET\t#{sprintf("%4d", ret.to_s)}\t(#{sprintf("%6.2f%", ret.to_f / MAX_RET * 100)})"
		puts ""
		puts "주입 포인트: [#{point}pt]\t소모 마네이드: [#{price}/#{@chara.manade}]\n"
		
		puts "[!] 주입 수준이 0 미만이에요. 제작할 수 없어요." if point < 0
		puts "[!] 마네이드가 부족해요. 제작할 수 없어요." if price > @chara.manade
		alerting
		puts "[D. 완료] [Q. 취소] [H. 도움말]"
		print ">> "
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
					next
				elsif price > @chara.manade
					next
				end
				done = true
			
			when "H"
			@alert = "[?] 'HP+++', 'ATK--' 등 명령어로 능력 주입치를 조절할 수 있어요..."
			when "Q"
			return
		end
		
		hp = MAX_HP if hp > MAX_HP
		hp = MIN_HP if hp < MIN_HP
		atk = MAX_ATK if atk > MAX_ATK
		atk = -MAX_ATK if atk < -MAX_ATK
		amr = MAX_AMR if amr > MAX_AMR
		amr = 0 if amr < 0
		agl = MAX_AGL if agl > MAX_AGL
		agl = 0 if agl < 0
		ret = MAX_RET if ret > MAX_RET
		ret = MIN_RET if ret < MIN_RET
		
		break if done
	end
	
	if @chara.use_manade(price)
		puppet = Puppet.new(name, hp, atk, amr, agl, ret)
		@chara.use_item(@doll)
		@chara.puppets << puppet
		puts "* 새 인형 " + josa(name, "를") + " 만들었어요."
		sleep(1)
	else
		puts "[!] 마네이드가 부족해요."
		sleep(1)
	end
end

# 상점 커맨드

def buy_item # 아이템 구매
	items = [@doll]
	
	alert = ""
	loop do
		clear
		
		puts "< 아이템 구매 >"
		alerting
		puts ""
		items.each_with_index do |item, i|
			puts "#{i.to_s}.\t" + item.info
		end
		puts "번호를 입력하세요."
		puts "[Q. 뒤로]"
		print ">> "
		case (ipt = input)
			when /^(\d+)$/
				if item = items[$1.to_i]
					puts "* " + josa(item.name, "는") + " #{item.value}sv인데, 몇 개 사시겠어요?"
					if (amount = input.to_i) > 0
					price = item.value * amount
						if @chara.use_silver(price)
							@alert = "* #{price}sv 받았어요. #{item.name} #{amount}개 드릴게요."
							@chara.get_item(item, amount)
						else
							@alert = "* 돈이 부족한 것 같은데요."
						end
					end
				end
			
			when "Q"
			return
		end
	end
end

def sell_item # 아이템 판매
	if @chara.items.empty?
		@alert = "* 아이템이 하나도 없어요."
		return
	end
	
	loop do
		clear
		
		puts "< 아이템 판매 >"
		alerting
		puts ""
		@chara.items.keys.each_with_index do |item, i|
			puts "#{i.to_s}. \t[#{@chara.count_item(item)}]\t#{item.info}"
		end
		puts "번호를 입력하세요."
		puts "[Q. 뒤로]"
		print ">> "
		case (ipt = input)
			when /^(\d+)$/
				if item = @chara.items.keys[$1.to_i]
					if item.value.nil?
						@alert = "* 그건 안 사요."
						next
					end
					
					puts "* " + josa(item.name, "는") + " #{item.value}sv인데, 몇 개 파시겠어요?"
					if (amount = input.to_i) > 0
						price = item.value * amount
						if @chara.use_item(item, amount)
							@alert = "* #{item.name} #{amount}개 받았어요. #{price}sv 드릴게요."
							@chara.get_silver(price)
						else
							@alert = "* 그만큼은 가지고 있지 않은 것 같은데요."
						end
					end
				end
			
			when "Q"
			return
		end
	end
end
