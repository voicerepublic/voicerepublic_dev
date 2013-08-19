module SearchHelper
  
  def hash_by_kluuu_type(arr)
    a,b = [],[]
    arr.each { |x| x.instance_of?(Venue) ? a.push(x) : b.push(x) }
    #[a,b]
    { :kluuu => a, :no_kluuu => b }
  end
  
end
