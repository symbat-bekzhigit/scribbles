import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  Future<String?> fetchChatGPTCompletion(String prompt) async {
    final String apiKey = 'api_key'; // add api key here, can't push with it.
    final String model = 'gpt-3.5-turbo-instruct';
    final String endpoint = 'https://api.openai.com/v1/completions';
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    final Map<String, dynamic> body = {
      'model': model,
      'prompt': prompt,
      'max_tokens': 250, 
    };

    final response = await http.post(
      Uri.parse(endpoint),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final String? completion =
          jsonResponse['choices'][0]['text']; 
      return completion;
    } else {
      throw Exception('Failed to load completion');
    }
  }

  void _getGPTResponse() async {

    String prompt = "";

    if (widget.category == "Summarize"){
      prompt = "Can you make 3 sentences maximum in A PARAGRAPH mentioning ONLY the name, blood type, known medical conditions and allergies mentioned here, NO OTHER INFORMATION: ${widget.ehrData["firstName"]}, ${widget.ehrData["lastName"]}, ${widget.ehrData["bloodType"]}, ${widget.ehrData["knownMedicalConditions"]}, ${widget.ehrData["allergies"]}}";
    }

    if (widget.category == "AI Analysis"){
      prompt = "Can you make 3 sentences maximum in A PARAGRAPH analyzing ONLY, AND I REPEAT ONLY, the known medical conditions, NO OTHER INFORMATION: ${widget.ehrData["firstName"]}, ${widget.ehrData["knownMedicalConditions"]}";
    }
    
    try {
      final String? completion = await fetchChatGPTCompletion(prompt);
      setState(() {
        _response = completion ?? "No completion";
      });
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
