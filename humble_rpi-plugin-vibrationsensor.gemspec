Gem::Specification.new do |s|
  s.name = 'humble_rpi-plugin-vibrationsensor'
  s.version = '0.1.0'
  s.summary = 'A Humble RPi plugin which detects vibrations using the vibration sensor (SW-18010P).'
  s.authors = ['James Robertson']
  s.files = Dir['lib/humble_rpi-plugin-vibrationsensor.rb']
  s.signing_key = '../privatekeys/humble_rpi-plugin-vibrationsensor.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/humble_rpi-plugin-vibrationsensor'
end
