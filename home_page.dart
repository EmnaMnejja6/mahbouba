import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:audioplayers/audioplayers.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _avatarController;
  late AnimationController _pulseController;
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  // Speech Recognition (not used, just for mic animation)
  late AudioPlayer _audioPlayer;

  bool isListening = false;
  bool isAvatarTalking = false;
  String currentMotivation = "أهلاً بك فاطمة! كيف يمكنني مساعدتك اليوم؟";
  String avatarResponse = "";
  String _recognizedText = "";

  // Audio file cycling
  int _currentAudioIndex = 0;
  final List<String> _audioFiles = ['1.wav', '2.wav', '3.wav'];
  final List<String> _audioResponses = [
    'عسلامة',
    'وقتاش أحسن وقت نغرسو فيه الطماطم',
    'قداش سوم الفلفل هالأيامات'
  ];

  // Weather updates related to agriculture
  final List<String> _weatherUpdates = [
    '🌤️ الطقس اليوم معتدل، وقت مناسب للري الصباحي',
    '☀️ حرارة عالية متوقعة، زيدي كمية الماء للزرع',
    '🌧️ أمطار خفيفة متوقعة، إستنّي شوية قبل ما تسقي',
    '💨 رياح قوية اليوم، حاول تثبّتي الشتلات الصغار',
    '🌡️ جو بارد الليلة، غطّي الزرع الحساس',
    '☁️ جو غائم ورطوبة عالية، راقبي الأمراض الفطرية',
    '🌅 أحسن وقت للزراعة: الصباح الباكر أو بعد العصر',
  ];

  List<String> motivationalQuotes = [
    "جنينتك الصغيرة تنجّم تولّي مصدر رزقك الكبير",
    "إنتي صاحبة مشروع",
    "النجاح يبدا من دارك، وإنتي قادرة",
    "اليوم خدّامة، غدوة صاحبة مشروع",
    "ثمن عملك يحدّدو قيمتك، موش حاجة الناس",
    "من دارك، إبني مستقبلك",
  ];

  @override
  void initState() {
    super.initState();
    _initializeServices();

    _avatarController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _pulseController = AnimationController(vsync: this, duration: Duration(seconds: 1));
    _bounceController = AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _bounceAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );

    Timer.periodic(Duration(seconds: 8), (timer) {
      if (mounted && !isAvatarTalking) {
        // Mix motivational quotes with weather updates
        bool showWeather = Random().nextInt(3) == 0; // 33% weather, 67% motivation
        setState(() {
          if (showWeather) {
            currentMotivation = _weatherUpdates[Random().nextInt(_weatherUpdates.length)];
          } else {
            currentMotivation = motivationalQuotes[Random().nextInt(motivationalQuotes.length)];
          }
        });
      }
    });

    Timer(Duration(milliseconds: 500), () {
      _bounceController.forward();
    });
  }

  Future<void> _initializeServices() async {
    _audioPlayer = AudioPlayer();

    // Listen for audio completion
    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          isAvatarTalking = false;
          _avatarController.stop();
        });
      }
    });
  }

  @override
  void dispose() {
    _avatarController.dispose();
    _pulseController.dispose();
    _bounceController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _startListening() async {
    setState(() {
      isListening = true;
      _recognizedText = ""; // Start with empty text
    });
    _pulseController.repeat();

    // Simulate processing - show text gradually
    await Future.delayed(Duration(milliseconds: 800));

    if (!mounted) return;
    setState(() {
      _recognizedText = _audioResponses[_currentAudioIndex];
    });

    // Keep showing the text for a moment
    Timer(Duration(milliseconds: 1500), () async {
      if (!mounted) return;
      setState(() => isListening = false);
      _pulseController.stop();

      // Play audio response
      _playAudioResponse();
    });
  }

  Future<void> _playAudioResponse() async {
    // Randomly decide if we show weather update or just play audio
    bool showWeather = Random().nextInt(4) == 0; // 25% chance for weather

    setState(() {
      isAvatarTalking = true;
      _recognizedText = ""; // Clear the recognized text
      if (showWeather) {
        avatarResponse = _weatherUpdates[Random().nextInt(_weatherUpdates.length)];
      } else {
        avatarResponse = "جاري الرد...";
      }
    });

    try {
      // Stop any currently playing audio
      await _audioPlayer.stop();

      // Play the current audio file
      await _audioPlayer.play(AssetSource(_audioFiles[_currentAudioIndex]));

      _avatarController.repeat();

      // Move to next audio file (cycle through 1, 2, 3)
      _currentAudioIndex = (_currentAudioIndex + 1) % _audioFiles.length;

    } catch (e) {
      print('Error playing audio: $e');
      setState(() {
        avatarResponse = "عذراً، حدث خطأ في تشغيل الصوت.";
        isAvatarTalking = false;
      });
      _avatarController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2E7D32), Color(0xFF43A047)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'أهلاً وسهلاً فاطمة 👋',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 🟢 بطاقة المقولة التحفيزية
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.2),
                  blurRadius: 6,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child: Text(
                isAvatarTalking ? avatarResponse : currentMotivation,
                key: ValueKey(isAvatarTalking ? avatarResponse : currentMotivation),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isAvatarTalking ? Color(0xFF2E7D32) : Color(0xFFE65100),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // Show recognized text while listening
          if (isListening && _recognizedText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _recognizedText,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue.shade700,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),

          SizedBox(height: 30),

          // 🟢 الأفاتار الكبير في الوسط
          Expanded(
            child: Center(
              child: ScaleTransition(
                scale: _bounceAnimation,
                child: AnimatedBuilder(
                  animation: _avatarController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: isAvatarTalking ? 1 + (0.05 * sin(_avatarController.value * 2 * pi)) : 1,
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: isAvatarTalking
                            ? Colors.green.shade600
                            : isListening
                            ? Colors.blue.shade600
                            : Colors.green.shade300,
                        child: Text(
                          isAvatarTalking ? '🗣️' : isListening ? '👂' : '👩‍🌾',
                          style: TextStyle(fontSize: 60),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          SizedBox(height: 20),

          // 🟢 زر الميكروفون للتسجيل
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: FloatingActionButton(
              onPressed: isListening || isAvatarTalking ? null : _startListening,
              backgroundColor: isListening ? Colors.redAccent : Colors.blueAccent,
              child: Icon(
                isListening ? Icons.stop : Icons.mic,
                size: 32,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}