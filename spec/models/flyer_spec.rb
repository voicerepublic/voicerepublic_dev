require 'spec_helper'

describe Flyer do

  describe 'built' do
    before do
      talk_stub = OpenStruct.new
      talk_stub.id = 42
      talk_stub.title = 'In allen Gassen'
      talk_stub.starts_at = Time.now
      talk_stub.user = OpenStruct.new
      talk_stub.user.name = 'Hans Dampf'

      @flyer = Flyer.new(talk_stub)
    end
    after do
      # cleanup
      @flyer.disintegrate!
    end
    
    it 'generates a file' do
      expect(@flyer).not_to exist
      @flyer.generate!
      expect(@flyer).to exist
    end

    it 'replaces all interpolations' do
      svg = @flyer.svg_file.open.read
      expect(svg.match(/\[-[^-]+-\]/)).to be_nil
    end

    it 'uses all interpolations' do
      svg = File.read(@flyer.svg_template)
      @flyer.interpolations.each do |key, value|
        expect(svg).to include("[-#{key}-]")
      end
    end

    it 'provides a parsable template' do
      xml = File.read(@flyer.svg_template)
      doc =  Nokogiri::XML(xml)
      expect(doc.errors).to be_empty
    end

    it 'generates a png' do
      @flyer.generate!
      ident = %x[ identify #{@flyer.path(true)} ]
      expect(ident).to include('PNG')
    end
  end
    
end
