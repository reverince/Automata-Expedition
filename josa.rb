KR_RANGE = ('가'.unpack('U')[0]..'힣'.unpack('U')[0]).freeze
KR_OFFSET = '가'.unpack('U')[0].freeze
CHO = ["ㄱ", "ㄲ", "ㄴ", "ㄷ", "ㄸ", "ㄹ", "ㅁ", "ㅂ", "ㅃ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅉ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"].freeze
JUNG = ["ㅏ", "ㅐ", "ㅑ", "ㅒ", "ㅓ", "ㅔ", "ㅕ", "ㅖ", "ㅗ", "ㅘ", "ㅙ", "ㅚ", "ㅛ", "ㅜ", "ㅝ", "ㅞ", "ㅟ", "ㅠ", "ㅡ", "ㅢ", "ㅣ"].freeze
JONG = ["", "ㄱ", "ㄲ", "ㄳ", "ㄴ", "ㄵ", "ㄶ", "ㄷ", "ㄹ", "ㄺ", "ㄻ", "ㄼ", "ㄽ", "ㄾ", "ㄿ", "ㅀ", "ㅁ", "ㅂ", "ㅄ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"].freeze


def josa(str, sel)
	kr = str[-1].unpack('U')[0] - KR_OFFSET
	
	jong = kr % 28
	jung = (kr - jong) / 28 % 21
	cho = ( (kr - jong) / 28 - jong ) / 21
	
	case sel
		when "은","는"
			jong > 0 ? "#{str}은" : "#{str}는"
		when "을", "를"
			jong > 0 ? "#{str}을" : "#{str}를"
		when "이", "가"
			jong > 0 ? "#{str}이" : "#{str}가"
		when "로", "으로"
			jong > 0 ? "#{str}으로" : "#{str}로"
	else
		raise "은는을를이가으로"
	end
end