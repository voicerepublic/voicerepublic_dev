class Reprocess < Struct.new(:talk_id)
  def perform
    Talk.find(talk_id).send(:reprocess!)
  end
end
