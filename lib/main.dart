import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MemoryGame(),
    );
  }
}

// Enum definiujący możliwe stany karty
enum CardState { hidden, revealed, matched }

// Model karty przechowujący identyfikator pary, ikonę i aktualny stan
class Card {
  final int id;
  final IconData icon;
  CardState state;

  Card({required this.id, required this.icon, this.state = CardState.hidden});
}

class MemoryGame extends StatefulWidget {
  const MemoryGame({super.key});

  @override
  State<MemoryGame> createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {
  List<Card> cards = [];
  int? firstIndex;
  int? secondIndex;
  bool isProcessing = false;
  int matchesFound = 0;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  // Inicjalizacja gry: tworzenie par, mieszanie, reset stanów
  void _initializeGame() {
    final icons = [
      Icons.star, Icons.favorite, Icons.flare, Icons.bolt,
      Icons.cloud, Icons.beach_access, Icons.pets, Icons.music_note
    ];
    final shuffledIcons = icons..shuffle(Random());
    
    cards = [];
    for (int i = 0; i < 8; i++) {
      cards.add(Card(id: i, icon: shuffledIcons[i]));
      cards.add(Card(id: i, icon: shuffledIcons[i]));
    }
    cards.shuffle(Random());
    
    firstIndex = null;
    secondIndex = null;
    isProcessing = false;
    matchesFound = 0;
    setState(() {});
  }

  // Obsługa kliknięcia w kartę
  void _handleCardTap(int index) {
    // Blokada podczas animacji błędu lub jeśli karta jest już dopasowana
    if (isProcessing) return;
    if (cards[index].state == CardState.matched) return;
    if (firstIndex == index) return; // Kliknięto tę samą kartę dwukrotnie

    // Odkryj kartę
    cards[index].state = CardState.revealed;
    setState(() {});

    if (firstIndex == null) {
      // Pierwsza odkryta karta
      firstIndex = index;
    } else {
      // Druga odkryta karta - sprawdzamy dopasowanie
      secondIndex = index;
      isProcessing = true;
      
      if (cards[firstIndex!].id == cards[secondIndex!].id) {
        // Dopasowanie znalezione
        cards[firstIndex!].state = CardState.matched;
        cards[secondIndex!].state = CardState.matched;
        matchesFound += 2;
        firstIndex = null;
        secondIndex = null;
        isProcessing = false;
        setState(() {});
        
        // Sprawdzenie wygranej
        if (matchesFound == cards.length) {
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Gratulacje!'),
                  content: const Text('Znalazłeś wszystkie pary!'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _initializeGame();
                      },
                      child: const Text('Zagraj ponownie'),
                    )
                  ],
                ),
              );
            }
          });
        }
      } else {
        // Błędne dopasowanie - po 1 sekundzie ukrywamy karty
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            cards[firstIndex!].state = CardState.hidden;
            cards[secondIndex!].state = CardState.hidden;
            firstIndex = null;
            secondIndex = null;
            isProcessing = false;
            setState(() {});
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Memory 4x4')),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 0.75,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: cards.length,
              itemBuilder: (context, index) {
                return MemoryCard(
                  card: cards[index],
                  onTap: () => _handleCardTap(index),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: _initializeGame,
              icon: const Icon(Icons.refresh),
              label: const Text('Resetuj grę'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget karty z animacją obracania
class MemoryCard extends StatefulWidget {
  final Card card;
  final VoidCallback onTap;

  const MemoryCard({
    super.key,
    required this.card,
    required this.onTap,
  });

  @override
  State<MemoryCard> createState() => _MemoryCardState();
}

class _MemoryCardState extends State<MemoryCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    // Animacja od 0.0 do 1.0 odpowiadająca obrotowi 0-180 stopni
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void didUpdateWidget(MemoryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Uruchamiamy animację przy zmianie stanu karty
    if (widget.card.state != oldWidget.card.state) {
      if (widget.card.state != CardState.hidden) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRevealed = widget.card.state != CardState.hidden;
    
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // Tworzenie macierzy transformacji 3D z efektem perspektywy
        final transform = Matrix4.identity()
          ..setEntry(3, 2, 0.001) // Dodaje głębię dla realistycznego obrotu
          ..rotateY(_animation.value * 3.14159); // Obrót wokół osi Y (0 do 180 stopni)
        
        return Transform(
          transform: transform,
          alignment: Alignment.center,
          // W zależności od postępu animacji pokazujemy przód lub tył
          child: isRevealed ? _buildFront() : _buildBack(),
        );
      },
    );
  }

  Widget _buildFront() {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.deepPurple, width: 2),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 4, offset: const Offset(0, 2))
          ],
        ),
        child: Icon(widget.card.icon, size: 48, color: Colors.deepPurple),
      ),
    );
  }

  Widget _buildBack() {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 4, offset: const Offset(0, 2))
          ],
        ),
        child: const Icon(Icons.help_outline, size: 48, color: Colors.white),
      ),
    );
  }
}
