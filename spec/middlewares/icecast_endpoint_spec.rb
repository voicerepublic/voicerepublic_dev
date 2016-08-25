require 'rails_helper'

describe IcecastEndpoint do
  let(:app) { ->(env) {[200, {}, []]} }
  let(:request) { Rack::MockRequest.new(IcecastEndpoint.new(app, {})) }

  it 'should fail with invalid client token' do
    response = request.post('/icecast/complete/bielefeld')
    expect(response.status).to eq(404)
  end

  context 'with venue' do
    it 'should fail with invalid action' do
      venue = FactoryGirl.create(:venue, :provisioning)
      response = request.post("/icecast/bielefeld/#{venue.client_token}")
      expect(response.status).to eq(721)
    end

    it 'should receive stats' do
      venue = FactoryGirl.create(:venue, :provisioning)
      response = request.post("/icecast/stats/#{venue.client_token}")
      expect(response.status).to eq(200)
    end

    it 'should successfully update venue' do
      venue = FactoryGirl.create(:venue, :provisioning)
      payload = { public_ip_address: '1.2.3.4' }
      response = nil
      VCR.use_cassette 'icecast_complete' do
        response = request.post("/icecast/ready/#{venue.client_token}",
                                input: JSON.unparse(payload))
      end
      expect(response.status).to eq(200)
      expect(venue.reload.public_ip_address).not_to be_nil
      #venue.destroy # in one of these...
    end

    it 'should successfully update venue on connect' do
      venue = FactoryGirl.create(:venue, :awaiting_stream)
      response = nil
      VCR.use_cassette 'icecast_connect' do
        response = request.post("/icecast/connect/#{venue.client_token}")
      end
      expect(response.status).to eq(200)
      expect(venue.reload).to be_connected
      venue.destroy # ...cases database cleaner...
    end

    it 'should successfully update venue on disconnect' do
      venue = FactoryGirl.create(:venue, :connected)
      response = nil
      VCR.use_cassette 'icecast_disconnect' do
        response = request.post("/icecast/disconnect/#{venue.client_token}")
      end
      expect(response.status).to eq(200)
      expect(venue.reload).to be_disconnected
      #venue.destroy # ...is not working.
    end
  end

end
