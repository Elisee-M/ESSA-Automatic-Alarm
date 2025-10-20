#include <ESP8266WiFi.h>
#include <WiFiUdp.h>
#include <NTPClient.h>
#include <Wire.h>
#include <LiquidCrystal_I2C.h>

const char* ssid = "EdNet";
const char* password = "Huawei@123";

WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP, "pool.ntp.org", 2 * 3600, 60000);

#define ALARM_PIN D5

LiquidCrystal_I2C lcd(0x27, 16, 2);

void ringAlarm(int durationSec) {
  digitalWrite(ALARM_PIN, HIGH);
  delay(durationSec * 1000);
  digitalWrite(ALARM_PIN, LOW);
}

bool shouldRing(int dayOfWeek, int hour, int minute, int second) {
  if (dayOfWeek >= 1 && dayOfWeek <= 5) {
    if ((hour == 6 && minute == 0 && second == 0) ||
        (hour == 7 && minute == 0 && second == 0)) {
      ringAlarm(6);
      return true;
    }
    if ((hour == 10 && minute == 0 && second == 0) ||
        (hour == 12 && minute == 0 && second == 0)) {
      ringAlarm(10);
      return true;
    }
    if ((dayOfWeek == 1 || dayOfWeek == 4 || dayOfWeek == 5) &&
        hour == 7 && minute == 30 && second == 0) {
      ringAlarm(6);
      return true;
    }
  }
  if (dayOfWeek == 6 || dayOfWeek == 0) {
    if ((hour == 8 && minute == 0 && second == 0) ||
        (hour == 12 && minute == 0 && second == 0) ||
        (hour == 18 && minute == 0 && second == 0)) {
      ringAlarm(6);
      return true;
    }
    if ((hour == 20 && minute == 0 && second == 0)) {
      ringAlarm(10);
      return true;
    }
  }
  return false;
}

void setup() {
  pinMode(ALARM_PIN, OUTPUT);
  digitalWrite(ALARM_PIN, LOW);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) delay(500);
  timeClient.begin();
  lcd.init();
  lcd.backlight();
}

void loop() {
  timeClient.update();
  int dayOfWeek = timeClient.getDay();
  if (dayOfWeek == 0) dayOfWeek = 7;
  int hour = timeClient.getHours();
  int minute = timeClient.getMinutes();
  int second = timeClient.getSeconds();

  lcd.setCursor(0, 0);
  lcd.print("Day:");
  lcd.print(dayOfWeek);
  lcd.setCursor(0, 1);
  if (hour < 10) lcd.print("0");
  lcd.print(hour);
  lcd.print(":");
  if (minute < 10) lcd.print("0");
  lcd.print(minute);
  lcd.print(":");
  if (second < 10) lcd.print("0");
  lcd.print(second);

  shouldRing(dayOfWeek, hour, minute, second);

  delay(1000);
}
