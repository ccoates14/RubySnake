require 'ruby2d'

set title: "Broken Snake haha"

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

  def unit_size
    @@body_unit_size
  end

  def intersects?(entity)
    entity_x = entity.x
    entity_y = entity.y

    upper_left_corner = entity_x >= @head.x && entity_x <= @head.x + unit_size &&
      entity_y >= @head.y && entity_y <= @head.y + unit_size
    
    upper_right_corner = entity_x + unit_size >= @head.x && entity_x + unit_size <= @head.x + unit_size &&
      entity_y >= @head.y && entity_y <= @head.y + unit_size

    lower_left_corner = entity_x >= @head.x && entity_x <= @head.x + unit_size &&
      entity_y + unit_size >= @head.y && entity_y + unit_size <= @head.y + unit_size

    lower_right_corner = entity_x + unit_size >= @head.x && entity_x + unit_size <= @head.x + unit_size &&
     entity_y + unit_size >= @head.y && entity_y + unit_size <= @head.y + unit_size

    upper_left_corner || upper_right_corner || lower_left_corner || lower_right_corner
  end

  def move_up
    next_grid_pos = @head_y - 1
    
    if next_grid_pos < 0
      next_grid_pos = @grid.length() - 1
    end

    @head_y = next_grid_pos
    previous_y = @head.y + unit_size
    previous_x = @head.x
    @grid[@head_y][@head_x] = @head

    @body.each do |body_part|
      current_y = body_part.y
      current_x = body_part.x
      body_part.y = previous_y
      body_part.x = previous_x
      previous_y = current_y + unit_size
      previous_x = current_x
    end

    @head.y = @head_y * @grid_unit_size
  end

  def move_down
    next_grid_pos = @head_y + 1
    
    if next_grid_pos >= @grid.length()
      next_grid_pos = 0
    end

    @head_y = next_grid_pos

    @grid[@head_y][@head_x] = @head

    previous_y = @head.y - unit_size
    previous_x = @head.x
  
    @body.each do |body_part|
      current_y = body_part.y
      current_x = body_part.x
      body_part.y = previous_y
      body_part.x = previous_x
      previous_y = current_y - unit_size 
      previous_x = current_x
    end

    @head.y = @head_y * @grid_unit_size
  end

  def move_right
    next_grid_pos = @head_x + 1
    
    if next_grid_pos >= @grid[0].length()
      next_grid_pos = 0
    end

    @head_x = next_grid_pos
    previous_x = @head.x - unit_size
    previous_y = @head.y
    @grid[@head_y][@head_x] = @head
   
    @body.each do |body_part|
      current_x = body_part.x
      current_y = body_part.y
      body_part.x = previous_x
      body_part.y = previous_y
      previous_x = current_x - unit_size
      previous_y = current_y
    end

    @head.x = @head_x * @grid_unit_size
  end

  def move_left
    next_grid_pos = @head_x - 1
    
    if next_grid_pos < 0
      next_grid_pos = @grid[0].length() - 1
    end

    @head_x = next_grid_pos
    previous_x = @head.x + unit_size
    previous_y = @head.y
    @grid[@head_y][@head_x] = @head

    @body.each do |body_part|
      current_y = body_part.y
      current_x = body_part.x
      body_part.x = previous_x
      body_part.y = previous_y
      previous_x = current_x + unit_size
      previous_y = current_y
    end

    @head.x = @head_x * @grid_unit_size
  end

  def is_alive
  end

  def eat_apple(apple)
    if intersects?(apple)
      apple.eat
      add_body_part
    end
  end

  def add_body_part
    last_body_part = @body.last
    new_body_part = Square.new(x: last_body_part.x - unit_size, y: last_body_part.y - unit_size,
      size: @@body_unit_size, color: 'green')
    @body.push(new_body_part)
  end
end

class Apple
  @@body_unit_size = 5

  def initialize
    @x = 50
    @y = 25
    @body = Square.new(x: @x, y: @y,
       size: @@body_unit_size, color: 'red')
  end

  def eat
    @x = rand(0..(Window.width - unit_size))
    @y = rand(0..(Window.height - unit_size))
    @body.x = @x
    @body.y = @y
  end

  def x
    @x
  end

  def y
    @y
  end

  def body
    @body
  end

  def unit_size
    @@body_unit_size
  end
end

grid_width = 60
grid_height = grid_width
grid = Array.new(grid_width) { Array.new(grid_height) }

snake = Snake.new(grid)
apple = Apple.new

# Define what happens when a specific key is pressed.
# Each keypress influences on the  movement along the x and y axis.
previous_direction = 'right'
key_held = false

skip_rate = 3
current_skip = 0

on :key_held do |event|
  if current_skip == skip_rate
    if event.key == 'up'
      snake.move_up
      key_held = true
    elsif event.key == 'down'
      snake.move_down
      key_held = true
    elsif event.key == 'left'
      snake.move_left
      key_held = true
    elsif event.key == 'right'
      snake.move_right
      key_held = true
    end

    snake.eat_apple(apple)
  end
end

on :key_up do |event|
  if event.key == 'up'
    key_held = false
    previous_direction = 'up'
  elsif event.key == 'down'
    key_held = false
    previous_direction = 'down'
  elsif event.key == 'right'
    key_held = false
    previous_direction = 'right'
  elsif event.key == 'left'
    key_held = false
    previous_direction = 'left'
  end
end

update do
  if current_skip == skip_rate
    if previous_direction == 'up' && !key_held
      snake.move_up
    elsif previous_direction == 'down' && !key_held
      snake.move_down
    elsif previous_direction == 'left' && !key_held
      snake.move_left
    elsif previous_direction == 'right' && !key_held
      snake.move_right
    end

    current_skip = 0
  end
  current_skip += 1
end

show