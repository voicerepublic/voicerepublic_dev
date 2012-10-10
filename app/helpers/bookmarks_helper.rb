module BookmarksHelper
  
  def partial_for_bookmark(bookmark)
    if bookmark.kluuu.nil?  # if nil its a no_kluuu
      render(:partial => "klus/medium_no_kluuu", :locals => {:klu => bookmark.no_kluuu })
    else
      render(:partial => "klus/medium_kluuu", :locals => {:klu => bookmark.kluuu })
    end
  end
  
end
