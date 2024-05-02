import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:chat_gpt_api/chat_gpt.dart';

class AIPage extends StatefulWidget {
  final String category;
  final Map<String, dynamic> ehrData;

  const AIPage({
    super.key,
    required this.category,
    required this.ehrData,
  });

  @override
  _AIPageState createState() => _AIPageState();
}

class _AIPageState extends State<AIPage> {
  String _response = 'Press the button to get a response';
  late ChatGPT chatGpt;

  @override
  void initState() {
    super.initState();
    chatGpt = ChatGPT.builder(
      token: "",
    );
  }

  void _getGPTResponse() async {
    String prompt = json.encode(widget.ehrData) + widget.category;
    prompt = "What is the diagnosis for this patient?";
    try {
      Completion? completion = await chatGpt.textCompletion(
        request: CompletionRequest(
          prompt: prompt,
          maxTokens: 256,
        ),
      );

      if (completion != null && completion.choices!.isNotEmpty) {
        setState(() {
          _response = completion.choices!.first.text!.trim();
        });
      }else {
        setState(() {
          _response = "No completion found.";
        });
      }
    } catch (e) {
      setState(() {
        _response = "Failed to get response: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Page"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _getGPTResponse,
              child: const Text('Get GPT Response'),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(_response, textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}
