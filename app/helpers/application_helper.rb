module ApplicationHelper
  
  # limit number of words beeing displayed.
  #
  def limit_words(txt, num)
    txt.split(" ")[0..num-1].join(" ")
  end
  
end
