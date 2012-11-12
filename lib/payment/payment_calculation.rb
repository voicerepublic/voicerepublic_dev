require 'spec_helper'


module Payment
  module Calculation
    
    #TODO: Further DRY of fix price and minute price
    def Calculation.fix_price(video_session)
      #Percents for KluuU
      kluuu_percentage = 19
      
      #look for Moderator Participant
      moderator = video_session.host_participant
      publisher = video_session.guest_participant
      
      #calculate the period the participant effectively has to pay                  
      pay_period = Calculation.pay_period(video_session, moderator, publisher)
      
      #if there is anything to pay
      if pay_period > 0
        
        #retrieve users
        publisher_user = publisher.user     
        moderator_user = moderator.user
        kluuu_user = User.find_by_email("admin@kluuu.com")
                                
        #round to full minutes
        payment_duration = (pay_period.to_f / 60).ceil
                  
        if publisher.pay_tick_counter < 1
          #The publishers charge is the klus charge
          publisher_charge =  video_session.klu.charge
                    
          #set default exchange rates for all parties
          #because first balance is consumed and then revenue and the video session may last longer than the credit of the participant
          real_payment_amount = Calculation.payment_deduction_from_publisher_user_balance_account(publisher_user, publisher_charge)
          
          #in case the user doesnt have enough credit to pay the full amount (eg the moderator continued with the meeting even if the participant didnt have money any more)
          publisher_charge = real_payment_amount
          #in the Transfers it should be shown as negative
          publisher_charge = publisher_charge * (-1)
           
          #moderator netto income
          moderator_gain = Calculation.payment_incoming_for_moderator_user_balance_account(moderator_user, real_payment_amount, kluuu_percentage)
          #moderator gross income
          moderator_gross = real_payment_amount.exchange_to(moderator_user.balance_account.currency)
          
          #kluuu netto income
          kluuu_gain = Calculation.payment_incoming_for_kluuu_user_balance_account(kluuu_user, real_payment_amount, kluuu_percentage)
          #kluuu gross income
          kluuu_gross = real_payment_amount.exchange_to(kluuu_user.balance_account.currency)                    
        end 
                  
        Calculation.create_transfers(video_session, publisher,
                                        publisher_user, moderator_user, kluuu_user, 
                                        publisher_charge, 
                                        moderator_gain, moderator_gross, 
                                        kluuu_gain, kluuu_gross,
                                        payment_duration)
                                            
        ActiveRecord::Base.transaction do
          raise "participant user cannot be saved" if !publisher_user.save!
          raise "participant cannot be saved" if !publisher.save!
          raise "moderator user cannot be saved" if !moderator_user.save!
          raise "kluuu user cannot be saved" if !kluuu_user.save!
        end
      end
    end  
    
    def Calculation.minute_price(video_session)
      #Percents for KluuU
      kluuu_percentage = 19
      
      #look for Moderator Participant
      moderator = video_session.host_participant
      publisher = video_session.guest_participant
      
      #calculate the period the participant effectively has to pay                  
      pay_period = Calculation.pay_period(video_session, moderator, publisher)
      
      #if there is anything to pay
      if pay_period > 0
        
        #retrieve users
        publisher_user = publisher.user     
        moderator_user = moderator.user
        kluuu_user = User.find_by_email("admin@kluuu.com")
                                
        #round to full minutes
        payment_duration = (pay_period.to_f / 60).ceil
                  
        #The publishers charge is the payment_duration multiplied with the klus charge
        publisher_charge =  video_session.klu.charge * payment_duration
                  
        #set default exchange rates for all parties
        #because first balance is consumed and then revenue and the sezzion may last longer than the credit of the participant
        real_payment_amount = Calculation.payment_deduction_from_publisher_user_balance_account(publisher_user, publisher_charge)
        
        #in case the user doesnt have enough credit to pay the full amount (eg the moderator continued with the meeting even if the participant didnt have money any more)
        publisher_charge = real_payment_amount
        #in the Transfers it should be shown as negative
        publisher_charge = publisher_charge * (-1)
         
        #moderator netto income
        moderator_gain = Calculation.payment_incoming_for_moderator_user_balance_account(moderator_user, real_payment_amount, kluuu_percentage)
        #moderator gross income
        moderator_gross = real_payment_amount.exchange_to(moderator_user.balance_account.currency)
        
        #kluuu netto income
        kluuu_gain = Calculation.payment_incoming_for_kluuu_user_balance_account(kluuu_user, real_payment_amount, kluuu_percentage)
        #kluuu gross income
        kluuu_gross = real_payment_amount.exchange_to(kluuu_user.balance_account.currency)
        
        Calculation.create_transfers(video_session, publisher,
                                        publisher_user, moderator_user, kluuu_user, 
                                        publisher_charge, 
                                        moderator_gain, moderator_gross, 
                                        kluuu_gain, kluuu_gross,
                                        payment_duration)
                    
        
                    
        ActiveRecord::Base.transaction do
          raise "participant user cannot be saved" if !publisher_user.save!
          raise "participant cannot be saved" if !publisher.save!
          raise "moderator cannot be saved" if !moderator_user.save!
          raise "kluuu cannot be saved" if !kluuu_user.save!
        end
        
        Rails.logger.info("############################################################################################")
        Rails.logger.info("New Publisher transfer #{publisher_user.balance_account.transfers.last.inspect}")
        Rails.logger.info("New Publisher Balance Account Values - Balance: #{publisher_user.balance_account.balance.inspect}, Revenue: #{publisher_user.balance_account.revenue.inspect}")
        Rails.logger.info("############################################################################################")
        Rails.logger.info("############################################################################################")
        Rails.logger.info("New Moderator transfer #{moderator_user.balance_account.transfers.last.inspect}")
        Rails.logger.info("New Moderator Balance Account Values - Balance: #{moderator_user.balance_account.balance.inspect}, Revenue: #{moderator_user.balance_account.revenue.inspect}")
        Rails.logger.info("############################################################################################")
        Rails.logger.info("############################################################################################")
        Rails.logger.info("New KluuU transfer #{kluuu_user.balance_account.transfers.last.inspect}")
        Rails.logger.info("New KluuU Balance Account Values - Balance: #{kluuu_user.balance_account.balance.inspect}, Revenue: #{kluuu_user.balance_account.revenue.inspect}")
        Rails.logger.info("############################################################################################")
      end      
    end
    
    def Calculation.create_transfers(video_session, publisher,
                                        publisher_user, moderator_user, kluuu_user, 
                                        publisher_charge, 
                                        moderator_gain, moderator_gross, 
                                        kluuu_gain, kluuu_gross,
                                        payment_duration)
                                        
      existing_transfer = publisher_user.balance_account.transfers.find_by_video_session_id(video_session.id)
                      
      if existing_transfer.nil?
        
        #PUBLISHER-Konto Transaktion
        publisher_user.balance_account.transfers << Transfer.create!(:video_session_klu_name => video_session.klu.title, :video_session_id => video_session.id, :duration => payment_duration, :video_session_charge => video_session.klu.charge, :transfer_gross => publisher_charge, :transfer_charge => publisher_charge, :exchange_rate => Calculation.get_custom_exchange_rate(publisher_charge.currency.iso_code, publisher_user.balance_account.currency))
                                              
        #MODERATOR-Konto Transaktion
        moderator_user.balance_account.transfers << Transfer.create!(:video_session_klu_name => video_session.klu.title, :video_session_id => video_session.id, :duration => payment_duration, :video_session_charge => video_session.klu.charge, :transfer_gross => moderator_gross, :transfer_charge => moderator_gain, :exchange_rate => Calculation.get_custom_exchange_rate(publisher_charge.currency.iso_code, moderator_user.balance_account.currency))
        
        #KLUUU-Konto Transaktion
        kluuu_user.balance_account.transfers << Transfer.create(:video_session_klu_name => video_session.klu.title, :video_session_id => video_session.id, :duration => payment_duration, :video_session_charge => video_session.klu.charge, :transfer_gross => kluuu_gross, :transfer_charge => kluuu_gain, :exchange_rate => Calculation.get_custom_exchange_rate(publisher_charge.currency.iso_code, kluuu_user.balance_account.currency))
                      
      else
        
        if video_session.klu.charge_type == "minute"
          payment_duration += existing_transfer.duration
          publisher_charge = publisher_charge + existing_transfer.transfer_charge
          existing_transfer.update_attributes(:duration => payment_duration, :transfer_gross => publisher_charge * (-1), :transfer_charge => publisher_charge)
                          
          #MODERATOR-Konto Transaktion
          existing_moderator_transfer = moderator_user.balance_account.transfers.find_by_video_session_id(video_session.id)
          payment_duration += existing_moderator_transfer.duration
          moderator_gain = moderator_gain + existing_moderator_transfer.transfer_charge
          moderator_gross = moderator_gross + existing_moderator_transfer.transfer_gross
          existing_moderator_transfer.update_attributes(:duration => payment_duration, :transfer_gross => moderator_gross, :transfer_charge => moderator_gain)
          
          #KLUUU-Konto Transaktion
          existing_kluuu_transfer = kluuu_user.balance_account.transfers.find_by_sezzion_id(sezzion.id)
          transfer_duration += existing_kluuu_transfer.duration
          kluuu_gain = kluuu_gain + existing_kluuu_transfer.transfer_charge
          kluuu_gross = kluuu_gross + existing_kluuu_transfer.transfer_gross
          existing_kluuu_transfer.update_attributes(:duration => payment_duration, :transfer_gross => kluuu_gross, :transfer_charge => kluuu_gain)
          
        else
        
          payment_duration += existing_transfer.duration
          existing_transfer.update_attribute(:duration, payment_duration)
                        
          existing_moderator_transfer = moderator_user.balance_account.transfers.find_by_video_session_id(video_session.id)
          payment_duration += existing_moderator_transfer.duration
          existing_moderator_transfer.update_attribute(:duration, payment_duration)
                        
          existing_kluuu_transfer = kluuu_user.balance_account.transfers.find_by_video_session_id(video_session.id)
          payment_duration += existing_kluuu_transfer.duration
          existing_kluuu_transfer.update_attribute(:duration, payment_duration)
        
        end                
      
      end
                    
      #set paytick timestamp and increase pay tick counter
      publisher.pay_tick_counter += 1
      publisher.last_pay_tick_timestamp = Time.now
      
    end   
    
    def Calculation.pay_period(video_session, moderator, publisher)
        
      #Gehen wir davon aus der Moderator hat sich noch nicht ausgeloggt
      moderator_end_timestamp = nil
         
      #Hat er sich bereits ausgeloggt, dann nutzen wir den Timestamp
      moderator_end_timestamp = moderator.left_timestamp unless moderator.left_timestamp.nil?
       
       #Wie lang war die pay period fue den gast
      publisher_timespan = publisher.payment_stopped_timestamp - publisher.payment_started_timestamp
     
      #start offset -> fall publisher vor moderator im chat war (nur theorethisch möglich aber sicher ist sicher)
       #if > 0 -> moderator came later | if < 0 publisher came later
      start_offset =  0
      if (moderator.entered_timestamp - publisher.payment_started_timestamp) > 0
        start_offset = moderator.entered_timestamp - publisher.payment_started_timestamp
      end
       
      #stop offset if moderator left before payment was stopped for publisher
      #if < 0 -> moderator went earlier |if > 0 publisher went earlier or payment was stopped
      end_offset = 0
      if (moderator_end_timestamp != nil) && ((moderator_end_timestamp - publisher.payment_stopped_timestamp) < 0)
        end_offset = publisher.payment_stopped_timestamp - moderator_end_timestamp
      end
       
      #Wie lange war der Nutzer effektiv mit dem Moderator in der Sezzion
      timespan_with_moderator = publisher_timespan - end_offset - start_offset
         
       #Wieviel Zeit ist von den Freiminuten noch uebrig?
      free_time = Calculation.free_time(video_session, publisher)    
       
      pay_period = 0  
      #Wieviel Zeit der Nutzer für die jetzige payment-start payment-stop spanne wirklich bezahlen muss 
      pay_period = timespan_with_moderator.seconds - free_time.seconds if (timespan_with_moderator.seconds > free_time.seconds)
     
      #Wieviel Zeit war der Nutzer dann insgesamt bereits mit dem Moderator zusammen online?
      publisher.seconds_online += timespan_with_moderator
     
      Rails.logger.info("############################################################################################")
      Rails.logger.info("########################### Spitting out some time variables ###############################")
      Rails.logger.info("###### moderator.entered_sezzion_timestamp - #{moderator.entered_timestamp.inspect} #################")
      Rails.logger.info("###### moderator_end_timestamp - #{moderator_end_timestamp.inspect} #################")
      Rails.logger.info("###### participant.entered_sezzion_timestamp - #{publisher.entered_timestamp} #################")
      Rails.logger.info("###### participant.left_sezzion_timestamp - #{publisher.left_timestamp} #################")
      Rails.logger.info("###### participant.payment_started_timestamp - #{publisher.payment_started_timestamp} #################")
      Rails.logger.info("###### participant.payment_stopped_timestamp - #{publisher.payment_stopped_timestamp} #################")
      Rails.logger.info("###### publisher_timespan - #{publisher_timespan} ############################")
      Rails.logger.info("###### timespan_with_moderator - #{timespan_with_moderator} #################")
      Rails.logger.info("###### participant.time_to_pay - #{free_time} ############################")
      Rails.logger.info("###### participant.pay_period - #{pay_period} #################")
      Rails.logger.info("###### participant.pay tick counter - #{publisher.pay_tick_counter} ############################")
      Rails.logger.info("###### participant.time_online - #{publisher.seconds_online} ############################")
      Rails.logger.info("############################################################################################")
     
      #IMPORTANT: reset payment_started_timestamp as indicator for a new payment period
      publisher.payment_started_timestamp = nil
      publisher.payment_stopped_timestamp = nil
     
      #return the amount of seconds that have to be paid       
      return pay_period 
    end
    
    def Calculation.free_time(video_session, publisher)
      if (publisher.pay_tick_counter == 0)
        if (publisher.seconds_online.seconds > 0) && (publisher.seconds_online.seconds < video_session.klu.free_time.minutes)
          ttp = video_session.klu.free_time.minutes - publisher.seconds_online.seconds
          return ttp
        elsif (publisher.seconds_online.seconds > video_session.klu.free_time.minutes)
          return 0
        elsif (publisher.seconds_online.seconds == 0)
          return (video_session.klu.free_time * 60)
        else
          raise 'Error in time to pay calculation > Payment::Calculation.time_to_pay in paytick_counter == 0'
        end
      #schauen ob der Nutzer bereits mehr Zeit bezahlt hat als er benutzt hat, 
      #notwendig für set_on_hold da sonst die reste der minutenabrechnung verloren gehen
      elsif (publisher.pay_tick_counter > 0)
        #dann hole ich mir die bereits vorgenommenen transfers
        transfers = publisher.user.balance_account.transfers.find_by_video_session_id(video_session.id)
        #die zeit die bei der letzten bezahlung noch übrig war 
        time_paid_overhead = (publisher.seconds_online.seconds - video_session.klu.free_time.minutes - transfer.duration.minutes) * (-1)
        #if time paid equals exactly time 
        if time_paid_overhead == 0
          return 0
        elsif time_paid_overhead > 0
          return time_paid_overhead 
        else
          raise 'Error in time to pay calculation > Payment::Calculation.time_to_pay in paytick_counter positive'
        end
      else 
        raise 'Error in time to pay calculation > Payment::Calculation.time_to_pay paytick_counter negative '
      end
    end
    
    def Calculation.payment_deduction_from_publisher_user_balance_account(user, charge)
    
      #if the Klu has a different currency as the publisher then convert the charge to this currency
      charge = charge.exchange_to(user.balance_account.currency)  
      
      balance = user.balance_account.balance
      revenue = user.balance_account.revenue
   
      payment = Money.new(0,user.balance_account.currency)
      
      #if charge is smaller than than the users whole credit
      if ((charge <=> (balance + revenue)) < 0)
        
        #if charge is bigger than the users balance
        if ((charge <=> balance) > 0)
          
          payment = balance
        
          #whats left of the charge after nullifying the users balance
          overhead = charge - balance
        
          revenue = revenue - overhead  
          
          payment = payment + overhead
          
          user.balance_account.balance = Money.new(0,user.currency)
          user.balance_account.revenue = revenue
        
          return payment

        #if charge is smaller than the users balance
        else
          
          balance = balance - charge
          
          user.balance_account.balance = balance
          
          payment = charge
          
          return payment          
        end
        
      #if charge is bigger than than the users whole credit
      else
      
        payment = balance + revenue;
      
        user.balance_account.balance = Money.new(0,user.currency)
        user.balance_account.revenue = Money.new(0,user.currency)
      
        return payment
      end
    end
    
    def Calculation.payment_incoming_for_kluuu_user_balance_account(user, charge, kluuu_percentage)
      
      charge = charge.exchange_to(user.balance_account.currency)
     
      incoming_payment = charge * kluuu_percentage/100
     
      user.balance_account.revenue = user.balance_account.revenue + incoming_payment
      
      return incoming_payment
    end
    
    def Calculation.payment_incoming_for_moderator_user_balance_account(user, charge, kluuu_percentage)
      
      charge = charge.exchange_to(user.balance_account.currency)
      
      incoming_payment = charge - (charge * kluuu_percentage/100)
      
      user.balance_account.revenue = user.balance_account.revenue + incoming_payment
      
      return incoming_payment
    end
    
    def Calculation.get_custom_exchange_rate(from_currency, to_currency)
      custom_rate = Money.default_bank.get_rate(from_currency, to_currency)
      
      #if there was no direct conversion possible
      unless custom_rate
        from_base_rate = Money.default_bank.get_rate("EUR", from_currency)
        to_base_rate = Money.default_bank.get_rate("EUR", to_currency)
        custom_rate = to_base_rate / from_base_rate
      end
      
      Rails.logger.info("############################################################################################")
      Rails.logger.info("########################### exchange rate  ###############################")
      Rails.logger.info("###### Rate after conversion - #{custom_rate.inspect} #################")
      Rails.logger.info("############################################################################################")
      
      return custom_rate
    end
  end
end