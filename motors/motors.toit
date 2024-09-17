import gpio show Pin
import gpio.pwm show Pwm PwmChannel
import math show PI
import pulse_counter show Channel Unit

import ..pinout
import ..utilities

class Motor:
  static FORWARD ::= 0
  static REVERSE ::= 1

  static FREQUENCY ::= 10_000

  dir-pin/Pin
  pwm-pin/Pin
  pwm-generator := Pwm --frequency=FREQUENCY
  pwm-channel/PwmChannel

  pwm-min-factor/float

  constructor dir/int pwm/int .pwm-min-factor/float=0.1:
    dir-pin = Pin.out dir
    pwm-pin = Pin pwm
    pwm-channel = pwm-generator.start pwm-pin

  set-direction direction/int:
    dir-pin.set direction

  set-pwm-duty-factor duty-factor/float:
    duty-factor = constrain duty-factor 0.0 1.0
    pwm-channel.set-duty-factor duty-factor

  set-speed-factor speed-factor/float:
    speed-factor = constrain speed-factor -1.0 1.0

    // Set direction based on the sign
    direction := speed-factor > 0.0 ? FORWARD : REVERSE
    dir-pin.set direction

    // Set speed based on the absolute value and the minimum factor
    duty-factor := map speed-factor.abs 0.0 1.0 pwm-min-factor 1.0
    pwm-channel.set-duty-factor duty-factor

  stop:
    pwm-channel.set-duty-factor 0

  close:
    pwm-channel.close
    pwm-generator.close
    dir-pin.close
    pwm-pin.close


class Encoder:
  // 7 pulses per rotation, 2x due to quadrature, 50:1 gear ratio
  static COUNTS-PER-ROTATION := 7 * 2 * 50

  pin-a/Pin
  pin-b/Pin
  unit := Unit // TODO: use filter?
  channel/Channel

  constructor a/int b/int:

    pin-a = Pin.in a
    pin-b = Pin.in b

    channel = unit.add-channel
        pin-a
        --on-positive-edge=Unit.INCREMENT
        --on-negative-edge=Unit.DECREMENT
        --control-pin=pin-b
        --when-control-low=Unit.KEEP
        --when-control-high=Unit.REVERSE

  get-rotation-rate time-delta:
    // Read the pulse count and then clear it
    count := unit.value
    unit.clear

    // Convert the pulse counts to a fractional rotation
    rotations := count.to-float / COUNTS-PER-ROTATION
    rotation-rate := rotations / time-delta
    return rotation-rate

  close:
    channel.close
    unit.close
    pin-b.close
    pin-a.close

class Motors:
  left-motor := Motor LEFT-MOTOR-DIR-PIN LEFT-MOTOR-PWM-PIN
  right-motor := Motor RIGHT-MOTOR-DIR-PIN RIGHT-MOTOR-PWM-PIN

  left-encoder/Encoder
  right-encoder/Encoder

  constructor:
    left-encoder = Encoder LEFT-ENCODER-PIN LEFT-ENCODER-CONTROL-PIN
    right-encoder = Encoder RIGHT-ENCODER-PIN RIGHT-ENCODER-CONTROL-PIN

  set-motors-speed-factor speed-factor/float:
    left-motor.set-speed-factor speed-factor
    right-motor.set-speed-factor speed-factor

  stop:
    left-motor.stop
    right-motor.stop

  close:
    left-motor.close
    right-motor.close

    left-encoder.close
    right-encoder.close
