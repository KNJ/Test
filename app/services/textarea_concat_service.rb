class TextareaConcatService

  def initialize(texts)

    @texts = texts

  end

  def execute
    # 1行ずつ改行コードを入れて結合する
    @text_area = ""
    @texts.each do |text|
      # 末尾に改行をつける
      @text = text.concat("\r\n")
      @text_area = @text_area.concat(@text)
    end

    @text_area
  end
end