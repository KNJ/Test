class SearchGeininByIndexService

  def initialize(index_param)

    @index = index_param
  
end

  def execute
    case @index
    when 'a' then
      @indexes = "あ%","い%","う%","え%","お%"
    when 'ka' then
      @indexes = "か%","き%","く%","け%","こ%","が%","ぎ%","ぐ%","げ%","ご%"
    when 'sa' then
      @indexes = "さ%","し%","す%","せ%","そ%","ざ%","じ%","ず%","ぜ%","ぞ%"
    when 'ta' then
      @indexes = "た%","ち%","つ%","て%","と%","だ%","ぢ%","づ%","で%","ど%"
    when 'na' then
      @indexes = "な%","に%","ぬ%","ね%","の%"
    when 'ha' then
      @indexes = "は%","ひ%","ふ%","へ%","ほ%","ば%","び%","ぶ%","べ%","ぼ%","ぱ%","ぴ%","ぷ%","ぺ%","ぽ%"
    when 'ma' then
      @indexes = "ま%","み%","む%","め%","も%"
    when 'ya' then
      @indexes = "や%","ゆ%","よ%","",""
    when 'ra' then
      @indexes = "ら%","り%","る%","れ%","ろ%"
    when 'wa' then
      @indexes = "わ%","を%","ん%","",""
    end

    @a = @indexes[0]
    @i = @indexes[1]
    @u = @indexes[2]
    @e = @indexes[3]
    @o = @indexes[4]

    @geinins_aiueo = Geinin.index_search(@a,@i,@u,@e,@o)
    @geinins_dakuten = Geinin.index_search(@indexes[5],@indexes[6],@indexes[7],@indexes[8],@indexes[9])
    @geinins_handakuten = Geinin.index_search(@indexes[10],@indexes[11],@indexes[12],@indexes[13],@indexes[14])
    
    @geinins = @geinins_aiueo + @geinins_dakuten + @geinins_handakuten
    @results = @geinins,@a,@i,@u,@e,@o
   
  end
end