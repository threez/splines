require "rubygems"
require 'rmagick'
include Magick

class Graph < Magick::Draw
  attr_accessor :image_width, :image_height, :spacing
  
  def initialize(width, height, spacing = 10)
    super() # initialize the rmagick Draw
    @image = Image.new(width, height, Magick::HatchFill.new('white', 'gray90')) do
      self.background_color = "gray20"
    end
    @image_width = @image.columns
    @image_height = @image.rows
    @spacing = 10
  end

  def arrow_up(x, y, size = @spacing)
    polyline(x, y, 
             x + @spacing / 3, y + @spacing,
             x - @spacing / 3, y + @spacing)
  end
  
  def arrow_right(x, y, size = @spacing)
    polyline(x, y, 
             x - @spacing, y + @spacing / 3,
             x - @spacing, y - @spacing / 3)
  end
  
  def grid()
    # y 
    line(@spacing, @spacing, @spacing, @image_height - @spacing)
    arrow_up(@spacing, @spacing)
    text(1.5 * @spacing, @spacing+1, "y")
    
    # x
    line(@spacing, @image_height - @spacing, @image_width - @spacing, @image_height - @spacing)
    arrow_right(@image_width - @spacing, @image_height - @spacing)
    text(@image_width - @spacing*1.5, @image_height - 1.5 * @spacing, "x")
  end

  def functions(&block) 
    #push # save context
    
    # draw helperlines
    stroke('black')
    grid
    
    # clipping setup for soft borders using +1 -1
    define_clip_path("default") {
      rectangle(@spacing-1, @image_height - @spacing+1, @image_width - @spacing+1, @spacing-1)
    }
    clip_path('default')
    
    # draw functions
    instance_eval(&block)
    #pop # return context
  end
  
  def spline(*values)
    start_y = values.shift
    x = @spacing * 7
    values.each do |y|
      line(x, @image_height - start_y, x + @spacing * 7, @image_height - y)
      x += @spacing * 7
      start_y = y
    end
  end

  def f(&block)
    sx, sy = 0, 0
    (0..@image_width).each do |x|
      y = block.call(x)
      line(sx + @spacing, @image_height - sy - @spacing, 
            x + @spacing, @image_height -  y - @spacing)
      sx, sy = x, y
    end
  end
  
  def write(path)
    draw @image
    @image.write path
  end
end
