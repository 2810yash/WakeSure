# 📱 Smart Alarm MVP (Voice Verification Alarm)

A **Flutter-based smart alarm app** that ensures the user is actually awake by using **voice verification** after turning off the alarm.

Instead of simply stopping the alarm, the app **checks if the user is truly awake** by asking a question and listening to their response.

---

# 🚀 Features

- 🔔 Alarm simulation (start / stop)
- 🎙️ Voice-based wake verification
- 🔊 Text-to-Speech (TTS) for asking questions
- 🎤 Speech-to-Text for user response
- 🔁 Automatic alarm restart if user fails verification
- ⏳ Delay-based wake check (30 seconds)

---

# 🧠 How It Works

```
1. Alarm rings
2. User presses "Stop Alarm"
3. App waits 30 seconds
4. App asks: "Are you awake?"
5. Microphone starts listening
6. User speaks
7. Speech is converted to text

   IF user says "I am awake"
       → Alarm stops ✅
   ELSE
       → Alarm rings again 🔁
```

---

# 🛠️ Tech Stack

- **Flutter**
- **Dart**
- **flutter_tts** → Text-to-Speech
- **speech_to_text** → Voice recognition
- **audioplayers** → Alarm sound

---

# 📦 Dependencies

Add these to `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_tts: ^4.2.5
  speech_to_text: ^7.3.0
  audioplayers: ^6.5.1
```

---

# 🔐 Permissions (Android)

Add in `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>
```

---

# 🔊 Assets Setup

1. Create an `assets/` folder  
2. Add your alarm sound file:

```
assets/alarm.mp3
```

3. Register it in `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/alarm.mp3
```

---

# ▶️ Running the App

```bash
flutter pub get
flutter run
```

---

# 🧪 Testing Instructions

1. Tap **Start Alarm**
2. Alarm will ring 🔊
3. Tap **Stop Alarm**
4. Wait 30 seconds
5. App will ask: *"Are you awake?"*
6. Speak:

   - ✅ "I am awake" → Alarm stops
   - ❌ Anything else → Alarm restarts

---

# 🚀 Future Improvements

- ⏰ Scheduled alarms
- 🔄 Background service support
- 📱 Full-screen alarm UI
- 🧩 Voice-based challenges (math, phrases)
- 📊 Wake-up analytics
- 🔊 Increasing alarm volume
- 📷 Face detection / activity check
- 📍 Location-based wake verification

---

# 💡 Idea Behind the Project

Many users turn off alarms and go back to sleep.  
This app ensures the user is **mentally awake** by requiring a **voice response** after stopping the alarm.

---

# 🧑‍💻 Author

**Yash Wairagade**

---

# ⭐ Contributing

Feel free to fork, improve, and create pull requests!

---

# 📄 License

This project is open-source and available under the MIT License.

---

# 🔥 Future Vision

This can evolve into a **full smart alarm ecosystem** with:

- AI-based conversations
- Habit tracking
- Smart morning routines