#!/usr/bin/env ruby

# file: humble_rpi-plugin-vibrationsensor.rb

require 'rpi_pinin_msgout'
require 'chronic_duration'


# Hardware test setup:
# 
# * vibration sensor (SW-18010P) only connected between a GPIO pin and ground
#
# Trigger an event
#
# * To trigger a vibration event, tap the sensor at any angle

class HumbleRPiPluginVibrationSensor


  def initialize(settings: {}, variables: {}, verbose: false)

    pins = settings[:pins]
    settings.delete :pins
    
    h1 = {
      duration: '5 seconds',
      capture_rate: 0.25, # seconds
      mode: :default
      }.merge settings

    h2 = {device_id: 'pi'}.merge variables
    
    h3 = {
      pull: :up, 
      subtopic: 'vibration', 
      verbose: verbose
    }
        
    h = h1.merge(h2).merge(h3)
    
    @pins = pins.map.with_index do |x,i|
      
      RPiPinInMsgOut.new x, h.merge(index: i)
      
    end
    
  end
  
  def start()
        
    puts 'ready to detect vibrations'
    
    @pins.each {|pin| Thread.new { pin.capture_high } }

  end
  
  alias on_start start
  
end