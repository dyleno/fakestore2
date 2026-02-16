import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Privacy Policy',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader('Privacyverklaring - ShopMobile'),
            _buildDate('Laatst bijgewerkt: 16 februari 2026'),
            const SizedBox(height: 24),
            _buildSection(
              '1. Inleiding',
              'Welkom bij ShopMobile. Wij waarderen je vertrouwen en doen er alles aan om je persoonlijke gegevens te beschermen. Deze privacyverklaring legt uit welke informatie we verzamelen, waarom we dit doen en hoe we hiermee omgaan.',
            ),
            _buildSection(
              '2. Gegevensverzameling',
              'ShopMobile verzamelt momenteel minimale gegevens om de app-ervaring te verbeteren:\n\n'
                  '• Lokale Opslag: Je favorieten, winkelwagen en bestelgeschiedenis worden lokaal op je toestel opgeslagen via Hive.\n'
                  '• API-aanroepen: We gebruiken de FakeStoreAPI om productgegevens op te halen. Hierbij worden geen persoonlijke gegevens naar externe servers gestuurd.',
            ),
            _buildSection(
              '3. Gebruik van gegevens',
              'De verzamelde gegevens worden uitsluitend gebruikt voor:\n'
                  '• Het tonen van je persoonlijke bestelgeschiedenis.\n'
                  '• Het onthouden van items in je winkelwagen.\n'
                  '• Het verbeteren van de prestaties van de app.',
            ),
            _buildSection(
              '4. Jouw Rechten',
              'Je hebt volledige controle over je data. Omdat al je gegevens lokaal worden opgeslagen, kun je deze op elk moment verwijderen door:\n'
                  '• De cache te wissen in de instellingen van deze app.\n'
                  '• De app te verwijderen van je toestel.',
            ),
            _buildSection(
              '5. Contact',
              'Heb je vragen over ons privacybeleid? Neem dan contact op met ons support team via de chat-functie in de app.',
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                'Bedankt voor het gebruiken van ShopMobile!',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w900,
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildDate(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6C63FF),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
