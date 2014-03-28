class Postprocess < Struct.new(:talk_id)
  def perform
    Talk.find(talk_id).delay(queue: 'audio').postprocess!
  end
end
