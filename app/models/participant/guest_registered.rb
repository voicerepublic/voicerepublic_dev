class Participant::GuestRegistered < Participant::Base
  
  belongs_to :video_session, :class_name => 'VideoSession::Registered'
  belongs_to :user
  
  attr_accessible :last_pay_tick_timestamp, :pay_tick_counter, :payment_started_timestamp, :payment_stopped_timestamp, :seconds_online, :user_id
  
  after_update :payment, :unless => Proc.new { |p| p.payment_started_timestamp.nil? }
  
  validates_presence_of :user_id
  
  def create_link(video_room)
    self.room_url = video_room.join_url(self.user.firstname, self.video_session_role.to_sym, self.user_id)
  end
  
  def payment
  
  def pay()
    
   video_session = self.video_session
       
   if (video_session.klu.get_charge_type_as_integer == 2)  # wenn minutenpreis
         
     Pament::Calculation.minute_price(video_session) if (!self.payment_started_timestamp.nil?)
           
           
       
        elsif (sezzion.tariff_type == 3) #fixpreis
          
          if (!self.payment_started_timestamp.nil?)
           
           #look for Moderator Participant
           moderator = sezzion.participants.find_by_user_sezzion_role(1)
            
           #calculate the period the participant effectively has to pay                  
           pay_period = calculate_pay_period(sezzion, moderator)
           
           
           if pay_period > 0
                  
                  #PUBLISHER-Konto Transaktion
                  participantUser = self.user 
                  
                  transaction_duration = (pay_period.to_f / 60).ceil
                  
                  #calculate the different charges and gains per user
                  publisher_charge = sezzion.charge #+ (self.publisher_percentage/100 * self.charge)
                  
                  exchange_rate_publisher = 1
                  exchange_rate_moderator = 1
                  exchange_rate_kluuu = 1
                      
                    
                  if (publisher_charge.currency.iso_code != participantUser.currency)
                    exchange_rate_publisher = get_custom_rate(publisher_charge.currency.iso_code, participantUser.currency)
                    publisher_charge = publisher_charge.exchange_to(participantUser.currency)
                  end
                  
                  #because first balance is consumed and then revenue and user may stay longer in chat as credit lasts
                  payment = payment_deduction(participantUser, publisher_charge)
                  
                  raise "payment cannot process payment in balance and revenue fields" if payment == -1

                  if ((payment <=> Money.new(0,payment.currency)) > 0)
                    
                    #retrieve kluuu_user
                    kluuu = User.find_by_login("kluuu")
                     
                    publisher_charge = payment
                    
                    #initialize variables
                    moderator_gain = Money.new(0,moderator.user.currency)
                    moderator_gross = Money.new(0,moderator.user.currency)
                    kluuu_gain = Money.new(0,kluuu.currency)
                    kluuu_gross = Money.new(0,kluuu.currency)
                    
                    #Moderator only offers Kluus in his own currency
                    if payment.currency.iso_code != moderator.user.currency
                      tmp_payment = payment.exchange_to(moderator.user.currency)
                      moderator_gain = tmp_payment - (tmp_payment * sezzion.moderator_percentage/100)
                      moderator_gross = payment
                      logger.info("############################################################################################")
                      logger.info("################################### Looking Up Exchange Rate ###############################")
                      exchange_rate_moderator = get_custom_rate(payment.currency.iso_code, moderator.user.currency)
                      logger.info("###### ISO Code: participant - #{participantUser.account.currency.inspect} #################")
                      logger.info("###### ISO Code: payment - #{payment.currency.iso_code.inspect} ############################")
                      logger.info("###### ISO Code: sezzion - #{tmp_payment.currency.iso_code.inspect} ############################")
                      logger.info("################## Exchange Rate: #{exchange_rate_moderator.inspect} #################################")
                      logger.info("###### ISO Code: moderator - #{moderator.user.currency.inspect} ############################")
                      logger.info("###### ISO Code: kluuu - #{kluuu.currency.inspect} #########################################")
                      logger.info("############################################################################################")  
                    else
                      logger.info("############################################################################################")
                      logger.info("################################### Looking Up Exchange Rate ###############################")
                      logger.info("###### ISO Code: participant - #{participantUser.account.currency.inspect} #################")
                      logger.info("###### ISO Code: payment - #{payment.currency.iso_code.inspect} ############################")
                      logger.info("###### ISO Code: publisher_charge - #{publisher_charge.currency.iso_code.inspect} #################")
                      logger.info("###### ISO Code: sezzion_charge - #{sezzion.charge.currency.iso_code.inspect} ############################")
                      logger.info("################## Exchange Rate: #{exchange_rate_moderator.inspect} #################################")
                      logger.info("###### ISO Code: moderator - #{moderator.user.currency.inspect} ############################")
                      logger.info("###### ISO Code: kluuu - #{kluuu.currency.inspect} #########################################")
                      logger.info("############################################################################################")
                      moderator_gain = payment - (payment * sezzion.moderator_percentage/100)
                      moderator_gross = payment
                    end
                    
                    #theorethically kluuu needs to store the exchage_rate from moderator to kluuu AND payment to kluuu
                    
                    if (payment.currency.iso_code != kluuu.currency) && (moderator.user.currency != kluuu.currency)
                      exchange_rate_kluuu = get_custom_rate(moderator_gain.currency.iso_code, kluuu.currency)
                      tmp_payment = payment.exchange_to(kluuu.currency)
                      kluuu_moderator_gain = moderator_gain.exchange_to(kluuu.currency)
                      kluuu_gross = payment
                      kluuu_gain = (tmp_payment - kluuu_moderator_gain).exchange_to(kluuu.currency)
                    elsif (payment.currency.iso_code != kluuu.currency) && (moderator.user.currency == kluuu.currency)
                      tmp_payment = payment.exchange_to(kluuu.currency)
                      kluuu_gross = payment
                      kluuu_gain = (tmp_payment - moderator_gain).exchange_to(kluuu.currency)
                    elsif (payment.currency.iso_code == kluuu.currency) && (moderator.user.currency != kluuu.currency)
                      exchange_rate_kluuu = get_custom_rate(payment.currency.iso_code, kluuu.currency)
                      kluuu_moderator_gain = moderator_gain.exchange_to(kluuu.currency)
                      kluuu_gain = (payment - kluuu_moderator_gain).exchange_to(kluuu.currency)
                      kluuu_gross = payment
                    else
                      kluuu_gain = payment - moderator_gain
                      kluuu_gross = payment
                    end
                    
                    logger.info("############################################################################################")
                    logger.info("########################### Spitting out some more variables ###############################")
                    logger.info("###### sezzion_charge - #{sezzion.charge.format} #################")
                    logger.info("###### sezzion_free_time - #{(sezzion.time_to_pay * 60).inspect} #################")
                    logger.info("###### transaction_duration - #{(transaction_duration * 60).inspect} #################")
                    logger.info("###### pay_period - #{(pay_period).inspect} #################")
                    logger.info("###### publisher_time_online - #{(self.time_online).inspect} #################")
                    logger.info("###### publisher_charge - #{publisher_charge.format} #################")
                    logger.info("###### moderator_gain - #{moderator_gain.format} ############################")
                    logger.info("###### moderator_gross - #{moderator_gross.format} #################")
                    logger.info("###### kluuu_gain - #{kluuu_gain.format} ############################")
                    logger.info("###### kluuu_gross - #{kluuu_gross.format} #################")
                    logger.info("###### exchange_rate_moderator - #{exchange_rate_moderator.inspect} ############################")
                    logger.info("###### exchange_rate_publisher - #{exchange_rate_publisher.inspect} ############################")
                    logger.info("###### exchange_rate_kluuu - #{exchange_rate_kluuu.inspect} ############################")
                    logger.info("############################################################################################")
                    
                    existing_transaction = nil
                    #logger.info("############################################################################################")
                    existing_transaction = participantUser.account.transactions.find_by_sezzion_id(sezzion.id)
                    #logger.info("Publisher User #{participantUser.inspect}; Publisher existing Transaction?: #{existing_transaction.inspect} ")
                    #logger.info("############################################################################################")
                        
                      if (existing_transaction.nil?) && (self.pay_tick_counter < 1)
                        
                        #PUBLISHER-Konto Transaktion
                        publisher_transaction = Transaction.create(:sezzion_id => sezzion.id, :duration => transaction_duration, :sezzion_type => sezzion.sezzion_type, :tariff_type => sezzion.tariff_type, :sezzion_charge => sezzion.charge, :transaction_gross => publisher_charge, :transaction_charge => (publisher_charge - (publisher_charge * 2)), :exchange_rate => exchange_rate_publisher)
                        participantUser.account.transactions << publisher_transaction
                        logger.info("############################################################################################")
                        logger.info("Publisher Transaction updated #{publisher_transaction.inspect}")
                        logger.info("############################################################################################")
                        
                        #MODERATOR-Konto Transaktion
                        #logger.info("############################################################################################")
                        moderatorUser = User.find_by_id(moderator.user_id)
                        #logger.info("############################################################################################")
                        #logger.info("Moderator User #{moderatorUser.inspect}; Moderator Revenue #{moderatorUser.account.revenue.format} ")
                        moderatorUser.account.revenue = moderatorUser.account.revenue + moderator_gain
                        #logger.info("############################################################################################")
                        #logger.info("After summing up Moderator Revenue #{moderatorUser.account.revenue.format} ")
                        transaction = Transaction.create(:sezzion_id => sezzion.id, :duration => transaction_duration, :sezzion_type => sezzion.sezzion_type, :tariff_type => sezzion.tariff_type, :sezzion_charge => sezzion.charge, :transaction_gross => moderator_gross, :transaction_charge => moderator_gain, :exchange_rate => exchange_rate_moderator)
                        logger.info("############################################################################################")
                        logger.info("Moderator Transaction created #{transaction.inspect}")
                        moderatorUser.account.transactions << transaction
                        logger.info("############################################################################################")
                        #logger.info("All Transactions of User #{moderatorUser.account.transactions.find(transaction.id)}")
                        #Transaction.create(:sezzion_id => sezzion.id, :duration => transaction_duration, :sezzion_type => sezzion.sezzion_type, :tariff_type => sezzion.tariff_type, :sezzion_charge => sezzion.charge, :value => moderator_gain)
                        #logger.info("############################################################################################")
                        #KLUUU-Konto Transaktion
                        #logger.info("############################################################################################")
                        #logger.info("############################################################################################")
                        #logger.info("KluuU User #{kluuu.inspect}; KluuU Revenue #{kluuu.account.revenue} ")
                        kluuu.account.revenue = kluuu.account.revenue + kluuu_gain
                        #logger.info("############################################################################################")
                        #logger.info("After summing up KluuU Revenue #{kluuu.account.revenue}")
                        kluuu_transaction = Transaction.create(:sezzion_id => sezzion.id, :duration => transaction_duration, :sezzion_type => sezzion.sezzion_type, :tariff_type => sezzion.tariff_type, :sezzion_charge => sezzion.charge, :transaction_gross => kluuu_gross, :transaction_charge => kluuu_gain, :exchange_rate => exchange_rate_kluuu)
                        logger.info("############################################################################################")
                        logger.info("KluuU Transaction created #{kluuu_transaction.inspect}")
                        kluuu.account.transactions << kluuu_transaction
                        logger.info("############################################################################################")
                        #logger.info("All Transactions of User #{kluuu.account.transactions.find(kluuu_transaction.id)}")
                        
                      else
                        
                        transaction_duration += existing_transaction.duration
                        existing_transaction.update_attribute(:duration, transaction_duration)
                        logger.info("############################################################################################")
                        logger.info("Publisher Transaction updated #{existing_transaction.inspect}")
                        logger.info("############################################################################################")
                        #MODERATOR-Konto Transaktion
                        #logger.info("############################################################################################")
                        moderatorUser = User.find_by_id(moderator.user_id)
                        #logger.info("############################################################################################")
                        #logger.info("Moderator User #{moderatorUser.inspect}; Moderator Revenue #{moderatorUser.account.revenue.format} ")
                        #logger.info("############################################################################################")
                        #logger.info("After summing up Moderator Revenue #{moderatorUser.account.revenue} ")
                        #puts moderatorUser.inspect
                        existing_moderator_transaction = moderatorUser.account.transactions.find_by_sezzion_id(sezzion.id)
                        #puts existing_moderator_transaction.inspect
                        transaction_duration += existing_moderator_transaction.duration
                        #puts transaction_duration
                        existing_moderator_transaction.update_attribute(:duration, transaction_duration)
                        #puts "After Moderator Transaction update"
                        logger.info("############################################################################################")
                        logger.info("Moderator Transaction updated #{existing_moderator_transaction.inspect}")
                        logger.info("############################################################################################")
                        #logger.info("All Transactions of User #{moderatorUser.account.transactions.find(transaction.id)}")
                        #Transaction.create(:sezzion_id => sezzion.id, :duration => transaction_duration, :sezzion_type => sezzion.sezzion_type, :tariff_type => sezzion.tariff_type, :sezzion_charge => sezzion.charge, :value => moderator_gain)
                        #logger.info("############################################################################################")
                        #KLUUU-Konto Transaktion
                        #logger.info("############################################################################################")
                        kluuu = User.find_by_login("kluuu")
                        #logger.info("############################################################################################")
                        #logger.info("KluuU User #{kluuu.inspect}; KluuU Revenue #{kluuu.account.revenue.format} ")
                        #logger.info("############################################################################################")
                        #logger.info("After summing up KluuU Revenue #{kluuu.account.revenue}")
                        existing_kluuu_transaction = kluuu.account.transactions.find_by_sezzion_id(sezzion.id)
                        transaction_duration += existing_kluuu_transaction.duration
                        existing_kluuu_transaction.update_attribute(:duration, transaction_duration)
                        #puts "After Moderator Transaction update"
                        logger.info("############################################################################################")
                        logger.info("KluuU Transaction updated #{existing_kluuu_transaction.inspect}")
                        logger.info("############################################################################################")
                        
                        #logger.info("All Transactions of User #{kluuu.account.transactions.find(kluuu_transaction.id)}")
                      end
                
                    self.pay_tick_counter += 1
                    self.last_pay_tick_timestamp = Time.now
                    
                    ActiveRecord::Base.transaction do
                      raise "participant cannot be saved" if !participantUser.save!  
                      raise "moderator cannot be saved" if !moderatorUser.save!
                      raise "kluuu cannot be saved" if !kluuu.save!
                    end
                  end 
              end
          end  
        end  
      end  
 end
 
    
  end
  
end
