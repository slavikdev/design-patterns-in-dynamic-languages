class Alarm
  def trigger
    sound = Sound.new
    sound.play
  end
end
