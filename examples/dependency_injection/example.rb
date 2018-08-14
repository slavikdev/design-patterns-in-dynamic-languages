class Alarm
  def initialize(sound_factory)
    @sound_factory = sound_factory
  end
 
  def trigger
    sound = @sound_factory.create
    sound.play
  end
 end
 