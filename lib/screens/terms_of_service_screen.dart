import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Terms of Service',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader('Algemene Voorwaarden'),
            _buildDate('Laatst bijgewerkt: 16 februari 2026'),
            const SizedBox(height: 24),
            _buildSection(
              '1. Acceptatie van Voorwaarden',
              'Door gebruik te maken van de ShopMobile-applicatie ga je akkoord met deze algemene voorwaarden. Indien je niet akkoord gaat, verzoeken wij je de app te verwijderen.',
            ),
            _buildSection(
              '2. Gebruik van de Applicatie',
              'ShopMobile is een demonstratie-applicatie. De getoonde producten en prijzen zijn afkomstig van een publieke simulator-API (FakeStoreAPI) en zijn niet echt. Je kunt via deze app geen echte producten kopen of betalingen verrichten.',
            ),
            _buildSection(
              '3. Intellectueel Eigendom',
              'Alle content binnen deze app, inclusief ontwerp, logo\'s en code, is eigendom van Commerce Inc. of wordt gebruikt onder licentie. Het is niet toegestaan om delen van de app te kopiëren zonder toestemming.',
            ),
            _buildSection(
              '4. Beperking van Aansprakelijkheid',
              'ShopMobile wordt geleverd "zoals het is" (as-is). Wij zijn niet aansprakelijk voor eventuele fouten in productinformatie, verlies van lokale data (zoals je winkelwagen) of technische storingen.',
            ),
            _buildSection(
              '5. Wijzigingen',
              'Wij behouden ons het recht voor om deze voorwaarden op elk moment te wijzigen. Het blijven gebruiken van de app na wijzigingen betekent dat je de nieuwe voorwaarden accepteert.',
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                'ShopMobile - Jouw favoriete nep-winkelervaring',
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
