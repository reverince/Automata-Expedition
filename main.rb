require_relative "sys"

while !@chara
	load_file
end

loop do
	clear
	
	puts "< 지휘본부 >"
	alerting
	puts ""
	puts @chara.info
	puts "[G. 출정] [E. 원정대] [W. 공방]"
	puts "          [I. 아이템] [S. 상점] [$. 저장] [@. 종료]"
	print ">> "
	case (ipt = input)
		when "G" # 출정
		menu_go
		
		when "E" # 원정대
		menu_expedition
		
		when "W" # 공방
		menu_workshop
		
		when "I" # 아이템
		menu_item
		
		when "S" # 상점
		menu_shop
		
		when "$" # 저장
		save_file
		
		when "@" # 종료
		quit_game
		
		#디버그 커맨드
		when /EXP(\d+)$/
		@chara.puppets[0].get_exp($1.to_i)
		when /EEE$/
		battle_sim
		sleep(5)
	end
end
