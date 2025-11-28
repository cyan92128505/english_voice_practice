# Implementation Guide

## Overview

This guide helps you build the English Voice Practice app from scratch in **2 days** (weekend project).

---

## Day 1: Core Functionality (Saturday, 6 hours)

### Morning Session (3 hours)

#### Step 1: Project Setup (30 mins)

```bash
# Create new Flutter project
flutter create english_voice_practice
cd english_voice_practice

# Copy all files from /outputs/ to your project
# Or manually create the directory structure
```

**Directory structure:**
```
lib/
├── main.dart
├── models/
│   └── models.dart
├── services/
│   ├── whisper_service.dart
│   ├── audio_recorder_service.dart
│   ├── chatgpt_service.dart
│   └── database_service.dart
├── providers/
│   └── providers.dart
└── screens/
    └── practice_screen.dart (use practice_screen_part1.dart)
```

#### Step 2: Add Dependencies (15 mins)

Copy `pubspec.yaml` from outputs, then run:
```bash
flutter pub get
```

#### Step 3: Configure Permissions (15 mins)

**Android:**
- Copy `android/app/src/main/AndroidManifest.xml` from outputs

**iOS:**
- Copy `ios/Runner/Info.plist` from outputs

#### Step 4: Test Basic App (30 mins)

Create minimal `main.dart`:
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text('Test')),
      body: Center(child: Text('Hello')),
    ),
  ));
}
```

Run on device:
```bash
flutter run
```

**Checkpoint:** App launches successfully

#### Step 5: Implement Audio Recording (1 hour)

1. Copy `audio_recorder_service.dart`
2. Create simple test screen:

```dart
ElevatedButton(
  onPressed: () async {
    final recorder = AudioRecorderService();
    await recorder.startRecording();
    await Future.delayed(Duration(seconds: 3));
    final path = await recorder.stopRecording();
    print('Audio saved: $path');
  },
  child: Text('Test Recording'),
)
```

**Checkpoint:** Can record 3-second audio and see file path in console

### Afternoon Session (3 hours)

#### Step 6: Integrate Whisper (1.5 hours)

1. Copy `whisper_service.dart`
2. Test transcription:

```dart
ElevatedButton(
  onPressed: () async {
    final whisper = WhisperService();
    
    // First time will download model (wait 1-2 mins)
    showDialog(context: context, builder: (_) => 
      AlertDialog(content: Text('Downloading model...')));
    
    final text = await whisper.transcribe(audioPath);
    print('Transcribed: $text');
  },
  child: Text('Test Whisper'),
)
```

**Checkpoint:** 
- Model downloads successfully
- Transcription works (even if not perfect)

#### Step 7: Integrate ChatGPT (1 hour)

1. Get API key from OpenAI
2. Copy `chatgpt_service.dart`
3. Test correction:

```dart
ElevatedButton(
  onPressed: () async {
    final chatgpt = ChatGPTService('your_api_key');
    final result = await chatgpt.correctEnglish(
      'I go to school yesterday'
    );
    print('Original: ${result.original}');
    print('Corrected: ${result.corrected}');
    print('Errors: ${result.errors}');
  },
  child: Text('Test ChatGPT'),
)
```

**Checkpoint:** See grammar correction in console

#### Step 8: Build Basic UI (30 mins)

Copy `practice_screen_part1.dart` to `practice_screen.dart` and integrate into `main.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/practice_screen.dart';

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        home: PracticeScreen(),
      ),
    ),
  );
}
```

**Day 1 Goal:** 
- ✅ Can record audio
- ✅ Can transcribe with Whisper
- ✅ Can correct with ChatGPT
- ✅ Basic UI works

---

## Day 2: Polish & Features (Sunday, 4-5 hours)

### Morning Session (2.5 hours)

#### Step 9: Database Integration (1 hour)

1. Copy `database_service.dart`
2. Initialize in `main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService().initialize();
  runApp(...);
}
```

3. Test saving:

```dart
final record = PracticeRecord.fromCorrectionResult(
  audioPath: audioPath,
  transcription: text,
  correction: correction,
);
await DatabaseService().savePractice(record);
```

**Checkpoint:** Can save and retrieve practices from database

#### Step 10: Add Statistics (1 hour)

1. Copy `providers.dart` (contains stats providers)
2. Update UI to show stats:

```dart
// Stats bar is already in practice_screen.dart
// Just ensure providers are working
final todayCount = ref.watch(todayPracticeCountProvider);
```

**Checkpoint:** See today's count, streak, accuracy update after saving

#### Step 11: Error Handling (30 mins)

Add try-catch blocks and user-friendly messages:

```dart
try {
  await someAsyncOperation();
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Error: ${e.toString()}'),
      backgroundColor: Colors.red,
    ),
  );
}
```

### Afternoon Session (1.5 hours)

#### Step 12: UX Polish (1 hour)

1. **Add loading indicators:**
```dart
if (_isProcessing) 
  CircularProgressIndicator()
```

2. **Add haptic feedback:**
```dart
import 'package:flutter/services.dart';

