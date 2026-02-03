import 'package:flutter/material.dart';

class Bird {
  final String id;
  final String name;
  final String emoji;
  final Color color;
  final String description;

  const Bird({
    required this.id,
    required this.name,
    required this.emoji,
    required this.color,
    required this.description,
  });
}

const List<Bird> availableBirds = [
  Bird(
    id: 'sky',
    name: 'Sky',
    emoji: '🐦',
    color: Colors.blueAccent,
    description: 'Loves high altitudes.',
  ),
  Bird(
    id: 'penguin',
    name: 'Puddles',
    emoji: '🐧',
    color: Colors.black,
    description: 'Sliding enthusiast.',
  ),
  Bird(
    id: 'chick',
    name: 'Sunny',
    emoji: '🐥',
    color: Colors.amber,
    description: 'Bright and cheerful.',
  ),
  Bird(
    id: 'owl',
    name: 'Winston',
    emoji: '🦉',
    color: Colors.brown,
    description: 'Wise and observant.',
  ),
  Bird(
    id: 'flamingo',
    name: 'Pinky',
    emoji: '🦩',
    color: Colors.pink,
    description: 'Did someone say shrimp?',
  ),
  Bird(
    id: 'parrot',
    name: 'Rio',
    emoji: '🦜',
    color: Colors.green,
    description: 'Repeats everything!',
  ),
  Bird(
    id: 'peacock',
    name: 'Fancy',
    emoji: '🦚',
    color: Colors.teal,
    description: 'Always dressed to impress.',
  ),
  Bird(
    id: 'duck',
    name: 'Quackers',
    emoji: '🦆',
    color: Colors.lightGreen,
    description: 'Loves a good swim.',
  ),
  Bird(
    id: 'eagle',
    name: 'Maverick',
    emoji: '🦅',
    color: Colors.brown,
    description: 'The sky is fearless.',
  ),
  Bird(
    id: 'swan',
    name: 'Grace',
    emoji: '🦢',
    color: Colors.cyan,
    description: 'Elegance in motion.',
  ),
  Bird(
    id: 'rooster',
    name: 'Rusty',
    emoji: '🐓',
    color: Colors.deepOrange,
    description: 'Never late for breakfast.',
  ),
  Bird(
    id: 'dove',
    name: 'Hope',
    emoji: '🕊️',
    color: Colors.indigo,
    description: 'Peaceful vibes only.',
  ),
  Bird(
    id: 'turkey',
    name: 'Gobbles',
    emoji: '🦃',
    color: Colors.brown,
    description: 'Always grateful.',
  ),
  Bird(
    id: 'goose',
    name: 'Honk',
    emoji: '🪿',
    color: Colors.grey,
    description: 'Safety first!',
  ),
  Bird(
    id: 'dodo',
    name: 'Dino',
    emoji: '🦤',
    color: Colors.purple,
    description: 'Not extinct here!',
  ),
  Bird(
    id: 'blackbird',
    name: 'Shadow',
    emoji: '🐦‍⬛',
    color: Colors.black87,
    description: 'Master of stealth.',
  ),
  Bird(
    id: 'phoenix',
    name: 'Blaze',
    emoji: '🐦‍🔥',
    color: Colors.deepOrangeAccent,
    description: 'Rising from the ashes.',
  ),
  Bird(
    id: 'hen',
    name: 'Henrietta',
    emoji: '🐔',
    color: Colors.orange,
    description: 'Ruling the roost.',
  ),
  Bird(
    id: 'hatchling',
    name: 'Pip',
    emoji: '🐣',
    color: Colors.yellowAccent,
    description: 'Brand new to the world.',
  ),
];
