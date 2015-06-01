class Tile
  
  attr_accessor :num_neighbors

  def initialize(mine) #mine is a boolean
    @mine = mine
  end

  def inspect
    return "*" if @mine
    "-"
  end

end
