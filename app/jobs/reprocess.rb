class Reprocess < Struct.new(:talk_id)
  def perform
    Talk.find(talk_id).delay(queue: 'audio').reprocess!
  end
end
