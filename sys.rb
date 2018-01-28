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
def typing(str) # 한 글자씩 출력
	str.chars.each { |c| print c; sleep(0.05)}
	sleep(0.1)
	puts ""
end
def chat(message = "")
	sleep(message.length/10)
	puts message
end

def no_command
	typing "그런 명령어는 없어요."
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
		typing "< 원정대 관리 >"
		
		print ">> "
		case (ipt = input)
			
			when "Q"
			return
		end
	end
end

def menu_puppet # 인형
	clear
	typing "< 인형 목록 >"
	if @chara.puppets.size == 0
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
	if @chara.items.size == 0
		typing "* 아이템이 하나도 없어요."
		return
	end
	@chara.items.each do |item, amount|
		puts "[#{amount.to_s}]\t" + item.info
	end
	print ">> "
	ipt = input
end

def menu_workshop # 공방
	loop do
		clear
		typing "< 공방 >"
		puts "C. 인형 제작\tQ. 본부"
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
		puts "B. 아이템 구매\tS. 아이템 판매\tQ. 본부"
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

# 공방 커맨드

def make_puppet # 인형 제작
	unless @chara.has_item(@doll)
		puts "인형 소체가 부족합니다."
	end
	puts "인형 소체 1개를 사용해 인형을 제작합니다. Q. 취소"
	print "이름 >> "
	return if (name = input) == "Q"
	
	puppet = Puppet.new(name)
	@chara.use_item(@doll)
	@chara.puppets << puppet
	typing "인형을 만들었습니다."
end

# 상점 커맨드

def buy_item # 아이템 구매
	items = [nil, @doll]
	loop do
		items.each_with_index do |item, i|
			next if i == 0
			puts "[#{i.to_s}]\t" + item.info
		end
		puts "번호를 입력하세요. Q. 뒤로"
		print ">> "
		case (ipt = input)
			when /^(\d+)$/
			if item = items[$1.to_i]
				puts "* " + josa(item.name, "는") + " #{item.value}sv인데, 몇 개 사시겠어요?"
				amount = input.to_i
				price = item.value * amount
				if @chara.use_silver(price)
					puts "* #{price}sv 받았어요. " + josa(item.name, "를") + " #{amount}개 드릴게요."
					@chara.get_item(item, amount)
				else
					puts "* 돈이 부족한 것 같은데요."
				end
			end
			
			when "Q"
			return
		end
	end
end

def sell_item # 아이템 판매
	
end
