import 'package:flutter/material.dart';
import 'dart:js' as js;

class ChatbotScreen extends StatefulWidget {
  final String chatbotId; // Your Chatbase chatbot ID
  const ChatbotScreen({super.key, required this.chatbotId});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadChatbaseScript();
  }

  void _loadChatbaseScript() {
    try {
      js.context.callMethod('eval', [
        '''
        (function() {
          function loadChatbase() {
            const script = document.createElement('script');
            script.src = 'https://www.chatbase.co/embed.min.js';
            script.id = 'a_t4Hm6RM6VVtTkPm9DFX';
            script.setAttribute('data-chatbot-id', '${widget.chatbotId}');
            script.setAttribute('data-domain', 'www.chatbase.co');
            script.onerror = function() {
              console.error('Chatbase failed to load');
              // Notify Flutter of the error
              if (window.flutterWebRenderer) {
                flutterWebRenderer.postMessage('chatbaseError');
              }
            };
            document.body.appendChild(script);
          }
          
          if (document.readyState === 'complete') {
            loadChatbase();
          } else {
            window.addEventListener('load', loadChatbase);
          }
        })();
        '''
      ]);

      // Optional: Listen for JS errors (if using Flutter Web renderer)
      js.context['flutterWebRenderer'] = {
        'postMessage': (String message) {
          if (message == 'chatbaseError') {
            setState(() {
              _hasError = true;
              _isLoading = false;
            });
          }
        }
      };

      // Simulate loading delay (remove if unnecessary)
      Future.delayed(const Duration(seconds: 2), () {
        if (!_hasError) {
          setState(() => _isLoading = false);
        }
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatbot'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Placeholder for the chatbot (script will render here)
          const SizedBox.expand(),

          // Loading/Error UI
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
          if (_hasError)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    'Failed to load chatbot',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadChatbaseScript,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}