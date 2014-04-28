class ProcessOverride < Struct.new(:talk_id)
  def perform
    Talk.find(talk_id).send(:process_override!)
  end
end
