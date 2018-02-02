require_relative "sys"

while !@chara
	load_file
end

loop do
	typing "< 지휘본부 >"
	puts @chara.info
	puts "G. 출정\tE. 원정대\tP. 인형\tI. 아이템"
	puts "\tW. 공방\tS. 상점\tSA. 저장\tQ. 종료"
	print ">> "
	case (ipt = input)
		when "G" # 출정
		
		
		when "E" # 원정대
		menu_expedition
		
		when "P" # 인형
		menu_puppet
		
		when "I" # 아이템
		menu_item
		
		when "W" # 공방
		menu_workshop
		
		when "S" # 상점
		menu_shop
		
		when "SA" # 저장
		save_file
		
		when "Q" # 종료
		quit_game
	else
		no_command
	end
	clear
end
