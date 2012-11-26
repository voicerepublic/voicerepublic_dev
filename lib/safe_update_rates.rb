class SafeUpdateRates
  
  def SafeUpdateRates.safe_save_rates
    begin 
      Money.default_bank.save_rates("tmp/exchange_rates/exchange_rates_tmp.xml")
      move("tmp/exchange_rates/exchange_rates_tmp.xml","tmp/exchange_rates/exchange_rates.xml")
      Rails.logger.info("#################### save rates SUCCESS ####################")
    rescue Exception => e
      Rails.logger.warn("###########################################################")
      Rails.logger.warn("#################### save rates FAILED ####################")
      Rails.logger.warn("####################### #{e.message} ######################")
      Rails.logger.warn("###########################################################")
    end
  end
  
  def SafeUpdateRates.safe_update_rates
    begin 
      Money.default_bank.update_rates("tmp/exchange_rates/exchange_rates.xml")
      Rails.logger.info("#################### update rates SUCCESS ####################")
    rescue Exception => e
      Rails.logger.warn("###########################################################")
      Rails.logger.warn("#################### update rates FAILED ##################")
      Rails.logger.warn("####################### #{e.message} ######################")
      Rails.logger.warn("###########################################################")
    end
  end
end