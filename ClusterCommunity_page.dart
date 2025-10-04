import 'package:flutter/material.dart';

class ClusterCommunityPage extends StatefulWidget {
  const ClusterCommunityPage({super.key});

  @override
  State<ClusterCommunityPage> createState() => _ClusterCommunityPageState();
}

class _ClusterCommunityPageState extends State<ClusterCommunityPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> messages = [
    {
      "name": "Amina",
      "avatar": "https://i.pravatar.cc/150?img=5",
      "message": "صباح الخير جماعة ☀️ الجو اليوم مغيم شوية، برشة ريح.",
      "time": "8:45 ص",
      "isMe": false,
    },
    {
      "name": "Fatma",
      "avatar": "https://i.pravatar.cc/150?img=6",
      "message": "صحيح، الريح هكّاكة النحل ما يخرجش برشا من الخلايا 🐝",
      "time": "8:47 ص",
      "isMe": false,
    },
    {
      "name": "أنا",
      "avatar": "https://i.pravatar.cc/150?img=1",
      "message": "بركة اللي الشمس تطلع بعد شوية، النحل ديما يحب السخانة.",
      "time": "8:50 ص",
      "isMe": true,
    },
    {
      "name": "Sara",
      "avatar": "https://i.pravatar.cc/150?img=7",
      "message": "أنا لاحظت العسل نقص شوية هالأيام... يمكن خاتر الزهور ولّت قليلة؟ 🌸",
      "time": "9:05 ص",
      "isMe": false,
    },
    {
      "name": "Mouna",
      "avatar": "https://i.pravatar.cc/150?img=8",
      "message": "إي، في الخريف لازم تدعموهم بالسكر السائل شوية، باش ما يضعفوش 🥣",
      "time": "9:12 ص",
      "isMe": false,
    },
    {
      "name": "Amina",
      "avatar": "https://i.pravatar.cc/150?img=5",
      "message": "أنا عملت هكا العام اللي فات، والله الخلية متاعي قاومت للشتاء بالقدا 💪🍯",
      "time": "9:18 ص",
      "isMe": false,
    },
  ];


  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      messages.add({
        "name": "أنا",
        "avatar": "https://i.pravatar.cc/150?img=1",
        "message": _messageController.text.trim(),
        "time": "الآن",
        "isMe": true,
      });
    });

    _messageController.clear();

    // Auto scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Stack(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.groups, color: Colors.white),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "مجموعة النساء الفلاحات",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "4 أعضاء نشيطين",
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green[100],
        foregroundColor: Colors.black87,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Info Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.green[50],
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.green[700]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "هذه مجموعة آمنة لتبادل النصائح الزراعية",
                    style: TextStyle(fontSize: 12, color: Colors.green[900]),
                  ),
                ),
              ],
            ),
          ),

          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isMe = msg["isMe"] as bool;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment:
                    isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isMe) ...[
                        CircleAvatar(
                          backgroundImage: NetworkImage(msg["avatar"]!),
                          radius: 18,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: Column(
                          crossAxisAlignment: isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            if (!isMe)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4, right: 4),
                                child: Text(
                                  msg["name"]!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[700],
                                  ),
                                ),
                              ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isMe ? Colors.green : Colors.grey[200],
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(20),
                                  topRight: const Radius.circular(20),
                                  bottomLeft: Radius.circular(isMe ? 20 : 4),
                                  bottomRight: Radius.circular(isMe ? 4 : 20),
                                ),
                              ),
                              child: Text(
                                msg["message"]!,
                                style: TextStyle(
                                  color: isMe ? Colors.white : Colors.black87,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4, right: 8, left: 8),
                              child: Text(
                                msg["time"]!,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isMe) ...[
                        const SizedBox(width: 8),
                        CircleAvatar(
                          backgroundImage: NetworkImage(msg["avatar"]!),
                          radius: 18,
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),

          // Message Input
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.add_circle_outline, color: Colors.green[700]),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: "اكتبي رسالتك...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      textDirection: TextDirection.rtl,
                      maxLines: null,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.green,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white, size: 20),
                      onPressed: _sendMessage,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.mic, color: Colors.green[700]),
                    onPressed: () {
                      // Voice message feature
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("ميزة الرسائل الصوتية قريباً"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}