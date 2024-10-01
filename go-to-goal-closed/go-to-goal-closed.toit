import ..communication show Communicator WsCommunication

import ..led
import ..motors
import ..pinout
import ..utilities

class HeartbeatHandler implements Communicator:
    state := Communicator.DISABLED

    led/Led := Led
    motors/Motors := Motors

    constructor:
      halt

    halt:
        led.off
        motors.stop

    on-start address port:
    on-open:
    on-close: disable
    on-message message: enable

    is-enabled: return state == Communicator.ENABLED

    enable:
        if state == Communicator.ENABLED: return
        state = Communicator.ENABLED

    disable:
        if state == Communicator.DISABLED: return
        state = Communicator.DISABLED
        halt

class ProportionalControl:
    kp/float
    speed-factor/float := 0.0
    max-speed-step/float
    max-speed/float

    constructor .kp/float .max-speed-step/float .max-speed/float:

    compute-speed-factor desired-speed/float measured-speed/float:
        desired-speed = constrain desired-speed -max-speed max-speed
        error := desired-speed - measured-speed
        u := constrain (kp * error) -max-speed-step max-speed-step

        speed-factor = constrain (speed-factor + u) -1.0 1.0

        return speed-factor

class MotorControl:
  static WHEEL-CIRCUMFERENCE ::= 0.199
  static LEFT-KP ::= 0.1
  static RIGHT-KP ::= 0.1
  static MAX-SPEED-STEP ::= 0.1
  static MAX-SPEED ::= 0.4

  motors/Motors 

  left-controller/ProportionalControl := ProportionalControl LEFT-KP MAX-SPEED-STEP MAX-SPEED
  right-controller/ProportionalControl := ProportionalControl RIGHT-KP MAX-SPEED-STEP MAX-SPEED

  left-time/int := 0
  right-time/int := 0

  constructor .motors:
    left-time = Time.monotonic-us
    right-time = Time.monotonic-us

  update-forward-speed desired-speed/float:
    now := Time.monotonic-us
    time-delta := (now - left-time).to-float /1_000_000
    left-rot-per-s := motors.left-encoder.get-rotation-rate time-delta
    left-speed := left-rot-per-s * WHEEL-CIRCUMFERENCE
    left-speed-factor := left-controller.compute-speed-factor desired-speed left-speed
    motors.left-motor.set-speed-factor left-speed-factor

    now = Time.monotonic-us
    time-delta = (now - left-time).to-float /1_000_000
    right-rot-per-s := motors.right-encoder.get-rotation-rate time-delta
    right-speed := right-rot-per-s * WHEEL-CIRCUMFERENCE
    right-speed-factor := right-controller.compute-speed-factor desired-speed right-speed
    motors.right-motor.set-speed-factor right-speed-factor
    
    left-time = now
    right-time = now
    
    // left-measured-speed := motors.left-encoder.get-rotation-rate 

main:
    heartbeat-handler := HeartbeatHandler
    comm := WsCommunication heartbeat-handler --heartbeat-ms=5_000

    while not heartbeat-handler.is-enabled:
        sleep --ms=2000
    
    while true:
      while true:
        if heartbeat-handler.is-enabled:
          motor-control := MotorControl heartbeat-handler.motors
          motor-control.motors.left-motor.set-pwm-duty-factor 1.0
          motor-control.motors.right-motor.set-pwm-duty-factor 0.95
          motor-speed := 0.20

          duration-ms := 10_000
          control-update-ms := 100
          time-ms := 0

          //run with set speed function

        //   left-motor := Motor LEFT-MOTOR-DIR-PIN LEFT-MOTOR-PWM-PIN
        //   left-encoder := Encoder LEFT-ENCODER-PIN LEFT-ENCODER-CONTROL-PIN
        
        //   right-motor := Motor RIGHT-MOTOR-DIR-PIN RIGHT-MOTOR-PWM-PIN
        //   right-encoder := Encoder RIGHT-ENCODER-PIN RIGHT-ENCODER-CONTROL-PIN
        
        // instead set them to the speeds we want
        //   right-motor.set-pwm-duty-factor 1.0
        //   left-motor.set-pwm-duty-factor 1.0
          sleep --ms=8_750

      //   while time-ms < duration-ms:
      //     // motor-control.update-forward-speed motor-speed
      //     sleep --ms=control-update-ms
      //     time-ms += control-update-ms
        
          heartbeat-handler.motors.stop
          break
        else:
          sleep --ms=1000
    print "Done"