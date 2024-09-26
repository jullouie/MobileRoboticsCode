import .motors
import ..pinout

main:

  left-motor := Motor LEFT-MOTOR-DIR-PIN LEFT-MOTOR-PWM-PIN
  left-encoder := Encoder LEFT-ENCODER-PIN LEFT-ENCODER-CONTROL-PIN

  right-motor := Motor RIGHT-MOTOR-DIR-PIN RIGHT-MOTOR-PWM-PIN
  right-encoder := Encoder RIGHT-ENCODER-PIN RIGHT-ENCODER-CONTROL-PIN

  right-motor.set-pwm-duty-factor 0.0
  left-motor.set-pwm-duty-factor 0.0

  right-motor.set-pwm-duty-factor 1.0
  left-motor.set-pwm-duty-factor 1.0

  sleep --ms=10_000

  right-motor.set-pwm-duty-factor 0.0
  left-motor.set-pwm-duty-factor 0.0