onPressed: () {
  HapticFeedback.lightImpact();
  // action...
}
```

3. **Improve animations:**
- Already has AnimatedContainer for button
- Can add fade transitions for results

#### Step 13: Testing & Bug Fixes (30 mins)

Test all flows:
1. First launch (model download)
2. Record → Transcribe → Correct
3. Save to history
4. View statistics
5. Permission denial handling
6. Network error handling

#### Step 14: Documentation (Optional)

- Update README with your GitHub username
- Add screenshots
- Record demo video (1-2 minutes)

**Day 2 Goal:**
- ✅ Database working
- ✅ Statistics updating
- ✅ Good error handling
- ✅ Polished UX

---

## Common Issues & Solutions

### Issue 1: "Whisper model download fails"

**Solution:**
```dart
// Add retry logic in whisper_service.dart
int retries = 3;
while (retries > 0) {
  try {
    return await _controller.transcribe(...);
  } catch (e) {
    retries--;
    if (retries == 0) rethrow;
    await Future.delayed(Duration(seconds: 2));
  }
}
```

### Issue 2: "Transcription is inaccurate"

**Solutions:**
1. Check audio quality (use phone in quiet room)
2. Speak clearly and not too fast
3. Try different Whisper model sizes
4. Ensure 16kHz sample rate

### Issue 3: "ChatGPT response format wrong"

**Solution:**
```dart
// Add response validation
final content = data['choices'][0]['message']['content'];
if (!content.contains('{')) {
  throw Exception('Invalid response format');
}

// Strip markdown if present
final jsonStr = content
    .replaceAll('```json', '')
    .replaceAll('```', '')
    .trim();
    
final resultJson = jsonDecode(jsonStr);
```

### Issue 4: "App crashes on low-end devices"

**Solutions:**
1. Reduce Whisper threads: `threads: 2`
2. Use smaller model: `WhisperModel.tiny`
3. Add memory warnings

---

## Testing Checklist

Before pushing to GitHub:

### Functionality
- [ ] Can record audio
- [ ] Audio transcribes correctly
- [ ] Grammar correction works
- [ ] Can save to history
- [ ] Statistics update correctly
- [ ] Can clear results and try again

### Edge Cases
- [ ] First launch (model download)
- [ ] Permission denied
- [ ] Network offline (Whisper still works)
- [ ] Invalid API key (shows error)
- [ ] Very short recording (<1 second)
- [ ] Background noise handling

### UX
- [ ] Loading indicators show
- [ ] Error messages are clear
- [ ] Button animations smooth
- [ ] Stats update immediately
- [ ] No lag when recording

---

## Performance Benchmarks

Target metrics on mid-range device (e.g., Pixel 6):

- Model download: <2 minutes (one-time)
- Transcribe 30s audio: <5 seconds
- ChatGPT correction: <2 seconds
- Total flow (record → result): <10 seconds
- App startup: <2 seconds
- Database query: <100ms

If not meeting these, see optimization guide in SETUP.md

---

## Deployment Checklist

### Before releasing:

1. **Security:**
   - [ ] API key not hardcoded
   - [ ] Add ProGuard rules (Android)
   - [ ] Enable code obfuscation

2. **Performance:**
   - [ ] Test on low-end device
   - [ ] Check app size (<100MB without model)
   - [ ] Profile memory usage

3. **Legal:**
   - [ ] Add privacy policy (if collecting data)
   - [ ] Add terms of service
   - [ ] Credit OpenAI and Whisper.cpp

4. **Store Listing:**
   - [ ] Write app description
   - [ ] Take screenshots
   - [ ] Record demo video
   - [ ] Design app icon

---

## Next Features (Post-MVP)

Prioritized by impact:

1. **History Screen** (High impact, 2 hours)
   - View past practices
   - Play back audio
   - Re-review corrections

2. **Progress Charts** (Medium impact, 3 hours)
   - Weekly practice count graph
   - Error type frequency
   - Improvement over time

3. **Custom Topics** (High impact, 4 hours)
   - Daily prompts (describe your day, etc.)
   - Speaking exercises
   - Conversation practice

4. **Pronunciation Scoring** (High impact, 8 hours)
   - Phoneme analysis
   - Word-level feedback
   - Accent reduction tips

5. **Offline Corrections** (Low impact, 12 hours)
   - Local LLM (phi-2 or similar)
   - No API cost
   - Privacy-first

6. **Social Features** (Medium impact, 6 hours)
   - Share progress
   - Leaderboards
   - Study groups

---

## Success Metrics

After 2 weeks of personal use:

- Used app 5+ days/week
- Streak >7 days
- Accuracy improving (70% → 85%+)
- Can speak English more confidently

**If metrics not met:**
- Reduce friction (faster UI)
- Add motivation (streaks, rewards)
- Improve feedback quality

---

## Resources

- [Whisper.cpp GitHub](https://github.com/ggerganov/whisper.cpp)
- [OpenAI API Docs](https://platform.openai.com/docs)
- [Flutter Riverpod](https://riverpod.dev)
- [SQLite Tutorial](https://www.sqlitetutorial.net)

---

Good luck! Remember:

**Done is better than perfect.**

Ship the MVP this weekend, iterate later.
