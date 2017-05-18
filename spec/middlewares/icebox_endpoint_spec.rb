require 'rails_helper'

describe IceboxEndpoint do
  let(:app) { ->(env) {[200, {}, []]} }
  let(:request) { Rack::MockRequest.new(IceboxEndpoint.new(app, {})) }

  it 'should fail with invalid client token' do
    response = request.post('/icebox/complete/bielefeld')
    expect(response.status).to eq(404)
  end

  context 'with venue' do
    it 'should fail with invalid action' do
      venue = FactoryGirl.create(:venue, :provisioning)
      response = request.post("/icebox/#{venue.client_token}/bielefeld")
      expect(response.status).to eq(721)
    end

    it 'should receive stats' do
      venue = FactoryGirl.create(:venue, :provisioning)
      response = nil
      VCR.use_cassette 'icebox stats' do
        response = request.post("/icebox/#{venue.client_token}/stats")
      end
      expect(response.status).to eq(200)
    end

    it 'should successfully update venue' do
      venue = FactoryGirl.create(:venue, :provisioning)
      payload = { public_ip_address: '1.2.3.4' }
      response = nil
      VCR.use_cassette 'icebox_complete' do
        response = request.post("/icebox/#{venue.client_token}/ready",
                                input: JSON.unparse(payload))
      end
      expect(response.status).to eq(200)
      expect(venue.reload.public_ip_address).not_to be_nil
      #venue.destroy # in one of these...
    end

    it 'should successfully update venue on connect' do
      venue = FactoryGirl.create(:venue, :awaiting_stream)
      response = nil
      VCR.use_cassette 'icebox_connect' do
        response = request.post("/icebox/#{venue.client_token}/connect")
      end
      expect(response.status).to eq(200)
      expect(venue.reload).to be_connected
      venue.destroy # ...cases database cleaner...
    end

    it 'should successfully update venue on disconnect' do
      venue = FactoryGirl.create(:venue, :connected)
      response = nil
      VCR.use_cassette 'icebox_disconnect' do
        response = request.post("/icebox/#{venue.client_token}/disconnect")
      end
      expect(response.status).to eq(200)
      expect(venue.reload).to be_disconnected
      #venue.destroy # ...is not working.
    end
  end

end
