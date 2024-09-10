import ..motors

main:
  motors := Motors

  while true:
    // rotates right
    motors.left-motor.set-speed 0.5
    motors.right-motor.set-speed -0.5
    sleep --ms=5_000

    // rotates left
    motors.left-motor.set-speed -0.5
    motors.right-motor.set-speed 0.5
    sleep --ms=5_000