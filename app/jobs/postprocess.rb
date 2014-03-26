class Postprocess < Struct.new(:talk_id)
  def perform
    Talk.find(talk_id).postprocess!
  end
end
