# English Voice Practice

AI-powered English learning assistant for practicing speaking with real-time feedback.

## Features

- 🎙️ **Voice Recording**: Press and hold to record your English speech
- 🤖 **AI Transcription**: Offline speech-to-text using Whisper.cpp (small model)
- ✅ **Grammar Correction**: Real-time feedback powered by GPT-4o-mini
- 📊 **Practice Statistics**: Track your progress and streaks
- 💾 **History**: Review past practices and improvements
- 🌐 **Works Offline**: Transcription runs locally on device

## Tech Stack

- **Frontend**: Flutter 3.x + Riverpod 2.x
- **Speech Recognition**: whisper_ggml (Whisper.cpp binding)
- **AI Correction**: OpenAI GPT-4o-mini API
- **Local Storage**: sqflite for practice history
- **Audio Recording**: record package

## Architecture

```
┌─────────────────────────────────────────────┐
│            Presentation Layer               │
│  ┌──────────────┐    ┌──────────────┐      │
│  │ Practice     │    │ History      │      │
│  │ Screen       │    │ Screen       │      │
│  └──────────────┘    └──────────────┘      │
└─────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────┐
│            Business Logic Layer             │
│  ┌──────────────┐    ┌──────────────┐      │
│  │ Whisper      │    │ ChatGPT      │      │
│  │ Service      │    │ Service      │      │
│  └──────────────┘    └──────────────┘      │
│  ┌──────────────┐    ┌──────────────┐      │
│  │ Audio        │    │ Database     │      │
│  │ Recorder     │    │ Service      │      │
│  └──────────────┘    └──────────────┘      │
└─────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────┐
│              Data Layer                     │
│  ┌──────────────┐    ┌──────────────┐      │
│  │ Local Files  │    │ SQLite DB    │      │
│  │ (.wav audio) │    │ (history)    │      │
│  └──────────────┘    └──────────────┘      │
└─────────────────────────────────────────────┘
```

## Project Structure

```
lib/
├── main.dart
├── models/
│   ├── correction_result.dart
│   └── practice_record.dart
├── screens/
│   ├── practice_screen.dart
│   ├── history_screen.dart
│   └── settings_screen.dart
├── services/
│   ├── whisper_service.dart
│   ├── audio_recorder_service.dart
│   ├── chatgpt_service.dart
│   └── database_service.dart
├── providers/
│   └── providers.dart
└── widgets/
    ├── record_button.dart
    ├── result_card.dart
    └── stats_bar.dart
```

## Setup Instructions

### Prerequisites

- Flutter SDK 3.x or higher
- Android Studio / VS Code
- OpenAI API key

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
OPENAI_API_KEY=your_api_key_here
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
- ✅ macOS
- ❌ Windows (Whisper model not supported)
- ❌ Linux (Whisper model not supported)

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

## Roadmap

- [ ] Add pronunciation scoring
- [ ] Support more languages
- [ ] Offline ChatGPT alternative (local LLM)
- [ ] Export practice history
- [ ] Social features (share progress)

## Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Commit your changes (follow conventional commits)
4. Push to the branch
5. Open a Pull Request

## License

MIT License - see LICENSE file for details

## Credits

- [Whisper.cpp](https://github.com/ggerganov/whisper.cpp) - Speech recognition
- [OpenAI](https://openai.com) - GPT-4o-mini API
- [whisper_ggml](https://pub.dev/packages/whisper_ggml) - Flutter binding

## Author

**廖瑋薪 (Aoma Liao)**
- GitHub: [@cyan92128505](https://github.com/cyan92128505)
- Email: cyan92128505@gmail.com

## Support

If you find this project helpful:
- ⭐ Star this repository
- 🐛 Report bugs via Issues
- 💡 Suggest features via Discussions

---

**Built with ❤️ for English learners**
