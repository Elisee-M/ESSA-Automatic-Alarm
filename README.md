# 🕒 ESSA Smart Alarm System

A WiFi-based smart alarm system built using **ESP8266**, **NTP time synchronization**, and an **I²C LCD display**.  
It automatically rings at scheduled school hours and shows the **current day (in words)** and **real-time clock** on the LCD.

---

## 🚀 Features

✅ Displays **real-time day and time** synced via NTP (internet time)  
✅ **Automatic alarm ringing** at pre-defined school times  
✅ **LCD splash screens** showing credits and system info on startup  
✅ **WiFi connection status** displayed on LCD during setup  
✅ Uses **ESP8266 + LiquidCrystal_I2C** library for easy control

---

## 🧠 How It Works

1️⃣ On power-up, LCD shows:  
   - `made by ELONDA` (3 seconds)  
   - `ESSA ALARM` (3 seconds)  
2️⃣ The device connects to WiFi and shows “Connecting...” with progress dots.  
3️⃣ Once connected, LCD shows “WiFi Connected” for 2 seconds.  
4️⃣ LCD then switches to real-time **Day** and **Time**, updated every second.  
5️⃣ The system rings alarms at scheduled times (different durations based on the time of day and weekday).

---

## 🧩 Hardware Requirements

- ESP8266 (NodeMCU)
- 16x2 I²C LCD Display
- Buzzer or Bell connected to **D5**
- WiFi connection

---

## 🔧 Software Requirements

- Arduino IDE
- Libraries:
  - `ESP8266WiFi.h`
  - `WiFiUdp.h`
  - `NTPClient.h`
  - `Wire.h`
  - `LiquidCrystal_I2C.h`

---

## ⚙️ Setup Steps

1️⃣ Open Arduino IDE and install the required libraries (from Library Manager).  
2️⃣ Connect your ESP8266 and select the correct **Board** and **Port**.  
3️⃣ Replace WiFi credentials in the code:
   ```cpp```
   const char* ssid = "YourWiFiName";
   const char* password = "YourPassword";

   3️⃣ Upload Code
Select your board → choose correct COM port → upload.

4️⃣ Watch the LCD
After startup messages, it will show the real-time day and time.

🔔 Alarm Logic
Day Type	Alarm Type	Example Times	Duration
Weekdays (Mon–Fri)	Short Alarms	08:40, 09:20, 10:00...	6s
Weekdays (Mon–Fri)	Long Alarms	08:00, 10:40, 11:10...	10s
Mon, Wed, Fri	Assembly Bell	07:30	15s
Sunday	Church/Rest Alarms	07:10, 12:45, 18:00...	15s
Saturday	Weekend Alarms	07:10, 12:45, 18:00	15s
🧾 Credits

👤 Developer: ELONDA
🏫 Institution: ESSA Nyarugunga
💡 Purpose: Smart school bell automation project

🛰️ Future Upgrades

Add Firebase for remote control

Add custom alarm scheduling via web dashboard

Add DST and timezone auto-adjustment

📸 LCD Display Flow

made by ELONDA
   ↓ (3s)
ESSA ALARM
   ↓ (3s)
Connecting...
   ↓
WiFi Connected
   ↓
Day: Monday
12:45:03
🧡 ESSA Smart Alarm – Reliable Time, Smarter School.
