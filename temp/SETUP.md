# Setup Guide

## Quick Start (5 minutes)

### 1. Prerequisites

Ensure you have:
- Flutter SDK 3.0+ installed
- Android Studio or VS Code
- OpenAI API key ([get one here](https://platform.openai.com/api-keys))

Check Flutter installation:
```bash
flutter doctor
```

### 2. Clone and Setup

```bash
# Clone the repository
git clone https://github.com/cyan92128505/english_voice_practice.git
cd english_voice_practice

# Install dependencies
flutter pub get
```

### 3. Configure API Key

**Option A: Using --dart-define (Recommended for development)**

```bash
flutter run --dart-define=OPENAI_API_KEY=sk-your-actual-key-here
```

**Option B: Create .env file (For production)**

Create `.env` file in project root:
```
OPENAI_API_KEY=sk-your-actual-key-here
```

Then modify `lib/providers/providers.dart`:
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

// In chatGPTServiceProvider:
final apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';
```

### 4. Run the App

```bash
# For Android
flutter run

# For iOS (macOS only)
flutter run -d ios

# For specific device
flutter devices
flutter run -d <device-id>
```

### 5. First Launch

On first app launch:
1. Grant microphone permission when prompted
2. Wait 1-2 minutes for Whisper model download (~244MB)
3. Start practicing!

---

## Troubleshooting

### Issue: "Microphone permission denied"

**Android:**
- Go to Settings → Apps → English Practice → Permissions
- Enable Microphone permission

**iOS:**
- Go to Settings → Privacy → Microphone
- Enable for English Practice

### Issue: "Failed to download Whisper model"

**Solutions:**
1. Check internet connection
2. Check available storage (need ~300MB free)
3. Try on WiFi instead of mobile data
4. Restart the app

### Issue: "ChatGPT API error: 401"

**Solution:**
- Your API key is invalid
- Check key at https://platform.openai.com/api-keys
- Ensure key starts with `sk-`
- Re-run with correct key

### Issue: "Transcription is slow"

**Solutions:**
1. Use a smaller model in `whisper_service.dart`:
```dart
model: WhisperModel.tiny,  // Fastest (39MB)
// or
model: WhisperModel.base,  // Balanced (74MB)
```

2. Reduce thread count for low-end devices:
```dart
threads: 2,  // Instead of 4
```

### Issue: "Build failed on iOS"

**Solution:**
```bash
cd ios
pod install
cd ..
flutter clean
flutter pub get
flutter run
```

---

## Development Tips

### Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

### Building Release

**Android APK:**
```bash
flutter build apk --release --dart-define=OPENAI_API_KEY=your_key
```

**Android App Bundle (for Play Store):**
```bash
flutter build appbundle --release --dart-define=OPENAI_API_KEY=your_key
```

**iOS:**
```bash
flutter build ios --release --dart-define=OPENAI_API_KEY=your_key
```

### Code Formatting

```bash
# Format all files
dart format .

# Check formatting without changing files
dart format --set-exit-if-changed .
```

### Analyzing Code

```bash
flutter analyze
```

---

## Performance Optimization

### 1. Reduce App Size

If you don't need offline-first capability, use auto-download mode (default).

If you want offline-first:
1. Download model manually
2. Add to `assets/models/`
3. Update `pubspec.yaml`
4. Use `useAssetModel: true` in transcribe

### 2. Improve Transcription Speed

**Device-specific optimization:**

```dart
// lib/services/whisper_service.dart

int _getOptimalThreadCount() {
  // Detect device performance
  if (Platform.isIOS) {
    return 4; // iOS usually handles multi-threading well
  }
  
  // For Android, start conservative
  return 2;
}

Future<String> transcribe(String audioPath) async {
  final threads = _getOptimalThreadCount();
  // ...
}
```

### 3. Reduce API Costs

**Use temperature=0.3** (already configured) for consistent results.

**Batch corrections** if user does multiple practices:
```dart
// Instead of correcting each sentence individually,
// combine into one API call for discount
```

---

## Architecture Overview

```
User speaks
    ↓
Audio Recording (record package)
    ↓
Save as .wav file (16kHz mono)
    ↓
Whisper.cpp transcription (offline)
    ↓
Send to ChatGPT API (online)
    ↓
Display results + Save to SQLite
```

**Key Design Decisions:**

1. **Whisper runs locally** = Privacy + No ongoing cost
2. **ChatGPT for correction** = High quality + Flexible
3. **SQLite for history** = Fast + Offline access
4. **Riverpod for state** = Testable + Maintainable

---

## Next Steps

After getting the MVP working:

1. **Add history screen** - View past practices
2. **Add statistics** - Weekly/monthly progress charts
3. **Add pronunciation scoring** - Use phoneme analysis
4. **Add offline mode** - Local LLM for corrections
5. **Add social features** - Share progress with friends

---

## Getting Help

- **Bug reports**: Open an issue on GitHub
- **Questions**: Check existing issues first
- **Pull requests**: Always welcome!

---

## Cost Estimation

**Whisper (local):** Free (one-time model download)

**ChatGPT API:**
- Cost per practice: ~$0.0001 USD
- 30 practices/day × 30 days = ~$0.09 USD/month
- Practically free for personal use

**Total:** <$1 USD/month for daily use

---

## License

MIT License - see LICENSE file for details
