require 'rails_helper'

describe Transaction do
  it 'goes with the flow' do
    transaction = Transaction.create
    expect(transaction).to be_pending
    transaction.start!
    expect(transaction).to be_processing
    expect(transaction.processed_at).not_to be_present
    transaction.close!
    expect(transaction).to be_closed
    expect(transaction.processed_at).to be_present
  end
end

describe PurchaseTransaction do
  it 'processes nicely' do
    transaction = FactoryGirl.create(:purchase_transaction)
    expect(transaction).to be_pending
    transaction.process!
    expect(transaction).to be_closed
  end
end

describe ManualTransaction do
  it 'processes nicely' do
    user = FactoryGirl.create(:user)
    details = { user_id: user.id, quantity: 42 }
    transaction = ManualTransaction.create(details: details)
    expect(transaction).to be_pending
    transaction.process!
    expect(transaction).to be_closed
    expect(user.reload.credits).to eq(details[:quantity] +
                                      WelcomeTransaction::QUANTITY)
  end
end
