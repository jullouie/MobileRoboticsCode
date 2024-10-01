import ..display
import ..communication
import ..led
import ..motors

class ForwardMover implements Communicator:
  led/Led := Led
  state := Communicator.DISABLED
  display/Display := Display
  motors/Motors := Motors


  constructor:
    led.off
    motors.stop

  on-start address port:
    display.add-text "$address"
    display.add-text --y=32 "$port"
    display.draw

  on-open: enable
  on-close: disable
  on-message message:
    print "Received message: $message"
    enable

  is-enabled:
    return state == Communicator.ENABLED

  enable:
    if state == Communicator.ENABLED: return
    print "Enabling"
    state = Communicator.ENABLED
    led.on
    motors.set-motors-speed-factor 0.2

  disable:
    if state == Communicator.DISABLED: return
    print "Disabling"
    state = Communicator.DISABLED
    led.off
    motors.stop

main:

    forward-mover := ForwardMover
    comm := WsCommunication forward-mover --heartbeat-ms=3_000 // change this
    forward-time := 5_000

    while true:
      while true:
        if forward-mover.is-enabled:

          // motors might turn off if forward-mover is disabled

          // turns left so slowed down right motors
        //   forward-mover.motors.set-motors-speed-factor-left 1.0
        //   forward-mover.motors.set-motors-speed-factor-right 0.9
          
          
          forward-mover.motors.set-motors-speed-factor 1.0
          sleep --ms=forward-time
          forward-mover.motors.stop
          break
        else:
          sleep --ms=1000
      // use webform to send packets for heartbeats
      // to make it run without cable: leave it plugged in first, wscat, and then unplug, and type to run


