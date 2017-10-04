require 'rails_helper'
describe Prapi::JobsController do

  it 'returns an empty job list' do
    get :index
    expect(response.status).to be(200)
    data = JSON.parse(response.body)
    expect(data.length).to be(0)
  end

  describe 'with one job' do

    let(:job) { FactoryGirl.create :job }

    it 'returns json' do
      job # access job for it to be created
      get :index
      expect(response.status).to be(200)
      data = JSON.parse(response.body)
      expect(data.length).to be(1)
    end

    it 'allows to claim a job' do
      put :update, id: job.id, job: {event: 'start', locked_by: 'asdf'}
      expect(response.status).to be(200)
    end

    it 'cannot be started twice' do
      put :update, id: job.id, job: {event: 'start', locked_by: 'asdf'}
      expect(response.status).to be(200)
      put :update, id: job.id, job: {event: 'start', locked_by: 'asdf'}
      expect(response.status).to be(409)
    end

    it 'follows the life cycle' do
      expect(job.state).to eq('pending')
      put :update, id: job.id, job: {event: 'start', locked_by: 'asdf'}
      expect(response.status).to be(200)
      expect(job.reload.state).to eq('running')
      put :update, id: job.id, job: {event: 'complete', locked_by: 'asdf'}
      expect(response.status).to be(200)
      expect(job.reload.state).to eq('completed')
    end

  end

end
