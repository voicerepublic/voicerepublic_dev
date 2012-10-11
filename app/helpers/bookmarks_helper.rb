module BookmarksHelper
  
  def partial_for_bookmark(bookmark)
    if bookmark.kluuu.nil?  # if nil its a no_kluuu
      render(:partial => "klus/small_no_kluuu", :locals => {:klu => bookmark.no_kluuu })
    else
      render(:partial => "klus/small_kluuu", :locals => {:klu => bookmark.kluuu })
    end
  end
  
end
