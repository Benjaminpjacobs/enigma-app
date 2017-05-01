module MessageIO

  
  def parse(message)
    message.split('')
  end
  
  def split_into_sub_arrays(message)
    message.each_slice(4).to_a
  end
  

end