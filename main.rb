require_relative "sys"

while !@chara
	load_file
end

loop do
	typing "< 지휘본부 >"
	puts @chara.info
	puts "G. 출정\tM. 원정대 관리\tL. 인형 목록"
	puts "\tW. 공방\tP. 상점\tS. 저장\tQ. 종료"
	print ">> "
	case (ipt = input)
		when "M" # 원정대 관리
		manage_expedition
		
		when "L" # 인형 목록
		list_puppet
		
		when "W" # 공방
		workshop
		
		when "P" # 상정
		shop
		
		when "S" # 저장
		save_file
		
		when "Q" # 종료
		quit_game
	end
end
