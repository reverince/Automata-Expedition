require "base64"
require_relative "josa"
require_relative "player"

SAVE_FILE = "save.dat"

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
	puts ""
	sleep(0.1)
end
def chat(message = "")
	sleep(message.length/10)
	puts message
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

def manage_expedition # 원정대 관리
	typing "< 원정대 관리 >"
	
end

def list_puppet # 인형 목록
	typing "< 인형 목록 >"
	if @chara.puppets.size == 0
		typing "* 인형이 하나도 없어요."
		return
	end
	@chara.puppets.each do |puppet|
		puts puppet.info
	end
end

def workshop # 공방
	typing "< 공방 >"
	loop do
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

def shop # 상점
	typing "< 상점 >"
	
end

# 공방 커맨드

def make_puppet # 인형 제작
	puts "인형을 제작합니다. Q를 입력하면 취소할 수 있어요."
	print "이름 >> "
	return if (name = input) == "Q"
	
	puppet = Puppet.new(name)
	@chara.puppets << puppet
	typing "인형을 만들었습니다."
end