class TextareaConcatService

  def initialize(event_performers_param,event_id_param)

    @event_performers = event_performers_param
    @event_id = event_id_param

  end

  def execute
    # 1行ずつ改行コードを入れて結合する
    @text_area = ""
    @event_performers.each do |performer|
      # 末尾に改行をつける
      @text = performer.concat("\r\n")
      @text_area = @text_area.concat(@text)
    end

    @text_area
  end
end