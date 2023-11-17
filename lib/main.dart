import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ia/colors.dart';
import 'package:flutter_ia/controller/chat_controller.dart';
import 'package:flutter_ia/theme.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Aliança AI Tryout',
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
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
  final ThemeController _themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        shadowColor: Colors.transparent,
        title: Container(
          width: 900,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Image.asset('assets/images/logo.png', width: 100),
              ),
              Obx(
                () => Switch(
                  value: _getSwitchValue(),
                  onChanged: (_) => {_themeController.toggleTheme()},
                ),
              ),
            ],
          ),
        ),
      ),
      body: GetBuilder<ChatController>(
          init: ChatController(),
          builder: (chatController) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  // Use the ListView.builder to display the dynamic list
                  child: ListView.builder(
                    itemCount: chatController.messages.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        //A logica abaixo tem de ser ALTERADA para imprimir a resposta do usuário
                        tileColor: chatController.messages[index].role != "user"
                            ? Theme.of(context).dividerColor
                            : Theme.of(context).dialogBackgroundColor,
                        title: Center(
                          child: SizedBox(
                            width: 900,
                            child: Align(
                              alignment:
                                  //A logica abaixo tem de ser ALTERADA para imprimir a resposta do usuário
                                  chatController.messages[index].role == "user"
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                              child: Text(chatController.messages[index].content
                                  .toString()),
                            ),
                          ),
                        ),
                        contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      );
                    },
                  ),
                ),
                Center(child: SizedBox(width: 900, child: ChatGptInput())),
              ],
            );
          }),
    );
  }

  bool _getSwitchValue() {
    if (_themeController.themeMode.value == ThemeMode.system) {
      // If the theme mode is system, determine the switch value based on the platform's brightness preference
      final brightness = MediaQuery.of(Get.context!).platformBrightness;
      return brightness == Brightness.dark;
    } else {
      // If the theme mode is manually set, return the corresponding switch value
      return _themeController.themeMode.value == ThemeMode.dark;
    }
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
          color: Theme.of(context).inputDecorationTheme.fillColor,
          borderRadius: BorderRadius.circular(10),
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
                  padding: EdgeInsets.all(15),
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
                  child: Icon(
                    Icons.send,
                    color: Theme.of(context).iconTheme.color,
                  ),
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
    //print(_textEditingController.text);
    chatController.addMessage(_textEditingController.text, "user");
    //chatController.fetchData();
    chatController.promptGPT(_textEditingController.text);
    // print(chatController.messages);
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
