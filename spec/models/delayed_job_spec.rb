require 'spec_helper'

describe Delayed::Job do

  class TestClass
    def initialize
      @@queue ||= []
      @@queue << :something
    end
    def pop
      raise if @@queue.empty?
      @@queue.pop
    end
    def self.count
      @@queue.size
    end
  end

  before do
    @object = TestClass.new
  end

  it 'works without DJ' do
    expect(@object.pop).to be(:something)
  end

  it 'circumvents DJ in specs' do
    expect(Delayed::Worker.delay_jobs).to be(false)
    expect { @object.delay.pop }.to change(TestClass, :count).by(-1)
  end

  it 'works with DJ' do
    expect(Delayed::Worker.delay_jobs).to be(false)
    Delayed::Worker.delay_jobs = true
    expect { @object.delay.pop }.to_not change(TestClass, :count)
    expect { Delayed::Worker.new(:quiet => true).work_off(1) }.to change(TestClass, :count).by(-1)
    Delayed::Worker.delay_jobs = false
  end

end
