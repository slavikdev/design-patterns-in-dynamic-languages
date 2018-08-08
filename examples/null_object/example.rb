class Account
  def initialize(id)
    @id = id
  end

  def print
    puts @id
  end
end

class EmptyAccount < Account
  def initialize
    super('N/A')
  end
end