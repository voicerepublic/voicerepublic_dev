class ProcessOverride < Struct.new(:talk_id)
  def perform
    Talk.find(talk_id).delay(queue: 'audio').process_override!
  end
end
