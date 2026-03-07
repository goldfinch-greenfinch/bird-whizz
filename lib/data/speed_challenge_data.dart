enum SpeedQuestionType { text, image }

class SpeedChallengeQuestion {
  final SpeedQuestionType type;
  final String? questionText; // for text type
  final String? imagePath; // for image type
  final List<String> options; // exactly 4
  final int correctIndex;

  const SpeedChallengeQuestion({
    required this.type,
    this.questionText,
    this.imagePath,
    required this.options,
    required this.correctIndex,
  });
}

class SpeedChallengeLevel {
  final String title;
  final String subtitle;
  final String emoji;
  final int secondsPerQuestion;
  final List<SpeedChallengeQuestion> questions;

  const SpeedChallengeLevel({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.secondsPerQuestion,
    required this.questions,
  });
}

const List<SpeedChallengeLevel> speedChallengeLevels = [
  // ─── Level 1: Fledgling — 20 seconds ────────────────────────────────────────
  SpeedChallengeLevel(
    title: 'Fledgling',
    subtitle: 'Easy questions at a comfortable pace — get warmed up!',
    emoji: '🐣',
    secondsPerQuestion: 20,
    questions: [
      SpeedChallengeQuestion(
        type: SpeedQuestionType.text,
        questionText:
            'Which small garden bird has a bright red breast and is Britain\'s unofficial national bird?',
        options: ['Robin', 'Chaffinch', 'Wren', 'Dunnock'],
        correctIndex: 0,
      ),
      SpeedChallengeQuestion(
        type: SpeedQuestionType.image,
        imagePath: 'assets/bird_photos/european_robin.webp',
        options: ['Coal Tit', 'European Robin', 'Wren', 'Marsh Tit'],
        correctIndex: 1,
      ),
      SpeedChallengeQuestion(
        type: SpeedQuestionType.text,
        questionText: 'What is a baby swan called?',
        options: ['Chick', 'Duckling', 'Cygnet', 'Owlet'],
        correctIndex: 2,
      ),
      SpeedChallengeQuestion(
        type: SpeedQuestionType.image,
        imagePath: 'assets/bird_photos/mallard_duck.webp',
        options: ['Northern Pintail', 'Common Teal', 'Mallard Duck', 'Shoveler'],
        correctIndex: 2,
      ),
      SpeedChallengeQuestion(
        type: SpeedQuestionType.text,
        questionText:
            'Which British falcon is famous for hovering motionless in the wind while hunting?',
        options: ['Sparrowhawk', 'Merlin', 'Hobby', 'Kestrel'],
        correctIndex: 3,
      ),
      SpeedChallengeQuestion(
        type: SpeedQuestionType.image,
        imagePath: 'assets/bird_photos/barn_owl.webp',
        options: ['Barn Owl', 'Short Eared Owl', 'Little Owl', 'Tawny Owl'],
        correctIndex: 0,
      ),
      SpeedChallengeQuestion(
        type: SpeedQuestionType.text,
        questionText: 'What do you call birds that eat only meat, such as hawks and eagles?',
        options: ['Herbivorous', 'Omnivorous', 'Granivorous', 'Carnivorous'],
        correctIndex: 3,
      ),
      SpeedChallengeQuestion(
        type: SpeedQuestionType.image,
        imagePath: 'assets/bird_photos/atlantic_puffin.webp',
        options: ['Razorbill', 'Atlantic Puffin', 'Guillemot', 'Little Auk'],
        correctIndex: 1,
      ),
      SpeedChallengeQuestion(
        type: SpeedQuestionType.text,
        questionText: 'Which bird is known for mimicking human speech and other sounds?',
        options: ['Crow', 'Starling', 'Parrot', 'Magpie'],
        correctIndex: 2,
      ),
      SpeedChallengeQuestion(
        type: SpeedQuestionType.image,
        imagePath: 'assets/bird_photos/eurasian_blue_tit.webp',
        options: ['Great Tit', 'Coal Tit', 'Eurasian Blue Tit', 'Marsh Tit'],
        correctIndex: 2,
      ),
    ],
  ),

  // ─── Level 2: Soaring — 15 seconds ──────────────────────────────────────────
  SpeedChallengeLevel(
    title: 'Soaring',
    subtitle: 'The pace quickens — mixed text and photo questions.',
    emoji: '🦅',
    secondsPerQuestion: 15,
    questions: [
      SpeedChallengeQuestion(
        type: SpeedQuestionType.text,
        questionText:
            'Which bird has the longest wingspan of any living species, stretching over 3.5 metres?',
        options: [
          'Wandering Albatross',
          'Andean Condor',
          'Dalmatian Pelican',
          'Mute Swan',
        ],
        correctIndex: 0,
      ),
      SpeedChallengeQuestion(
        type: SpeedQuestionType.image,
        imagePath: 'assets/bird_photos/great_spotted_woodpecker.webp',
        options: [
          'Green Woodpecker',
          'Great Spotted Woodpecker',
          'Lesser Spotted Woodpecker',
          'Wryneck',
        ],
        correctIndex: 1,
      ),
      SpeedChallengeQuestion(
        type: SpeedQuestionType.text,
        questionText: 'What is the scientific study of birds called?',
        options: ['Entomology', 'Ichthyology', 'Ornithology', 'Herpetology'],
        correctIndex: 2,
      ),
      SpeedChallengeQuestion(
        type: SpeedQuestionType.image,
        imagePath: 'assets/bird_photos/canada_geese.webp',
        options: [
          'Barnacle Goose',
          'White-fronted Goose',
          'Greylag Goose',
          'Canada Geese',
        ],
        correctIndex: 3,
      ),
      SpeedChallengeQuestion(
        type: SpeedQuestionType.text,
        questionText:
            'The European Cuckoo lays eggs in other birds\' nests. What is this behaviour called?',
        options: [
          'Brood parasitism',
          'Kleptoparasitism',
          'Nest usurpation',
          'Clutch hijacking',
        ],
        correctIndex: 0,
      ),
      SpeedChallengeQuestion(
        type: SpeedQuestionType.image,
        imagePath: 'assets/bird_photos/common_kestrel.webp',
        options: [
          'Eurasian Hobby',
          'Common Kestrel',
          'Merlin',
          'Common Sparrowhawk',
        ],
        correctIndex: 1,
      ),
      SpeedChallengeQuestion(
        type: SpeedQuestionType.text,
        questionText: 'What is the collective noun for a group of flamingos?',
        options: ['A gaggle', 'A colony', 'A flamboyance', 'A flock'],
        correctIndex: 2,
      ),
      SpeedChallengeQuestion(
        type: SpeedQuestionType.image,
        imagePath: 'assets/bird_photos/indian_peacock.webp',
        options: ['Blue Macaw', 'Indian Peacock', 'Keel Billed Toucan', 'Northern Cardinal'],
        correctIndex: 1,
      ),
      SpeedChallengeQuestion(
        type: SpeedQuestionType.text,
        questionText:
            'Seabirds such as albatrosses can drink seawater. How do they get rid of the salt?',
        options: [
          'Through their kidneys',
          'Through special nasal glands',
          'They cannot; they avoid salt water',
          'Through the pores in their feathers',
        ],
        correctIndex: 1,
      ),
      SpeedChallengeQuestion(
        type: SpeedQuestionType.image,
        imagePath: 'assets/bird_photos/american_flamingo.webp',
        options: [
          'American Flamingo',
          'Roseate Spoonbill',
          'Little Egret',
          'Great White Egret',
        ],
        correctIndex: 0,
      ),
    ],
  ),

  // ─── Level 3: Swift — 10 seconds ────────────────────────────────────────────
  SpeedChallengeLevel(
    title: 'Swift',
    subtitle: 'Only 10 seconds per question — think fast!',
    emoji: '⚡',
    secondsPerQuestion: 10,
    questions: [
      SpeedChallengeQuestion(
        type: SpeedQuestionType.text,
        questionText:
            'Which bird makes the longest annual migration, travelling from the Arctic to the Antarctic and back?',
        options: [
          'Arctic Tern',
          'Sooty Shearwater',
          'Bar-tailed Godwit',
          'Wandering Albatross',
        ],
        correctIndex: 0,
      ),
      SpeedChallengeQuestion(
        type: SpeedQuestionType.image,
        imagePath: 'assets/bird_photos/eurasian_nuthatch.webp',
        options: [
          'Common Treecreeper',
          'Short-toed Treecreeper',
          'Eurasian Nuthatch',
          'Wallcreeper',
        ],
        correctIndex: 2,
      ),
      SpeedChallengeQuestion(
        type: SpeedQuestionType.text,
        questionText:
            'Which goose is famous for migrating over the Himalayas, sometimes flying above 8,000 metres?',
        options: ['Snow Goose', 'Whooper Swan', 'Bar-headed Goose', 'Common Crane'],
        correctIndex: 2,
      ),
      SpeedChallengeQuestion(
        type: SpeedQuestionType.image,
        imagePath: 'assets/bird_photos/northern_pintail.webp',
        options: [
          'Northern Pintail',
          'Gadwall',
          'Northern Shoveler',
          'Common Pochard',
        ],
        correctIndex: 0,
      ),
      SpeedChallengeQuestion(
        type: SpeedQuestionType.text,
        questionText:
            'Approximately what top speed can a Peregrine Falcon reach when diving?',
        options: ['390 km/h', '250 km/h', '180 km/h', '320 km/h'],
        correctIndex: 0,
      ),
      SpeedChallengeQuestion(
        type: SpeedQuestionType.image,
        imagePath: 'assets/bird_photos/bald_eagle.webp',
        options: [
          'White-tailed Eagle',
          'Steller\'s Sea Eagle',
          'Harris Hawk',
          'Bald Eagle',
        ],
        correctIndex: 3,
      ),
      SpeedChallengeQuestion(
        type: SpeedQuestionType.text,
        questionText:
            'What is the term for a bird\'s ability to sense and navigate using the Earth\'s magnetic field?',
        options: [
          'Echolocation',
          'Magnetoreception',
          'Electroreception',
          'Photoreception',
        ],
        correctIndex: 1,
      ),
      SpeedChallengeQuestion(
        type: SpeedQuestionType.image,
        imagePath: 'assets/bird_photos/northern_cardinal.webp',
        options: [
          'Northern Cardinal',
          'Scarlet Tanager',
          'House Finch',
          'Common Rosefinch',
        ],
        correctIndex: 0,
      ),
      SpeedChallengeQuestion(
        type: SpeedQuestionType.text,
        questionText:
            'What is the term for the annual process in which a bird replaces its old feathers with new ones?',
        options: ['Plumage shift', 'Moult', 'Feather flush', 'Plumage renewal'],
        correctIndex: 1,
      ),
      SpeedChallengeQuestion(
        type: SpeedQuestionType.image,
        imagePath: 'assets/bird_photos/little_egret.webp',
        options: [
          'Great White Egret',
          'Snowy Egret',
          'Cattle Egret',
          'Little Egret',
        ],
        correctIndex: 3,
      ),
    ],
  ),

  // ─── Level 4: Falcon — 7 seconds ────────────────────────────────────────────
  SpeedChallengeLevel(
    title: 'Falcon',
    subtitle: 'Just 7 seconds — only experts survive this pace!',
    emoji: '🔥',
    secondsPerQuestion: 7,
    questions: [
      SpeedChallengeQuestion(
        type: SpeedQuestionType.text,
        questionText: 'What is the collective noun for a group of owls?',
        options: ['A colony', 'A murder', 'A parliament', 'A raft'],
        correctIndex: 2,
      ),
      SpeedChallengeQuestion(
        type: SpeedQuestionType.image,
        imagePath: 'assets/bird_photos/smew.webp',
        options: [
          'Common Goldeneyes',
          'Smew',
          'Goosander',
          'Red-breasted Merganser',
        ],
        correctIndex: 1,
      ),
      SpeedChallengeQuestion(
        type: SpeedQuestionType.text,
        questionText:
            'What is the term for bird chicks that hatch with eyes open, downy feathers, and can walk almost immediately?',
        options: ['Altricial', 'Nidicolous', 'Nidifugous', 'Precocial'],
        correctIndex: 3,
      ),
      SpeedChallengeQuestion(
        type: SpeedQuestionType.image,
        imagePath: 'assets/bird_photos/harris_hawk.webp',
        options: [
          'Harris Hawk',
          'Red-tailed Hawk',
          'Common Buzzard',
          'Ferruginous Hawk',
        ],
        correctIndex: 0,
      ),
      SpeedChallengeQuestion(
        type: SpeedQuestionType.text,
        questionText:
            'The muscular stomach of a bird that grinds food — often containing swallowed grit — is called what?',
        options: ['Crop', 'Bursa', 'Proventriculus', 'Gizzard'],
        correctIndex: 3,
      ),
      SpeedChallengeQuestion(
        type: SpeedQuestionType.image,
        imagePath: 'assets/bird_photos/keel_billed_toucan.webp',
        options: [
          'Yellow Throated Toucan',
          'Keel Billed Toucan',
          'Toco Toucan',
          'Collared Aracari',
        ],
        correctIndex: 1,
      ),
      SpeedChallengeQuestion(
        type: SpeedQuestionType.text,
        questionText:
            'The male Kakapo, the world\'s heaviest parrot, can weigh up to approximately how much?',
        options: ['4 kg', '1.5 kg', '6 kg', '2 kg'],
        correctIndex: 0,
      ),
      SpeedChallengeQuestion(
        type: SpeedQuestionType.image,
        imagePath: 'assets/bird_photos/frigatebird.webp',
        options: ['Cormorant', 'Shag', 'Frigatebird', 'Anhinga'],
        correctIndex: 2,
      ),
      SpeedChallengeQuestion(
        type: SpeedQuestionType.text,
        questionText:
            'Which raptor is unique in hunting cooperatively in family groups — the only species of its kind to do so?',
        options: ['Peregrine Falcon', 'Harris Hawk', 'Common Buzzard', 'Red Kite'],
        correctIndex: 1,
      ),
      SpeedChallengeQuestion(
        type: SpeedQuestionType.image,
        imagePath: 'assets/bird_photos/red_crowned_crane.webp',
        options: [
          'Whooping Crane',
          'Siberian Crane',
          'Red Crowned Crane',
          'Common Crane',
        ],
        correctIndex: 2,
      ),
    ],
  ),

  // ─── Level 5: Legend — 5 seconds ────────────────────────────────────────────
  SpeedChallengeLevel(
    title: 'Legend',
    subtitle: '5 seconds per question — only true bird legends survive!',
    emoji: '👑',
    secondsPerQuestion: 5,
    questions: [
      SpeedChallengeQuestion(
        type: SpeedQuestionType.text,
        questionText:
            'What term describes birds that are most active at dawn and dusk, such as the Nightjar?',
        options: ['Diurnal', 'Crepuscular', 'Nocturnal', 'Vespertine'],
        correctIndex: 1,
      ),
      SpeedChallengeQuestion(
        type: SpeedQuestionType.image,
        imagePath: 'assets/bird_photos/bar_headed_goose.webp',
        options: [
          'Bar Headed Goose',
          'Pink-footed Goose',
          'Snow Goose',
          'Greylag Goose',
        ],
        correctIndex: 0,
      ),
      SpeedChallengeQuestion(
        type: SpeedQuestionType.text,
        questionText:
            'Clark\'s Nutcracker can store up to approximately how many pine seeds in thousands of winter caches?',
        options: ['5,000', '10,000', '30,000', '100,000'],
        correctIndex: 2,
      ),
      SpeedChallengeQuestion(
        type: SpeedQuestionType.image,
        imagePath: 'assets/bird_photos/great_grey_owl.webp',
        options: [
          'Great Horned Owl',
          'Great Grey Owl',
          'Ural Owl',
          'Barred Owl',
        ],
        correctIndex: 1,
      ),
      SpeedChallengeQuestion(
        type: SpeedQuestionType.text,
        questionText:
            'Approximately how many bird species are there in the world?',
        options: ['5,000', '7,500', '15,000', '10,000'],
        correctIndex: 3,
      ),
      SpeedChallengeQuestion(
        type: SpeedQuestionType.image,
        imagePath: 'assets/bird_photos/lilac_breasted_roller.webp',
        options: [
          'European Roller',
          'Lilac Breasted Roller',
          'Broad-billed Roller',
          'Blue-bellied Roller',
        ],
        correctIndex: 1,
      ),
      SpeedChallengeQuestion(
        type: SpeedQuestionType.text,
        questionText:
            'What pigment gives flamingos their characteristic pink colour, derived from their diet?',
        options: ['Melanin', 'Carotenoids', 'Porphyrins', 'Psittacofulvins'],
        correctIndex: 1,
      ),
      SpeedChallengeQuestion(
        type: SpeedQuestionType.image,
        imagePath: 'assets/bird_photos/male_common_eide.webp',
        options: [
          'Common Scoter',
          'Common Goldeneyes',
          'Male Common Eider',
          'Smew',
        ],
        correctIndex: 2,
      ),
      SpeedChallengeQuestion(
        type: SpeedQuestionType.text,
        questionText:
            'The Superb Lyrebird of Australia is famous for its mimicry. Roughly how many different bird species\' calls can it reproduce?',
        options: ['Just 2–3', 'Around 7', 'Over 20', 'Exactly 5'],
        correctIndex: 2,
      ),
      SpeedChallengeQuestion(
        type: SpeedQuestionType.image,
        imagePath: 'assets/bird_photos/snowy_owl.webp',
        options: [
          'Great Grey Owl',
          'Short Eared Owl',
          'Barn Owl',
          'Snowy Owl',
        ],
        correctIndex: 3,
      ),
    ],
  ),
];
