import 'package:flutter/material.dart';
import '../models/product.dart';

class ChatScreen extends StatefulWidget {
  final Product product;

  const ChatScreen({super.key, required this.product});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _messages.add({
      'text':
          'Hoi! Ik ben de ShopAI assistant. Ik zie dat je kijkt naar de ${widget.product.title}. Heb je daar vragen over?',
      'isUser': false,
    });
  }

  void _handleSend() async {
    if (_controller.text.trim().isEmpty) return;

    final userText = _controller.text;
    _controller.clear();

    setState(() {
      _messages.add({'text': userText, 'isUser': true});
      _isTyping = true;
    });

    // Simuleer een AI antwoord
    await Future.delayed(const Duration(seconds: 2));

    String aiResponse = _generateResponse(userText);

    if (mounted) {
      setState(() {
        _isTyping = false;
        _messages.add({'text': aiResponse, 'isUser': false});
      });
    }
  }

  String _generateResponse(String input) {
    input = input.toLowerCase();
    if (input.contains('prijs') ||
        input.contains('duur') ||
        input.contains('kosten')) {
      return 'De huidige prijs van dit product is €${widget.product.price.toStringAsFixed(2)}. Een top deal voor deze kwaliteit!';
    } else if (input.contains('maat') || input.contains('groot')) {
      return 'Voor dit product hebben we verschillende maten beschikbaar. Check de Size Guide voor de exacte afmetingen!';
    } else if (input.contains('levering') || input.contains('bezorgen')) {
      return 'Als je vandaag bestelt, heb je het meestal binnen 1-2 werkdagen in huis!';
    } else if (input.contains('kleur')) {
      return 'We hebben momenteel verschillende kleuropties. De filter op de pagina laat je zien hoe ze eruit zien!';
    } else {
      return 'Dat is een goede vraag over de ${widget.product.title}! Onze klanten zijn er erg tevreden over, vooral vanwege de ${widget.product.category}. Kan ik je nog ergens anders mee helpen?';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.product.image),
              radius: 16,
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ShopAI Assistant',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('Online',
                    style: TextStyle(fontSize: 12, color: Colors.green)),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildMessage(msg['text'], msg['isUser']);
              },
            ),
          ),
          if (_isTyping)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text('AI is aan het typen...',
                      style: TextStyle(
                          fontStyle: FontStyle.italic, color: Colors.grey)),
                ],
              ),
            ),
          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildMessage(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF6C63FF) : Colors.grey[200],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 16),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(color: isUser ? Colors.white : Colors.black87),
        ),
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 10)
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Stel een vraag...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                onSubmitted: (_) => _handleSend(),
              ),
            ),
            const SizedBox(width: 12),
            CircleAvatar(
              backgroundColor: const Color(0xFF6C63FF),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: _handleSend,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
