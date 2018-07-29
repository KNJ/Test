class SearchGeininByIndexService

  def initialize(index_param)

    @index = index_param
  
end

  def execute
    case @index
    when 'a' then
      @indexes = "あ","い","う”,"え",”お"
    when 'ka' then
      @indexes = "か","き","く”,"け",”こ"
    when 'sa' then
      @indexes = "さ","し","す”,"せ",”そ"
    when 'ta' then
      @indexes = "た","ち","つ”,"て",”と"
    when 'na' then
      @indexes = "な","に","ぬ”,"ね",”の"
    when 'ha' then
      @indexes = "は","ひ","ふ”,"へ",”ほ"
    when 'ma' then
      @indexes = "ま","み","む”,"め",”も"
    when 'ya' then
      @indexes = ”や”,"ゆ","よ"
    when 'ra' then
      @indexes = "ら","り","る”,”れ","ろ"
    when 'wa' then
      @indexes = ”わ”,"を","ん"
    end

    Geinin.default.where("(yomi LIKE(?)) OR (yomi LIKE (?) OR (yomi LIKE (?) OR (yomi LIKE (?) OR (yomi LIKE (?))",@indexes[0],@indexes[1],@indexes[2],@indexes[3],@indexes[4])

  end
end