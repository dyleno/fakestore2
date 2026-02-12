import 'dart:math';
import '../models/product.dart';

class AiService {
  final Random _random = Random();

  Future<String> getResponse(String userMessage, Product product) async {
    // Simuleer een kleine vertraging voor de 'nagedacht' ervaring
    await Future.delayed(const Duration(milliseconds: 1500));

    final input = userMessage.toLowerCase();

    // 1. Prijs & Deals
    if (_matches(
        input, ['prijs', 'kosten', 'duur', 'goedkoop', 'deal', 'korting'])) {
      return _pick([
        'De ${product.title} kost momenteel €${product.price.toStringAsFixed(2)}. Voor deze kwaliteit in de categorie ${product.category} is dat echt een topscherpe prijs!',
        'Je kijkt naar een prijs van €${product.price.toStringAsFixed(2)}. We hebben momenteel een hoge vraag naar ${product.category}, dus dit is een slim moment om toe te slaan!',
        'Voor maar €${product.price.toStringAsFixed(2)} is dit item van jou. Veel klanten vinden dit de beste prijs-kwaliteitverhouding voor een ${product.category}!'
      ]);
    }

    // 2. Kwaliteit & Rating
    if (_matches(input, [
      'kwaliteit',
      'goed',
      'ervaring',
      'rating',
      'sterren',
      'beoordeling'
    ])) {
      return _pick([
        'Met een rating van ${product.rating} sterren zit je sowieso goed. Onze klanten prijzen vooral de duurzame afwerking van deze ${product.category}!',
        'De kwaliteit is top-notch. Er zijn al ${product.ratingCount} reviews achtergelaten voor de ${product.title}, wat laat zien hoe populair dit item is.',
        'Zeker weten! De ${product.title} staat bekend om zijn hoogwaardige materiaal. We zien zelden retouren voor dit product.'
      ]);
    }

    // 3. Levertijd & Bezorging
    if (_matches(input, [
      'levering',
      'bezorgen',
      'wanneer',
      'verzending',
      'thuis',
      'postnl',
      'dhl'
    ])) {
      return _pick([
        'Als je vandaag bestelt, proberen we de ${product.title} morgen al te verzenden. Meestal heb je het binnen 1-2 werkdagen in huis!',
        'Goede vraag! Voor dit item geldt: voor 22:00 besteld is morgen in huis. We verzenden het veilig via onze vaste partners.',
        'We hebben de ${product.title} op voorraad. De verzending is razendsnel, dus je hoeft niet lang te wachten op je nieuwe ${product.category}!'
      ]);
    }

    // 4. Maattabel & Fit (specifiek voor kleding/accessoires)
    if (_matches(input,
        ['maat', 'passen', 'groot', 'klein', 'cm', 'centimeter', 'size'])) {
      return _pick([
        'De pasvorm is over het algemeen "true to size". Ik raad je aan de Size Guide op de pagina te checken voor de exacte centimeters!',
        'Geen zorgen over de maat. Voor de ${product.title} raden we aan je gebruikelijke maat te bestellen. Mocht het niet passen, kun je altijd makkelijk retourneren.',
        'In de Size Guide vind je de afmetingen voor borst en lengte. Voor een meer oversized look kun je natuurlijk een maatje groter pakken!'
      ]);
    }

    // 5. Look & Styling
    if (_matches(input,
        ['mooi', 'leuk', 'stijl', 'look', 'outfit', 'combineren', 'kleur'])) {
      return _pick([
        'De ${product.title} is echt een eyecatcher. De kleur komt in het echt heel mooi naar voren, vooral als je het combineert met andere items uit de ${product.category} collectie!',
        'Dit is een van onze meest stijlvolle items. Het tijdloze design van deze ${product.category} zorgt ervoor dat je het jarenlang kunt dragen.',
        'Absoluut! De look van dit product is heel modern. Heb je al naar de verschillende kleuropties gekeken via de filters?'
      ]);
    }

    // 6. Greetings
    if (_matches(
        input, ['hoi', 'hallo', 'hey', 'goedendag', 'morning', 'middag'])) {
      return 'Hoi! Ik help je graag met al je vragen over de ${product.title}. Wat wil je precies weten?';
    }

    // 7. Bedankjes
    if (_matches(input, ['bedankt', 'thanks', 'top', 'doei', 'fijn', 'dank'])) {
      return 'Graag gedaan! Geniet van je dag en laat het weten als je hulp nodig hebt bij het bestellen van je ${product.title}. 😊';
    }

    // 8. Slimme Fallbacks (als hij het niet snapt)
    return _pick([
      'Dat is een specifieke vraag! Hoewel ik dat niet 100% zeker weet, kan ik je wel vertellen dat de ${product.title} een van onze bestsellers is met ${product.ratingCount} reviews.',
      'Goede vraag over de ${product.title}. Wist je dat dit item momenteel erg populair is in de categorie ${product.category}? Wil je weten hoe het zit met de levertijd of de prijs?',
      'Ik begrijp je vraag niet helemaal, maar over dit product kan ik je wel vast vertellen dat het momenteel €${product.price.toStringAsFixed(2)} kost en een rating heeft van ${product.rating}!',
      'Interessant! Ik leer nog elke dag bij. Wat ik wel al weet is dat de ${product.title} bekend staat om zijn goede kwaliteit. Kan ik je helpen met het vinden van de juiste maat?'
    ]);
  }

  bool _matches(String input, List<String> keywords) {
    return keywords.any((k) => input.contains(k));
  }

  String _pick(List<String> options) {
    return options[_random.nextInt(options.length)];
  }
}
