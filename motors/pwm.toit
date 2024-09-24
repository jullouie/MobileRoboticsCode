import .motors
import ..pinout

main: 

  left-motor := Motor LEFT-MOTOR-DIR-PIN LEFT-MOTOR-PWM-PIN
  left-encoder := Encoder LEFT-ENCODER-PIN LEFT-ENCODER-CONTROL-PIN
  left-motor.set-pwm-duty-factor 0.0

  x/float := 0.0

  right-motor := Motor RIGHT-MOTOR-DIR-PIN RIGHT-MOTOR-PWM-PIN
  right-encoder := Encoder RIGHT-ENCODER-PIN RIGHT-ENCODER-CONTROL-PIN

  while x < 1:
    x += 0.05
    right-motor.set-pwm-duty-factor x
    sleep --ms=2_000
    print x
    // left-encoder.get-rotation-rate 1_000