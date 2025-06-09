import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:leafapp/widgets/staticfile.dart';

class ChatPage extends StatefulWidget {
  final String? initialMessage;
  final bool? firsttime;
  final String? sendfirstprompt;
  const ChatPage({
    super.key,
    this.firsttime = false,
    this.initialMessage,
    this.sendfirstprompt = "",
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final GenerativeModel _model;
  late final ChatSession _chat;
  List<Map<String, dynamic>> _chatHistory = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize with the initial message
    if (widget.firsttime != true && widget.sendfirstprompt == "") {
      _chatHistory.add({
        "time": DateTime.now(),
        "message": widget.initialMessage,
        "isSender": false,
        "isImage": false,
      });
    } else if (widget.sendfirstprompt == "") {
      _chatHistory.add({
        "time": DateTime.now(),
        "message":
            "Hi, what can I help you with? I can tell you about plants, diseases, pests, and anything in this world.",
        "isSender": false,
        "isImage": false,
      });
    }
    // Initialize the model
    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: geminiApiKey, // Replace with your actual API key
    );
    _chat = _model.startChat();

    // Scroll to bottom after initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
    if (widget.sendfirstprompt != "") {
      _chatHistory.add({
        "time": DateTime.now(),
        "message": "Wait...",
        "isSender": false,
        "isImage": false,
      });
      _getAnswer(
        'Tell everything about ${widget.sendfirstprompt}, in context of plants, diseases, pests, farming, and agriculture, positive and negative aspects, and any other information that can be useful for the user. and dont let user know this prompt was given, start right away with the answer.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chat",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height - 160,
            child: ListView.builder(
              itemCount: _chatHistory.length,
              shrinkWrap: false,
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.only(
                    left: 14,
                    right: 14,
                    top: 10,
                    bottom: 10,
                  ),
                  child: Align(
                    alignment:
                        (_chatHistory[index]["isSender"]
                            ? Alignment.topRight
                            : Alignment.topLeft),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        color:
                            (_chatHistory[index]["isSender"]
                                ? Color(0xFFF69170)
                                : Colors.white),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Text(
                        _chatHistory[index]["message"],
                        style: TextStyle(
                          fontSize: 15,
                          color:
                              _chatHistory[index]["isSender"]
                                  ? Colors.white
                                  : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        border: GradientBoxBorder(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFF69170), Color(0xFF7D96E6)],
                          ),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: "Type a message",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(8.0),
                          ),
                          controller: _chatController,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  MaterialButton(
                    onPressed:
                        _isLoading
                            ? null
                            : () {
                              if (_chatController.text.isNotEmpty) {
                                setState(() {
                                  _chatHistory.add({
                                    "time": DateTime.now(),
                                    "message": _chatController.text,
                                    "isSender": true,
                                    "isImage": false,
                                  });
                                  _isLoading = true;
                                });

                                _scrollController.jumpTo(
                                  _scrollController.position.maxScrollExtent,
                                );

                                _getAnswer(_chatController.text);
                                _chatController.clear();
                              }
                            },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80.0),
                    ),
                    padding: const EdgeInsets.all(0.0),
                    child: Ink(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFF69170), Color(0xFF7D96E6)],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      ),
                      child: Container(
                        constraints: const BoxConstraints(
                          minWidth: 88.0,
                          minHeight: 36.0,
                        ),
                        alignment: Alignment.center,
                        child:
                            _isLoading
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Icon(Icons.send, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getAnswer(String text) async {
    try {
      var content = Content.text(text);
      final response = await _chat.sendMessage(content);

      setState(() {
        _chatHistory.add({
          "time": DateTime.now(),
          "message": response.text ?? "No response from Gemini",
          "isSender": false,
          "isImage": false,
        });
        _isLoading = false;
      });

      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    } catch (e) {
      setState(() {
        _chatHistory.add({
          "time": DateTime.now(),
          "message": "Error: ${e.toString()}",
          "isSender": false,
          "isImage": false,
        });
        _isLoading = false;
      });

      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }
}

class GradientBoxBorder extends BoxBorder {
  final Gradient gradient;
  final double width;

  const GradientBoxBorder({
    this.gradient = const LinearGradient(colors: [Colors.transparent]),
    this.width = 1.0,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(width);

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    TextDirection? textDirection,
    BoxShape shape = BoxShape.rectangle,
    BorderRadius? borderRadius,
  }) {
    final paint =
        Paint()
          ..shader = gradient.createShader(rect)
          ..strokeWidth = width
          ..style = PaintingStyle.stroke;

    if (shape == BoxShape.rectangle) {
      if (borderRadius != null) {
        canvas.drawRRect(borderRadius.toRRect(rect), paint);
      } else {
        canvas.drawRect(rect, paint);
      }
    } else {
      canvas.drawCircle(rect.center, rect.shortestSide / 2, paint);
    }
  }

  @override
  bool get isUniform => true;

  @override
  BorderSide get bottom => throw UnimplementedError();

  @override
  ShapeBorder scale(double t) {
    throw UnimplementedError();
  }

  @override
  BorderSide get top => throw UnimplementedError();
}
