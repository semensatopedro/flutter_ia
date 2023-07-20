import 'package:flutter/material.dart';
import 'package:flutter_ia/message.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ChatController extends GetxController {
  List<Message> _messages = [];
  List<Message> get messages => _messages;

  void addMessage(String message, bool isUser) {
    messages.add(Message(message: message, isUser: isUser));
    update();
  }
}
