# Code from: https://gist.github.com/335286
# USAGE: Hash.from_xml:(YOUR_XML_STRING)
# modified from http://stackoverflow.com/questions/1230741/convert-a-nokogiri-document-to-a-ruby-hash/1231297#1231297

class Hash
  class << self
    def from_xml(xml_io) 
      begin
        result = Nokogiri::XML(xml_io)
        return { result.root.name.to_sym => xml_node_to_hash(result.root)} 
      rescue Exception => e
        raise BigBlueButton::BigBlueButtonException.new("Impossible to convert XML to hash. Error: #{e.message}")
      end
    end 

    def xml_node_to_hash(node) 
      # If we are at the root of the document, start the hash 
      if node.element?
        result_hash = {}
        if node.attributes != {}
          result_hash[:attributes] = {}
          node.attributes.keys.each do |key|
            result_hash[:attributes][node.attributes[key].name.to_sym] = prepare(node.attributes[key].value)
          end
        end
        if node.children.size > 0
          node.children.each do |child| 
            result = xml_node_to_hash(child) 

            if child.name == "text"
              unless child.next_sibling || child.previous_sibling
                return prepare(result)
              end
            elsif result_hash[child.name.to_sym]
              if result_hash[child.name.to_sym].is_a?(Object::Array)
                result_hash[child.name.to_sym] << prepare(result)
              else
                result_hash[child.name.to_sym] = [result_hash[child.name.to_sym]] << prepare(result)
              end
            else 
              result_hash[child.name.to_sym] = prepare(result)
            end
          end

          return result_hash 
        else 
          return result_hash
        end 
      else 
        return prepare(node.content.to_s) 
      end 
    end          

    def prepare(data)
      (data.class == String && data.to_i.to_s == data) ? data.to_i : data
    end
  end
  
  def to_struct(struct_name)
      Struct.new(struct_name,*keys).new(*values)
  end
end
