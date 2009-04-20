require "lib/graph"

graph = Graph.new(640, 480)
graph.functions do
  # define stroke behaviour
  #stroke_width 2
  #stroke_linecap('round')
  #stroke_linejoin('round')
  
  stroke('#3387CC') # blue
  f do |x|
    ((x/2) ** 3 + x ** 2) / 1000
  end

  stroke('#CC0000') # red
  f do |x|
    x ** 2 / 600
  end

  stroke('#65B042') # green
  f do |x|
    x ** 3 / 600
  end
  
  spline(70, 20, 80, 30, 35)
end

graph.write "./graph.png"
system "open ./graph.png"
