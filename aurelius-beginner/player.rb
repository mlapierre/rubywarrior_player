class Player
  MAX_HEALTH = 20
  HEAL_AT = 10
  VALID_DIRECTIONS = [:backward, :forward]

  attr_accessor :previous_health

  def initialize
    @previous_health = MAX_HEALTH 
    @current_direction = VALID_DIRECTIONS[1]
    @current_state = :exploring
  end

  def play_turn(warrior)
    @warrior = warrior
    begin
      puts warrior.look
      return if determine_direction!
      return if rescue_captive!
      return if heal!
      return if attack!
      warrior.walk!(@current_direction) 
    ensure
      @previous_health = warrior.health
    end
  end

  def attack!
    if @warrior.feel(@current_direction).enemy? 
      @warrior.attack!(@current_direction) 
    end
  end

  def heal!
    if should_heal?
      if is_taking_damage?
        @warrior.walk!(:backward)
      else
	@current_state = :healing
        @warrior.rest!
      end
      return true
    end
    @current_state = :exploring
    return false
  end

  def determine_direction!
    if @warrior.feel(@current_direction).wall?
      #dirs = VALID_DIRECTIONS
      #old_dir_index = VALID_DIRECTIONS.index(@current_direction)
      #dirs.delete_at(old_dir_index)
      #@current_direction = dirs[0]
      @warrior.pivot!
      return true
    end
    return false
  end

  def rescue_captive!
    if @warrior.feel(@current_direction).captive?
      @warrior.rescue!(@current_direction)
      return true
    end
    return false
  end

  def should_heal?
    #puts "health: #{@warrior.health}"
    #puts "previous_health: #{@previous_health}"
    return @warrior.health < HEAL_AT || (@current_state == :healing && @warrior.health < MAX_HEALTH)
  end

  def is_taking_damage?
    return @warrior.health < @previous_health
  end

  def warrior=(war)
    @warrior = war 
  end
end
