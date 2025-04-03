import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(KidDoodleApp());
}

class KidDoodleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KidDoodle 🎨',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.blueGrey[900],
        primaryColor: Colors.orangeAccent,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login(BuildContext context) {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatbotScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("😱 Oops! Enter valid credentials!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text("🎨 KidDoodle 🎨", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.orangeAccent)),
              SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "📧 Email", filled: true, fillColor: Colors.white),
              ),
              SizedBox(height: 15),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: "🔒 Password", filled: true, fillColor: Colors.white),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => login(context),
                child: Text("🚀 Let's Doodle!", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatbotScreen extends StatefulWidget {
  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController messageController = TextEditingController();
  List<Map<String, String>> messages = [];

  final String webhookUrl = "https://your-ai-image-generator.com/api"; // Replace with your webhook

  List<String> promptSuggestions = [
    "A superhero dog flying in space! 🚀🐶",
    "A mermaid playing a guitar! 🎸🧜‍♀️",
    "A friendly monster eating candy! 🍭👹",
    "A castle made of jelly! 🏰🍮",
    "A robot watering a garden! 🤖🌱",
  ];

  @override
  void initState() {
    super.initState();
    messages.add({"role": "bot", "content": "🎨 Hi there, friend! I'm Doodle Bot! 🎈\nTell me what to draw, and I'll make it magical! ✨"});
  }

  void sendMessage(String userMessage) async {
    setState(() {
      messages.add({"role": "user", "content": "👦 You: $userMessage"});
      messages.add({"role": "bot", "content": "🤖 DoodleBot: Generating your doodle... 🎨✨"});
    });

    try {
      final response = await http.post(
        Uri.parse(webhookUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"prompt": userMessage}),
      );

      if (response.statusCode == 200) {
        setState(() {
          messages.add({"role": "bot", "content": "🌟 Your doodle is ready! Try another one? 🎨"});
        });
      } else {
        setState(() {
          messages.add({"role": "bot", "content": "⚠️ Oops! Something went wrong!"});
        });
      }
    } catch (e) {
      setState(() {
        messages.add({"role": "bot", "content": "❌ Error connecting to AI!"});
      });
    }
  }

  void logout() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("🎨 KidDoodle Chat"),
        backgroundColor: Colors.orangeAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: logout,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(messages[index]["content"] ?? "", style: TextStyle(color: Colors.white)));
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                Wrap(
                  spacing: 10,
                  children: promptSuggestions.map((suggestion) {
                    return ElevatedButton(
                      onPressed: () => sendMessage(suggestion),
                      child: Text(suggestion, style: TextStyle(fontSize: 12)),
                    );
                  }).toList(),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(labelText: "📝 What should I draw?", filled: true, fillColor: Colors.white),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send, color: Colors.orangeAccent),
                      onPressed: () => sendMessage(messageController.text),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }





