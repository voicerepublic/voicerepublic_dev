describe IcecastApi do
  let(:app) { ->(env) {[200, {}, []]} }
  let(:request) { Rack::MockRequest.new(IcecastApi.new(app, {})) }

  it 'should fail with invalid client token' do
    payload = { client_token: 'xyz',
                public_ip_address: '0.0.0.0',
                mount_point: SecureRandom.uuid }
    response = request.post('/icecast/complete', input: JSON.unparse(payload))
    expect(response.status).to eq(404)
  end

  context 'with venue' do
    it 'should successfully update venue' do
      venue = FactoryGirl.create(:venue, :provisioning)
      payload = { client_token: venue.client_token,
                  public_ip_address: '1.2.3.4' }
      response = request.post('/icecast/complete', input: JSON.unparse(payload))
      expect(response.status).to eq(200)
      expect(venue.reload.public_ip_address).to eq('1.2.3.4')
    end

    it 'should successfully update venue on connect' do
      venue = FactoryGirl.create(:venue, :ready)
      payload = { client_token: venue.client_token }
      response = request.post('/icecast/connect', input: JSON.unparse(payload))
      expect(response.status).to eq(200)
      expect(venue.reload).to be_connected
    end

    it 'should successfully update venue on disconnect' do
      venue = FactoryGirl.create(:venue, :connected)
      payload = { client_token: venue.client_token }
      response = request.post('/icecast/disconnect', input: JSON.unparse(payload))
      expect(response.status).to eq(200)
      expect(venue.reload).to be_disconnected
    end
  end

end
