#include <Arduino.h>

#define STEP_DELAY_US 800  // controls speed

#define CAMERA_STEP_PIN 2
#define CAMERA_DIR_PIN 3
#define LASER_STEP_PIN 5
#define LASER_DIR_PIN 6

void processCommand(String commandLine);
void processSingleCommand(String command);
void moveLaserxx(int x1, int x2);
void moveCamera(int steps);
void moveLaser(int steps);
void moveStepper(int stepPin, int dirPin, int steps, bool dir);
void moveCameraStepper(int steps, bool dir);
void moveLaserStepper(int steps, bool dir);

void setup() {
  pinMode(CAMERA_STEP_PIN, OUTPUT);
  pinMode(CAMERA_DIR_PIN, OUTPUT);
  pinMode(LASER_STEP_PIN, OUTPUT);
  pinMode(LASER_DIR_PIN, OUTPUT);

  Serial.begin(9600);
}

void loop() {
  if (Serial.available() > 0) {
    String command = Serial.readStringUntil('\n');
    processCommand(command);
  }
}

void processCommand(String commandLine) {
  commandLine.trim();

  int start = 0;
  while (true) {
    int sep = commandLine.indexOf(';', start);

    if (sep == -1) {
      processSingleCommand(commandLine.substring(start));
      break;
    }

    processSingleCommand(commandLine.substring(start, sep));
    start = sep + 1;
  }
}

void processSingleCommand(String command) {
  command.trim();

  if (command.startsWith("camera ")) {
    int steps = command.substring(7).toInt();
    moveCamera(steps);
    Serial.print("OK: camera ");
    Serial.println(steps);

  } else if (command.startsWith("laser ")) {
    int steps = command.substring(6).toInt();
    moveLaser(steps);
    Serial.print("OK: laser ");
    Serial.println(steps);

  } else if (command.startsWith("laserxx ")) {
    int firstSpace = command.indexOf(' ');
    int secondSpace = command.indexOf(' ', firstSpace + 1);

    if (secondSpace == -1) {
      Serial.print("ERR: invalid laserxx command: ");
      Serial.println(command);
      return;
    }

    int x1 = command.substring(firstSpace + 1, secondSpace).toInt();
    int x2 = command.substring(secondSpace + 1).toInt();

      Serial.print("OK: laserxx ");
      Serial.print(x1);
      Serial.print(" ");
      Serial.println(x2);
      moveLaserxx(x1, x2);

  } else if (command.startsWith("wait ")) {
    int duration = command.substring(5).toInt();
    delay(duration);
    Serial.print("OK: wait ");
    Serial.println(duration);

  } else {
    Serial.print("ERR: unknown command: ");
    Serial.println(command);
  }
}

void moveLaserxx(int x1, int x2) {
  moveLaser(x1);
  int laserStep = 10;
  if (x2 < x1) {
    laserStep = -laserStep;
  }
  int start = (x1 < x2) ? x1 : x2;
  int end = (x1 < x2) ? x2 : x1;
  for (int x = start; x < end; x += laserStep) {
    if (laserStep > 0) {
      for (int x = x1; x < x2; x += laserStep) {
        moveLaser(laserStep);
      }
    } else {
      for (int x = x1; x > x2; x += laserStep) {
        moveLaser(laserStep);
      }
    }
  }
}

void moveCamera(int steps) {
  if (steps > 0) {
    moveCameraStepper(steps, HIGH);  // Move X forward
  } else if (steps < 0) {
    moveCameraStepper(-steps, LOW);  // Move X backward
  }
}

void moveLaser(int steps) {
  if (steps > 0) {
    moveLaserStepper(steps, HIGH);  // Move Y forward
  } else if (steps < 0) {
    moveLaserStepper(-steps, LOW);  // Move Y backward
  }
}

void moveStepper(int stepPin, int dirPin, int steps, bool dir) {
  digitalWrite(dirPin, dir);

  for (int i = 0; i < steps; i++) {
    digitalWrite(stepPin, HIGH);
    delayMicroseconds(STEP_DELAY_US);
    digitalWrite(stepPin, LOW);
    delayMicroseconds(STEP_DELAY_US);
  }
}

void moveCameraStepper(int steps, bool dir) {
  moveStepper(CAMERA_STEP_PIN, CAMERA_DIR_PIN, steps, dir);
}

void moveLaserStepper(int steps, bool dir) {
  moveStepper(LASER_STEP_PIN, LASER_DIR_PIN, steps, dir);
}
