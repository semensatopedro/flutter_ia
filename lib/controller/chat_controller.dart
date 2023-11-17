import 'dart:convert';
import 'package:flutter_ia/message.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:http/http.dart' as http;

class ChatController extends GetxController {
  List<Message> _messages = [];
  List<Message> get messages => _messages;

  void addMessage(String content, String role) {
    messages.add(Message(content: content, role: role));
    update();
  }

  Future<void> fetchData() async {
    try {
      final List<Map<String, dynamic>> messagesJson =
          messages.map((message) => message.toJson()).toList();

      final response = await http.post(
        Uri.parse('http://localhost:5002/gpt/openai'),
        headers: {
          "Content-Type": "application/json",
          "Access-Control-Allow-Origin": "*",
        },
        body: json.encode({
          "messages": messagesJson,
        }),
      );

      final Map<String, dynamic> responseBody = json.decode(response.body);
      final String completion = responseBody['completion'];
      //print(response.body);
      if (response.statusCode == 200) {
        messages.add(Message(content: completion, role: "assistant"));
      } else {
        messages.add(Message(
            role: "assistant",
            content:
                "Algum erro inesperado aconteceu. Tente novamente mais tarde"));
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (error) {
      messages.add(Message(
          role: "assistant",
          content:
              "Backend fora do ar. Acione-o para que a aplicação responda normalmente"));
      print('Error fetching data: $error');
    }
    update();
  }

  Future<void> promptGPT(String message) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:5002/langchain'),
        headers: {
          "Content-Type": "application/json",
          "Access-Control-Allow-Origin": "*",
        },
        body: json.encode({
          "message": message,
        }),
      );

      final Map<String, dynamic> responseBody = json.decode(response.body);
      final String completion = responseBody['message'];
      //print(response.body);

      if (response.statusCode == 200) {
        messages.add(Message(content: completion, role: "assistant"));
      } else {
        messages.add(Message(
            role: "assistant",
            content:
                "Algum erro inesperado aconteceu. Tente novamente mais tarde"));
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (error) {
      messages.add(Message(
          role: "assistant",
          content:
              "Backend fora do ar. Acione-o para que a aplicação responda normalmente"));
      print('Error fetching data: $error');
    }
    update();
  }
}
