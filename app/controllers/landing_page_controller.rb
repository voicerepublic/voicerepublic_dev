class LandingPageController < ApplicationController
  def index
    @kluuus = Kluuu.published.paginate(:page => params[:page], :per_page => 6).order("created_at DESC")
    @no_kluuus = NoKluuu.published.paginate(:page => params[:page], :per_page => 6).order("created_at DESC")
  end
  
  
  def show_tagged_with
    _klus = Klu.tagged_with(params[:tag])
    @kluuus = []
    @no_kluuus = []
    _klus.each { |klu| klu.instance_of?(Kluuu) ? @kluuus << klu : @no_kluuus << klu }
    render :action => 'index'
  end
  
end
