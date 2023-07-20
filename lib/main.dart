import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ia/colors.dart';
import 'package:flutter_ia/controller/chat_controller.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aliança AI Tryout',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Aliança AI Tryout'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Container(
          width: 900,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Image.asset('assets/images/logo.png', width: 100),
              ),
              const Text("Aliança AI Tryout",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'SourceSansPro',
                  )),
            ],
          ),
        ),
      ),
      body: GetBuilder<ChatController>(
          init: ChatController(),
          builder: (chatController) {
            return LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
                  // Larger screen (web) - Use Row
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        // Use the ListView.builder to display the dynamic list
                        child: ListView.builder(
                          itemCount: chatController.messages.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              tileColor: Colors.grey[200],
                              title: Center(
                                child: SizedBox(
                                  width: 900,
                                  child: Align(
                                    alignment:
                                        chatController.messages[index].isUser
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                    child: Text(chatController
                                        .messages[index].message
                                        .toString()),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Center(
                          child: SizedBox(width: 900, child: ChatGptInput())),
                    ],
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        // Use the ListView.builder to display the dynamic list
                        child: ListView.builder(
                          itemCount: chatController.messages.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              tileColor: Colors.grey[200],
                              title: Center(
                                child: SizedBox(
                                  width: 900,
                                  child: Align(
                                    alignment:
                                        chatController.messages[index].isUser
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                    child: Text(chatController
                                        .messages[index].message
                                        .toString()),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Center(
                          child: SizedBox(width: 900, child: ChatGptInput())),
                    ],
                  );
                }
              },
            );
          }),
    );
  }
}

class ChatGptInput extends StatefulWidget {
  @override
  _ChatGptInputState createState() => _ChatGptInputState();
}

class _ChatGptInputState extends State<ChatGptInput> {
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatController chatController = Get.find();

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent) {
          if (event.isShiftPressed &&
              event.logicalKey == LogicalKeyboardKey.enter) {
            // Shift+Enter is pressed (newline), do nothing
          } else if (!event.isShiftPressed &&
              event.logicalKey == LogicalKeyboardKey.enter) {
            // Enter is pressed (without Shift), handle sending the message
            _handleSendMessage();
          }
        }
      },
      child: Container(
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: AppColors.inputText,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Stack(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 200.0,
                ),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: EdgeInsets.all(12),
                  child: TextField(
                    controller: _textEditingController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    onChanged: (text) {
                      _scrollController
                          .jumpTo(_scrollController.position.maxScrollExtent);
                    },
                    decoration: const InputDecoration.collapsed(
                        hintText: 'Digite sua mensagem...'),
                  ),
                ),
              ),
              Positioned(
                bottom: 0.0,
                right: 0.0,
                child: FloatingActionButton(
                  mini: true,
                  onPressed: _handleSendMessage,
                  child: Icon(Icons.send),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to handle sending the message
  void _handleSendMessage() {
    print(_textEditingController.text);
    chatController.addMessage(_textEditingController.text, true);
    print(chatController.messages);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _textEditingController.clear();
    });
    // Add your logic here to send the message
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
