import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LearnPage extends StatefulWidget {
  const LearnPage({super.key});

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  final List<Map<String, dynamic>> categories = [
    {
      "title": "الإنتاج النباتي",
      "icon": Icons.eco,
      "color": Colors.green,
      "gradient": [Color(0xFF4CAF50), Color(0xFF81C784)],
    },
    {
      "title": "الإنتاج الحيواني",
      "icon": Icons.agriculture,
      "color": Colors.brown,
      "gradient": [Color(0xFF795548), Color(0xFFA1887F)],
    },
    {
      "title": "التمويل والدعم",
      "icon": Icons.account_balance_wallet,
      "color": Colors.teal,
      "gradient": [Color(0xFF009688), Color(0xFF4DB6AC)],
    },
    {
      "title": "التحويل الغذائي",
      "icon": Icons.restaurant,
      "color": Colors.indigo,
      "gradient": [Color(0xFF3F51B5), Color(0xFF7986CB)],
    },
    {
      "title": "التسويق الرقمي",
      "icon": Icons.phone_android,
      "color": Colors.orange,
      "gradient": [Color(0xFFFF9800), Color(0xFFFFB74D)],
    },
    {
      "title": "التعاونيات",
      "icon": Icons.groups,
      "color": Colors.pink,
      "gradient": [Color(0xFFE91E63), Color(0xFFF48FB1)],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "تعلم",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.95,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryDetailPage(
                      title: category["title"] ?? "صفحة",
                      icon: category["icon"],
                      gradient: category["gradient"],
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: category["gradient"],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: category["color"].withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Icon(
                        category["icon"],
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        category["title"],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CategoryDetailPage extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Color> gradient;

  const CategoryDetailPage({
    super.key,
    required this.title,
    required this.icon,
    required this.gradient,
  });

  List<Map<String, dynamic>> _getContentForCategory(String title) {
    switch (title) {
      case "الإنتاج النباتي":
        return [
          {
            "type": "video",
            "title": "Cactus et Figuier de Barbarie",
            "description": "دليل شامل لزراعة الصبار والتين الشوكي",
            "duration": "20 دقيقة",
            "thumbnail": Icons.play_circle_filled,
            "url": "https://www.youtube.com/watch?v=1rrsn9-73LA",
          },
          {
            "type": "video",
            "title": "زراعة التربة والمحافظة عليها",
            "description": "تقنيات وطرق المحافظة على صحة التربة الزراعية",
            "duration": "12 دقيقة",
            "thumbnail": Icons.play_circle_filled,
            "url": "https://www.youtube.com/watch?v=Kw4CRCEC16A",
          },
          {
            "type": "article",
            "title": "تحليل البيئة للإنتاج النباتي",
            "description": "دراسة شاملة عن البيئة والإنتاج الزراعي في تونس",
            "readTime": "30 دقيقة",
            "thumbnail": Icons.description,
            "url": "https://upadi.ca/fileadmin/UPADI/Analyse_Env_PSSEETAT_VF_SansAnnexe_Externe.pdf",
          },
        ];
      case "الإنتاج الحيواني":
        return [
          {
            "type": "video",
            "title": "الصحة البيطرية",
            "description": "الأمراض الشائعة وطرق الوقاية",
            "duration": "20 دقيقة",
            "thumbnail": Icons.play_circle_filled,
          },
        ];
      case "التمويل والدعم":
        return [
          {
            "type": "resource",
            "title": "اكتشف برنامج رايدت",
            "description": "برنامج دعم وتمويل المشاريع الفلاحية والريفية",
            "thumbnail": Icons.business_center,
            "url": "https://www.raidet.tn/ar/decouvrir-raidet",
          },
          {
            "type": "resource",
            "title": "مراكز التكوين في القطاع الفلاحي",
            "description": "دليل مراكز التدريب والتكوين الفلاحي في تونس",
            "thumbnail": Icons.school,
            "url": "https://www.raidet.tn/fr/formation/les-centres-de-formation-dans-la-filiere-agricole",
          },
          {
            "type": "video",
            "title": "دعم الشباب لإطلاق المشاريع",
            "description": "برامج ومبادرات دعم المشاريع الشبابية",
            "duration": "8 دقائق",
            "thumbnail": Icons.play_circle_filled,
            "url": "https://www.youtube.com/watch?v=FvBKVUCxMto",
          },
          {
            "type": "article",
            "title": "تعزيز التمويل وريادة الأعمال",
            "description": "دليل شامل للحصول على التمويل وتطوير المشاريع",
            "readTime": "25 دقيقة",
            "thumbnail": Icons.account_balance_wallet,
            "url": "https://upadi.ca/fileadmin/UPADI/PSSEETAT/Renforcer_le_financement_et_l_entrepreneuriat.pdf",
          },
          {
            "type": "video",
            "title": "فرص التمويل للمشاريع الصغيرة",
            "description": "شرح مفصل لآليات التمويل المتاحة",
            "duration": "15 دقيقة",
            "thumbnail": Icons.play_circle_filled,
            "url": "https://www.youtube.com/watch?v=FUxBQRnyeQg",
          },
        ];
      case "التحويل الغذائي":
        return [
          {
            "type": "article",
            "title": "تصنيع منتجات الألبان",
            "description": "الجبن، الزبدة والياغورت محلي الصنع",
            "readTime": "8 دقائق",
            "thumbnail": Icons.bakery_dining,
          },
          {
            "type": "video",
            "title": "معايير السلامة الغذائية",
            "description": "شروط النظافة والجودة في الإنتاج",
            "duration": "10 دقائق",
            "thumbnail": Icons.play_circle_filled,
          },
        ];
      case "التسويق الرقمي":
        return [
          {
            "type": "video",
            "title": "البيع عبر فيسبوك",
            "description": "إنشاء صفحة ناجحة وجذب الزبائن",
            "duration": "16 دقيقة",
            "thumbnail": Icons.play_circle_filled,
          },
        ];
      case "التعاونيات":
        return [
          {
            "type": "video",
            "title": "قصة نجاح تعاونية نسائية",
            "description": "تجربة ملهمة لتعاونية نسائية ناجحة",
            "duration": "18 دقيقة",
            "thumbnail": Icons.play_circle_filled,
            "url": "https://www.youtube.com/watch?v=lGyK0qkpb24",
          },
          {
            "type": "video",
            "title": "نموذج تعاونية زراعية ناجحة",
            "description": "قصة نجاح تعاونية في القطاع الفلاحي",
            "duration": "15 دقيقة",
            "thumbnail": Icons.play_circle_filled,
            "url": "https://www.youtube.com/watch?v=Sn9nnCnoSNY",
          },
          {
            "type": "video",
            "title": "التعاونيات الفلاحية في تونس",
            "description": "دور التعاونيات في تطوير القطاع الفلاحي",
            "duration": "12 دقيقة",
            "thumbnail": Icons.play_circle_filled,
            "url": "https://www.youtube.com/watch?v=iUz2P_mXMU4",
          },
          {
            "type": "video",
            "title": "تعاونية نسائية رائدة",
            "description": "نموذج ناجح لتمكين المرأة الريفية",
            "duration": "10 دقائق",
            "thumbnail": Icons.play_circle_filled,
            "url": "https://www.youtube.com/watch?v=Og3LUJq33A8",
          },
          {
            "type": "video",
            "title": "إنشاء وإدارة التعاونيات",
            "description": "الخطوات العملية لتأسيس تعاونية ناجحة",
            "duration": "20 دقيقة",
            "thumbnail": Icons.play_circle_filled,
            "url": "https://youtu.be/1YqUtkpMsiQ",
          },
        ];
      default:
        return [];
    }
  }

  Future<void> _launchURL(String url, BuildContext context) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('لا يمكن فتح الرابط'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final contents = _getContentForCategory(title);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3,
                      color: Colors.black26,
                    ),
                  ],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: 80,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final content = contents[index];
                  return _buildContentCard(content, context);
                },
                childCount: contents.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard(Map<String, dynamic> content, BuildContext context) {
    IconData typeIcon;
    Color typeColor;
    String typeLabel;

    switch (content["type"]) {
      case "video":
        typeIcon = Icons.play_circle_outline;
        typeColor = Colors.red;
        typeLabel = "فيديو";
        break;
      case "article":
        typeIcon = Icons.article_outlined;
        typeColor = Colors.blue;
        typeLabel = "مقال";
        break;
      case "resource":
        typeIcon = Icons.folder_open;
        typeColor = Colors.orange;
        typeLabel = "مورد";
        break;
      default:
        typeIcon = Icons.help_outline;
        typeColor = Colors.grey;
        typeLabel = "محتوى";
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          if (content["url"] != null) {
            _launchURL(content["url"], context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${content["title"]} - لا يوجد رابط متاح'),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  content["thumbnail"],
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: typeColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(typeIcon, size: 14, color: typeColor),
                              const SizedBox(width: 4),
                              Text(
                                typeLabel,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: typeColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      content["title"],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      content["description"],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (content["duration"] != null ||
                        content["readTime"] != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            content["duration"] ?? content["readTime"] ?? "",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}