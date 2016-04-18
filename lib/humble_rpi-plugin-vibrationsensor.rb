#!/usr/bin/env ruby

# file: humble_rpi-plugin-vibrationsensor.rb

require 'rpi_pinin'
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

    @pins = settings[:pins].map {|x| RPiPinIn.new x, pull: :up}
    @duration = settings[:duration] || '5 seconds'
    @capture_rate = settings[:capture_rate] || 0.25 # seconds    
    @notifier = variables[:notifier]
    @device_id = variables[:device_id] || 'pi'
    
    @verbose = verbose

    
  end

  def start()

    count = 0
    
    duration = ChronicDuration.parse(@duration)
    notifier = @notifier
    device_id = @device_id
    
    t0 = Time.now + 1
    t1 = Time.now - duration + 1
    
    puts 'ready to detect vibrations'
    
    @pins.each.with_index do |pin, i|
      
      Thread.new do      
        
        pin.watch_high do
          
          # ignore any movements that happened 250 
          #               milliseconds ago since the last movement
          if t0 + @capture_rate < Time.now then          
            
            puts  Time.now.to_s if @verbose
            
            count += 1
            
            elapsed = Time.now - (t1  + duration)
            #puts 'elapsed : ' + elapsed.inspect

            if elapsed > 0 then

              # identify if the movement is consecutive
              msg = if elapsed < duration then              
                s = ChronicDuration.output(duration, :format => :long)
                "%s/vibration/%s: detected %s times within the past %s" \
                                                      % [device_id, i, count, s ]
              else              
                "%s/vibration/%s: detected" % [device_id, i]
              end
              
              notifier.notice msg
              t1 = Time.now
              count = 0
            end
            
            t0 = Time.now
          else
            #puts 'ignoring ...'
          end          
          
        end #/ watch_high        
      end #/ thread             
    end

    
  end
  
  alias on_start start  
  
end
