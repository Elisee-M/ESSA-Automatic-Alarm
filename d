warning: in the working copy of 'ESSA_ALARM.ino', LF will be replaced by CRLF the next time Git touches it
[1mdiff --git a/ESSA_ALARM.ino b/ESSA_ALARM.ino[m
[1mindex 133cd2e..1a0684d 100644[m
[1m--- a/ESSA_ALARM.ino[m
[1m+++ b/ESSA_ALARM.ino[m
[36m@@ -1,6 +1,8 @@[m
 #include <ESP8266WiFi.h>[m
 #include <WiFiUdp.h>[m
 #include <NTPClient.h>[m
[32m+[m[32m#include <Wire.h>[m
[32m+[m[32m#include <LiquidCrystal_I2C.h>[m
 [m
 const char* ssid = "EdNet";[m
 const char* password = "Huawei@123";[m
[36m@@ -10,80 +12,79 @@[m [mNTPClient timeClient(ntpUDP, "pool.ntp.org", 2 * 3600, 60000);[m
 [m
 #define ALARM_PIN D5[m
 [m
[31m-void setup() {[m
[31m-  Serial.begin(115200);[m
[31m-  pinMode(ALARM_PIN, OUTPUT);[m
[31m-  digitalWrite(ALARM_PIN, LOW);[m
[31m-[m
[31m-  WiFi.begin(ssid, password);[m
[31m-  while (WiFi.status() != WL_CONNECTED) {[m
[31m-    delay(500);[m
[31m-    Serial.print(".");[m
[31m-  }[m
[31m-  Serial.println("\nWiFi Connected!");[m
[31m-  timeClient.begin();[m
[31m-}[m
[31m-[m
[31m-void loop() {[m
[31m-  timeClient.update();[m
[31m-[m
[31m-  int dayOfWeek = timeClient.getDay();[m
[31m-  int hour = timeClient.getHours();[m
[31m-  int minute = timeClient.getMinutes();[m
[31m-  int second = timeClient.getSeconds();[m
[31m-[m
[31m-  // Always inside loop()[m
[31m-  Serial.printf("📅 Day: %d | 🕒 Time: %02d:%02d:%02d\n", dayOfWeek, hour, minute, second);[m
[31m-[m
[31m-  if (shouldRing(dayOfWeek, hour, minute, second)) {[m
[31m-    // ring handled inside shouldRing()[m
[31m-  }[m
[32m+[m[32mLiquidCrystal_I2C lcd(0x27, 16, 2);[m
 [m
[31m-  delay(1000);[m
[32m+[m[32mvoid ringAlarm(int durationSec) {[m
[32m+[m[32m  digitalWrite(ALARM_PIN, HIGH);[m
[32m+[m[32m  delay(durationSec * 1000);[m
[32m+[m[32m  digitalWrite(ALARM_PIN, LOW);[m
 }[m
 [m
[31m-// Function outside setup/loop[m
 bool shouldRing(int dayOfWeek, int hour, int minute, int second) {[m
[31m-  // Weekday (Monday=1 to Friday=5)[m
   if (dayOfWeek >= 1 && dayOfWeek <= 5) {[m
[31m-    // Short alarms (6 sec)[m
     if ((hour == 6 && minute == 0 && second == 0) ||[m
         (hour == 7 && minute == 0 && second == 0)) {[m
       ringAlarm(6);[m
       return true;[m
     }[m
[31m-[m
[31m-    // Long alarms (10 sec)[m
[31m-    if ((hour == 9 && minute == 51 && second == 0) ||[m
[32m+[m[32m    if ((hour == 10 && minute == 0 && second == 0) ||[m
         (hour == 12 && minute == 0 && second == 0)) {[m
       ringAlarm(10);[m
       return true;[m
     }[m
[31m-[m
[31m-    // Assembly bell Mon/Thu/Fri at 7:30[m
[31m-    if ((dayOfWeek == 1 || dayOfWeek == 3 || dayOfWeek == 5) &&[m
[32m+[m[32m    if ((dayOfWeek == 1 || dayOfWeek == 4 || dayOfWeek == 5) &&[m
         hour == 7 && minute == 30 && second == 0) {[m
       ringAlarm(6);[m
       return true;[m
     }[m
   }[m
[31m-[m
[31m-  // Weekend (Saturday=6, Sunday=0)[m
   if (dayOfWeek == 6 || dayOfWeek == 0) {[m
[32m+[m[32m    if ((hour == 8 && minute == 0 && second == 0) ||[m
[32m+[m[32m        (hour == 12 && minute == 0 && second == 0) ||[m
[32m+[m[32m        (hour == 18 && minute == 0 && second == 0)) {[m
[32m+[m[32m      ringAlarm(6);[m
[32m+[m[32m      return true;[m
[32m+[m[32m    }[m
     if ((hour == 20 && minute == 0 && second == 0)) {[m
       ringAlarm(10);[m
       return true;[m
     }[m
   }[m
[31m-[m
   return false;[m
 }[m
 [m
[31m-void ringAlarm(int durationSec) {[m
[31m-  digitalWrite(ALARM_PIN, HIGH);[m
[31m-  delay(durationSec * 1000); // convert seconds to milliseconds[m
[32m+[m[32mvoid setup() {[m
[32m+[m[32m  pinMode(ALARM_PIN, OUTPUT);[m
   digitalWrite(ALARM_PIN, LOW);[m
[31m-  Serial.print("🔔 Alarm rang for ");[m
[31m-  Serial.print(durationSec);[m
[31m-  Serial.println(" seconds");[m
[32m+[m[32m  WiFi.begin(ssid, password);[m
[32m+[m[32m  while (WiFi.status() != WL_CONNECTED) delay(500);[m
[32m+[m[32m  timeClient.begin();[m
[32m+[m[32m  lcd.init();[m
[32m+[m[32m  lcd.backlight();[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32mvoid loop() {[m
[32m+[m[32m  timeClient.update();[m
[32m+[m[32m  int dayOfWeek = timeClient.getDay();[m
[32m+[m[32m  if (dayOfWeek == 0) dayOfWeek = 7;[m
[32m+[m[32m  int hour = timeClient.getHours();[m
[32m+[m[32m  int minute = timeClient.getMinutes();[m
[32m+[m[32m  int second = timeClient.getSeconds();[m
[32m+[m
[32m+[m[32m  lcd.setCursor(0, 0);[m
[32m+[m[32m  lcd.print("Day:");[m
[32m+[m[32m  lcd.print(dayOfWeek);[m
[32m+[m[32m  lcd.setCursor(0, 1);[m
[32m+[m[32m  if (hour < 10) lcd.print("0");[m
[32m+[m[32m  lcd.print(hour);[m
[32m+[m[32m  lcd.print(":");[m
[32m+[m[32m  if (minute < 10) lcd.print("0");[m
[32m+[m[32m  lcd.print(minute);[m
[32m+[m[32m  lcd.print(":");[m
[32m+[m[32m  if (second < 10) lcd.print("0");[m
[32m+[m[32m  lcd.print(second);[m
[32m+[m
[32m+[m[32m  shouldRing(dayOfWeek, hour, minute, second);[m
[32m+[m
[32m+[m[32m  delay(1000);[m
 }[m
