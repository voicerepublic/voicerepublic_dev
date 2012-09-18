module BookmarksHelper
  
  def partial_for(bookmark)
    if bookmark.kluuu.nil?  # if nil its a no_kluuu
      render(:partial => "klus/medium_no_kluuu", :locals => {:medium_no_kluuu => bookmark.no_kluuu })
    else
      render(:partial => "klus/medium_kluuu", :locals => {:medium_kluuu => bookmark.kluuu })
    end
  end
  
end
