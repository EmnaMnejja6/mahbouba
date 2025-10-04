import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AssistantChoicePage extends StatefulWidget {
  const AssistantChoicePage({Key? key}) : super(key: key);

  @override
  State<AssistantChoicePage> createState() => _AssistantChoicePageState();
}

class _AssistantChoicePageState extends State<AssistantChoicePage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _selectedAssistant;

  Future<void> _playAudio(String audioFile) async {
    try {
      await _audioPlayer.play(AssetSource(audioFile));
    } catch (e) {
      print('خطأ في تشغيل الصوت: $e');
    }
  }

  void _selectAssistant(String assistant, String audioFile) {
    setState(() {
      _selectedAssistant = assistant;
    });
    _playAudio(audioFile);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 0,
        title: const Text(
          'اختاري مساعدتك الذكية',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'اختاري المساعدة الزراعية التي تناسبك',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1B4332),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'انقري على كل مساعدة للاستماع إلى تحيتها',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF52796F),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildAssistantCard(
                      name: 'محبوبة',
                      description: 'مساعدتك الودودة في كل ما يتعلق بالزراعة',
                      icon: Icons.eco,
                      color: const Color(0xFF52B788),
                      audioFile: 'mahbouba.wav',
                      isSelected: _selectedAssistant == 'محبوبة',
                    ),
                    const SizedBox(height: 30),
                    _buildAssistantCard(
                      name: 'نسيمة',
                      description: 'خبيرتك في النصائح الزراعية الذكية',
                      icon: Icons.spa,
                      color: const Color(0xFF40916C),
                      audioFile: 'nsima.wav',
                      isSelected: _selectedAssistant == 'نسيمة',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _selectedAssistant != null
                      ? () {
                    // التنقل إلى الصفحة الرئيسية
                    Navigator.pushReplacementNamed(
                      context,
                      '/mainnavigation',
                      arguments: _selectedAssistant,
                    );
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    disabledBackgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    _selectedAssistant != null
                        ? 'ابدئي مع $_selectedAssistant'
                        : 'اختاري مساعدة أولاً',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _selectedAssistant != null
                          ? Colors.white
                          : Colors.grey[600],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAssistantCard({
    required String name,
    required String description,
    required IconData icon,
    required Color color,
    required String audioFile,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => _selectAssistant(name, audioFile),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? color.withOpacity(0.3)
                  : Colors.black.withOpacity(0.1),
              blurRadius: isSelected ? 15 : 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 50,
                color: color,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF52796F),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 24,
                ),
              ),
          ],
        ),
      ),
    );
  }
}