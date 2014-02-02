$:.unshift File.join(File.dirname(__FILE__), "..", "aurelius-beginner")
require File.dirname(__FILE__) + '/../../../src/ruby-warrior/lib/ruby_warrior'
require 'player'

describe "Player" do
  before(:all) do
    @warrior = RubyWarrior::Units::Warrior.new
    @player = Player.new
    @player.warrior = @warrior
  end

  it "knows if it is taking damage" do
    expect(@player.is_taking_damage?).to be_false
    @warrior.health = 1
    expect(@player.is_taking_damage?).to be_true
  end

  it "knows if it needs to heal" do
    expect(@player.should_heal?).to be_false
    @warrior.health = 1
    expect(@player.should_heal?).to be_false
    @player.previous_health = 1
    expect(@player.should_heal?).to be_true
  end
end
