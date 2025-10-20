#include <ESP8266WiFi.h>
#include <WiFiUdp.h>
#include <NTPClient.h>

const char* ssid = "EdNet";
const char* password = "Huawei@123";

WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP, "pool.ntp.org", 2 * 3600, 60000);

#define ALARM_PIN D5

void setup() {
  Serial.begin(115200);
  pinMode(ALARM_PIN, OUTPUT);
  digitalWrite(ALARM_PIN, LOW);

  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nWiFi Connected!");
  timeClient.begin();
}

void loop() {
  timeClient.update();

  int dayOfWeek = timeClient.getDay();
  int hour = timeClient.getHours();
  int minute = timeClient.getMinutes();
  int second = timeClient.getSeconds();

  // Always inside loop()
  Serial.printf("📅 Day: %d | 🕒 Time: %02d:%02d:%02d\n", dayOfWeek, hour, minute, second);

  if (shouldRing(dayOfWeek, hour, minute, second)) {
    // ring handled inside shouldRing()
  }

  delay(1000);
}

// Function outside setup/loop
bool shouldRing(int dayOfWeek, int hour, int minute, int second) {
  // Weekday (Monday=1 to Friday=5)
  if (dayOfWeek >= 1 && dayOfWeek <= 5) {
    // Short alarms (6 sec)
    if ((hour == 6 && minute == 0 && second == 0) ||
        (hour == 7 && minute == 0 && second == 0)) {
      ringAlarm(6);
      return true;
    }

    // Long alarms (10 sec)
    if ((hour == 9 && minute == 51 && second == 0) ||
        (hour == 12 && minute == 0 && second == 0)) {
      ringAlarm(10);
      return true;
    }

    // Assembly bell Mon/Thu/Fri at 7:30
    if ((dayOfWeek == 1 || dayOfWeek == 3 || dayOfWeek == 5) &&
        hour == 7 && minute == 30 && second == 0) {
      ringAlarm(6);
      return true;
    }
  }

  // Weekend (Saturday=6, Sunday=0)
  if (dayOfWeek == 6 || dayOfWeek == 0) {
    if ((hour == 20 && minute == 0 && second == 0)) {
      ringAlarm(10);
      return true;
    }
  }

  return false;
}

void ringAlarm(int durationSec) {
  digitalWrite(ALARM_PIN, HIGH);
  delay(durationSec * 1000); // convert seconds to milliseconds
  digitalWrite(ALARM_PIN, LOW);
  Serial.print("🔔 Alarm rang for ");
  Serial.print(durationSec);
  Serial.println(" seconds");
}
