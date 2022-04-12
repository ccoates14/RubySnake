require 'ruby2d'

set title: "Snake"

class Snake
  @@body_unit_size = 25
  
  def initialize(grid, grid_unit_size=10)
    @grid_unit_size = grid_unit_size
    @grid = grid
    @head_x = @grid[0].length() / 2
    @head_y = @grid.length() / 2
    @head = Square.new(x: grid_unit_size * @head_x, y: grid_unit_size * @head_y,
       size: @@body_unit_size, color: 'blue')
    @body = [@head]

    @grid[@head_y][@head_x] = @head
  end

  def move_up
    next_grid_pos = @head_y - 1
    
    if next_grid_pos < 0
      next_grid_pos = @grid.length() - 1
    end

    @head_y = next_grid_pos

    @grid[@head_y][@head_x] = @head
    @head.y = @head_y * @grid_unit_size
  end

  def move_down
    next_grid_pos = @head_y + 1
    
    if next_grid_pos >= @grid.length()
      next_grid_pos = 0
    end

    @head_y = next_grid_pos

    @grid[@head_y][@head_x] = @head
    @head.y = @head_y * @grid_unit_size
  end

  def move_right
    next_grid_pos = @head_x + 1
    
    if next_grid_pos >= @grid[0].length()
      next_grid_pos = 0
    end

    @head_x = next_grid_pos

    @grid[@head_y][@head_x] = @head
    @head.x = @head_x * @grid_unit_size
  end

  def move_left
    next_grid_pos = @head_x - 1
    
    if next_grid_pos < 0
      next_grid_pos = @grid[0].length() - 1
    end

    @head_x = next_grid_pos

    @grid[@head_y][@head_x] = @head
    @head.x = @head_x * @grid_unit_size
  end

  def is_alive
  end

end

grid_width = 45
grid_height = grid_width
grid = Array.new(grid_width) { Array.new(grid_height) }

snake = Snake.new(grid)

# Define what happens when a specific key is pressed.
# Each keypress influences on the  movement along the x and y axis.
on :key_held do |event|
  if event.key == 'up'
    snake.move_up
  elsif event.key == 'down'
    snake.move_down
  elsif event.key == 'left'
    snake.move_left
  elsif event.key == 'right'
    snake.move_right
  end
end

update do
end

show