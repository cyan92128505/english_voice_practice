# English Voice Practice

AI-powered English learning assistant for practicing speaking with real-time feedback.

## Features

- 🎙️ **Voice Recording**: Press and hold to record your English speech
- 🤖 **AI Transcription**: Offline speech-to-text using Whisper.cpp (small model)
- ✅ **Grammar Correction**: Real-time feedback powered by AI
- 📊 **Practice Statistics**: Track your progress and streaks
- 💾 **History**: Review past practices and improvements
- 🌐 **Works Offline**: Transcription runs locally on device

## Setup Instructions

### Prerequisites

- Flutter SDK 3.x or higher
- Android Studio / VS Code
- AI API key

### Installation

1. Clone the repository:
```bash
git clone https://github.com/cyan92128505/english_voice_practice.git
cd english_voice_practice
```

2. Install dependencies:
```bash
flutter pub get
```

3. Create `.env` file in project root:
```env
AI_API_KEY=your_api_key_here
```

4. Run the app:
```bash
flutter run
```

### First Launch

On first launch, the app will:
1. Request microphone permission
2. Download Whisper small model (~244MB) - takes 1-2 minutes
3. Initialize database

## Usage

1. **Practice Speaking**:
   - Hold the microphone button
   - Speak your English sentence
   - Release to stop recording

2. **Review Feedback**:
   - View transcription of what you said
   - Check grammar corrections if any errors found
   - Read suggestions for better phrasing

3. **Track Progress**:
   - View daily practice count
   - Check your streak
   - Review practice history

## Performance

- **Transcription Speed**: ~3-5 seconds for 30-second audio (on mid-range Android device)
- **Accuracy**: 90%+ for non-native English speakers
- **Model Size**: 244MB (Whisper small model)
- **API Cost**: ~$0.0001 USD per correction

## Supported Platforms

- ✅ Android (ARM64)
- ✅ iOS

## Configuration

### Whisper Model Selection

You can change the model in `whisper_service.dart`:

```dart
// Faster but less accurate
model: WhisperModel.tiny,  // 39MB

// Balanced (recommended)
model: WhisperModel.small,  // 244MB

// More accurate but slower
model: WhisperModel.base,   // 74MB
```

### Thread Count

Adjust processing threads based on device:

```dart
threads: 4,  // High-end devices
threads: 2,  // Low-end devices
```

## Development

### Running Tests

```bash
flutter test
```

### Building for Release

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## License

MIT License - see LICENSE file for details
