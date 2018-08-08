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

    @geinins_list = []

    @indexes.each do |index|
      geinins = Geinin.index_search(index)
      @geinins_list << geinins
    end
    
    return @geinins_list, @indexes
   
  end
end