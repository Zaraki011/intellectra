import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  final List<Map<String, String>> faqList = const [
    {
      'question': 'Comment créer un compte professeur ?',
      'answer': 'Rendez-vous sur la page d\'inscription et sélectionnez "Professeur".'
    },
    {
      'question': 'Comment ajouter un cours ?',
      'answer': 'Allez dans votre espace professeur et cliquez sur "Ajouter un cours".'
    },
    {
      'question': 'Quels types de fichiers puis-je téléverser ?',
      'answer': 'Vous pouvez téléverser des fichiers PDF ou des vidéos.'
    },
    {
      'question': 'Comment s\'inscrire à un cours ?',
      'answer': 'Cliquez sur "S\'inscrire" depuis la fiche du cours.'
    },
    {
      'question': 'J\'ai oublié mon mot de passe, que faire ?',
      'answer': 'Cliquez sur "Mot de passe oublié" depuis l\'écran de connexion.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FAQ')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: faqList.length,
        itemBuilder: (context, index) {
          final faq = faqList[index];
          return ExpansionTile(
            title: Text(faq['question']!, style: const TextStyle(fontWeight: FontWeight.bold)),
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(faq['answer']!),
              ),
            ],
          );
        },
      ),
    );
  }
}
