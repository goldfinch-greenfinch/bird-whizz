import 'package:flutter/material.dart';
import '../../models/question.dart';
import '../../models/level.dart';

final List<Level> triviaLevels = [
  Level(
    id: 'level1',
    name: 'Bird Basics',
    iconData: Icons.school,
    questions: [
      Question(
        id: 'l1q1',
        text: 'Which bird is the fastest diver in the sky?',
        options: ['Peregrine Falcon', 'Eagle', 'Sparrow', 'Chicken'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l1q2',
        text: 'True or False: A white Dove is often used as a symbol of peace.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l1q3',
        text: 'What do you call a large group of Crows?',
        options: ['A Murder', 'A Party', 'A School', 'A Team'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l1q4',
        text: 'Find the odd one out: Which of these birds CANNOT fly?',
        options: ['Penguin', 'Eagle', 'Robin', 'Hawk'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l1q5',
        text:
            'Fill in the blank: Parrots are famous because they can ______ human speech.',
        options: ['Mimic', 'Write', 'Hear', 'Ignore'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l1q6',
        text: 'True or False: Flamingos often stand on one leg.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l1q7',
        text: 'Instead of teeth, what do birds use to eat?',
        options: ['A Beak', 'Lips', 'A Nose', 'Paws'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l1q8',
        text: 'Who am I? I have big eyes, I hunt at night, and I say "Hoo".',
        options: ['Owl', 'Crow', 'Duck', 'Pigeon'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l1q9',
        text: 'True or False: All birds have feathers.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l1q10',
        text: 'According to stories, who delivers cute babies?',
        options: ['The Stork', 'The Eagle', 'The Pelican', 'The Swan'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'level2',
    name: 'Feather Fun',
    iconData: Icons.edit_outlined,
    questions: [
      Question(
        id: 'l2q1',
        text: 'True or False: Hummingbirds can fly backwards.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l2q2',
        text: 'Which bird lays the largest egg?',
        options: ['Ostrich', 'Chicken', 'Robin', 'Eagle'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l2q3',
        text: 'Who am I? I am the smallest bird in the world.',
        options: ['Bee Hummingbird', 'Sparrow', 'Wren', 'Robin'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l2q4',
        text:
            'Fill in the blank: The Wandering Albatross has the ______ wingspan of any bird.',
        options: ['Longest', 'Shortest', 'Greenest', 'Softest'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l2q5',
        text: 'When baby flamingos are born, what color are they?',
        options: ['Grey/White', 'Bright Pink', 'Green', 'Blue'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l2q6',
        text:
            'True or False: Birds sweat just like humans do when they get hot.',
        options: ['False', 'True'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l2q7',
        text: 'What distinctive color are American Robin eggs?',
        options: ['Blue', 'Red', 'Yellow', 'Purple'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l2q8',
        text:
            'Find the odd one out: Which of these birds is the fastest runner?',
        options: ['Ostrich', 'Penguin', 'Duck', 'Sparrow'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l2q9',
        text: 'How far can an Owl turn its head?',
        options: [
          'Almost all the way around',
          '360 degrees constantly',
          'Not at all',
          'Only up and down',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l2q10',
        text: 'Why do Woodpeckers have a long sticky tongue?',
        options: [
          'To catch bugs inside trees',
          'To taste fruit',
          'To drink water',
          'To clean their feathers',
        ],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'level3',
    name: 'Bird Brains',
    iconData: Icons.lightbulb,
    questions: [
      Question(
        id: 'l3q1',
        text: 'True or False: An Ostrich\'s eye is bigger than its brain.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l3q2',
        text:
            'Fill in the blank: In stories, Owls are often a symbol of ______.',
        options: ['Wisdom', 'Speed', 'Hunger', 'Sleep'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l3q3',
        text: 'Hummingbirds are amazing because they can fly...',
        options: [
          'Up, Down, and Backwards',
          'To the moon',
          'Without wings',
          'Underwater only',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l3q4',
        text: 'Are birds warm-blooded or cold-blooded?',
        options: ['Warm-blooded', 'Cold-blooded', 'Neither', 'Both'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l3q5',
        text: 'Find the odd one out: What gives Flamingos their pink color?',
        options: ['Shrimp and Algae', 'Sunlight', 'Berries', 'Pink Paints'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l3q6',
        text: 'Who am I? I have a giant colorful beak and live in the jungle.',
        options: ['Toucan', 'Eagle', 'Pigeon', 'Ostrich'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l3q7',
        text: 'Why do Geese fly in a V-shaped formation?',
        options: [
          'To save energy',
          'To look cool',
          'To make friends',
          'To race each other',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l3q8',
        text: 'True or False: The Eagle is often called the "King of Birds".',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l3q9',
        text:
            'Which of these animals does NOT live in Antarctica with Penguins?',
        options: ['Polar Bears', 'Seals', 'Whales', 'Krill'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l3q10',
        text:
            'Fill in the blank: A male Peacock displays a beautiful ______ of feathers.',
        options: ['Fan', 'Cube', 'Line', 'Tower'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'level4',
    name: 'Hunters',
    iconData: Icons.visibility,
    questions: [
      Question(
        id: 'l4q1',
        text: 'The Peregrine Falcon dives specifically to catch...',
        options: ['Other birds', 'Fish', 'Bears', 'Insects'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l4q2',
        text:
            'True or False: Owls can move their eyeballs around in their sockets.',
        options: ['False', 'True'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l4q3',
        text:
            'Who am I? I am a hunter that plunges feet-first into water to catch fish.',
        options: ['Osprey', 'Robin', 'Sparrow', 'Crow'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l4q4',
        text: 'What do we call a baby Eagle?',
        options: ['An Eaglet', 'A Chick', 'A Cub', 'A Fry'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l4q5',
        text:
            'Find the odd one out: Which bird prefers eating dead animals instead of hunting live ones?',
        options: ['Vulture', 'Eagle', 'Hawk', 'Falcon'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l4q6',
        text:
            'Fill in the blank: Hunting birds have sharp curved claws called ______.',
        options: ['Talons', 'Nails', 'Hooks', 'Fingers'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l4q7',
        text: 'Why do Owls fly silently?',
        options: [
          'To sneak up on prey',
          'To avoid waking others',
          'Because they are shy',
          'They have no feathers',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l4q8',
        text: 'Which sense is a Hawk most famous for?',
        options: ['Eyesight', 'Smell', 'Taste', 'Touch'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l4q9',
        text: 'True or False: Harris\'s Hawks hunt together in a pack.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l4q10',
        text: 'Who am I? I am a large white owl made famous by Harry Potter.',
        options: ['Snowy Owl', 'Barn Owl', 'Great Horned Owl', 'Elf Owl'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'level5',
    name: 'Splash Zone',
    iconData: Icons.water_drop,
    questions: [
      Question(
        id: 'l5q1',
        text: 'What is a Penguin\'s most amazing skill?',
        options: ['Swimming', 'Flying', 'Singing', 'Running'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l5q2',
        text:
            'True or False: A group of ducks floating on water is called a "Raft".',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l5q3',
        text: 'Fill in the blank: A Pelican uses its pouch to scoop up ______.',
        options: ['Fish', 'Sand', 'Rocks', 'Shells'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l5q4',
        text: 'Where do wild Penguins live?',
        options: ['Southern Hemisphere', 'North Pole', 'Everywhere', 'Deserts'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l5q5',
        text: 'What do you call a male Duck?',
        options: ['Drake', 'Buck', 'Bull', 'Rooster'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l5q6',
        text: 'Who am I? I fly in a V-shape and make a loud "Honk" sound.',
        options: ['Goose', 'Duck', 'Swan', 'Heron'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l5q7',
        text:
            'True or False: Ducks produce oil that makes their feathers waterproof.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l5q8',
        text: 'Where do Loons carry their babies to keep them safe?',
        options: [
          'On their backs',
          'In their mouths',
          'Under their wings',
          'In a pouch',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l5q9',
        text:
            'Find the odd one out: Which bird is famous for stealing food at the beach?',
        options: ['Seagull', 'Owl', 'Robin', 'Cardinal'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l5q10',
        text: 'How does a Kingfisher catch its dinner?',
        options: [
          'Diving into water',
          'Digging in dirt',
          'Chasing bugs',
          'Eating seeds',
        ],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'level6',
    name: 'Jungle Party',
    iconData: Icons.landscape,
    questions: [
      Question(
        id: 'l6q1',
        text: 'In which continent\'s rainforests do Toucans live?',
        options: ['South America', 'Europe', 'Antarctica', 'Australia'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l6q2',
        text:
            'True or False: The Lyrebird can mimic almost any sound, even machines.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l6q3',
        text: 'Fill in the blank: Macaws are a type of large, colorful ______.',
        options: ['Parrot', 'Eagle', 'Owl', 'Penguin'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l6q4',
        text: 'What bright color is the Scarlet Ibis?',
        options: ['Red', 'Blue', 'Green', 'Black'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l6q5',
        text:
            'Who am I? I have long majestic tail feathers and was sacred to ancient people of Mexico.',
        options: ['Resplendent Quetzal', 'Pigeon', 'Crow', 'Sparrow'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l6q6',
        text:
            'What special feature can a Cockatoo raise and lower on its head?',
        options: ['A Crest', 'A Hat', 'A Horn', 'Antennae'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l6q7',
        text:
            'In the movie "Rio", what kind of rare bird is the main character Blu?',
        options: ['Spix\'s Macaw', 'Blue Jay', 'Parakeet', 'Canary'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l6q8',
        text:
            'True or False: A Peacock\'s tail feathers have designs that look like eyes.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l6q9',
        text: 'Which continent is most famous for its many Cockatoos?',
        options: ['Australia', 'North America', 'Europe', 'Antarctica'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l6q10',
        text: 'The Birds of Paradise are most famous for their amazing...',
        options: ['Dances', 'Math skills', 'Swimming', 'Cooking'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'level7',
    name: 'Walk Don\'t Fly',
    iconData: Icons.directions_walk,
    questions: [
      Question(
        id: 'l7q1',
        text: 'Which country is the Kiwi bird famous for living in?',
        options: ['New Zealand', 'Australia', 'Japan', 'Canada'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l7q2',
        text:
            'Fill in the blank: The Emu is the ______ largest bird in the world.',
        options: ['Second', 'First', 'Last', 'Tenth'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l7q3',
        text:
            'True or False: An Ostrich can kick hard enough to defend itself from a lion.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l7q4',
        text:
            'Who am I? I was a flightless bird involved in stories, but I am now extinct.',
        options: ['Dodo', 'Chicken', 'Turkey', 'Robin'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l7q5',
        text:
            'Find the odd one out: Which of these things can a Penguin NOT do?',
        options: ['Fly', 'Swim', 'Walk', 'Slide'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l7q6',
        text: 'The Cassowary wears a hard helmet on its head called a...',
        options: ['Casque', 'Crown', 'Cap', 'Visor'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l7q7',
        text: 'Are Penguins classified as birds, mammals, or fish?',
        options: ['Birds', 'Mammals', 'Fish', 'Reptiles'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l7q8',
        text:
            'True or False: Kiwis are nocturnal, meaning they sleep during the day.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l7q9',
        text: 'Since Emus cannot fly, what is their superpower?',
        options: [
          'Running fast',
          'Flying high',
          'Digging holes',
          'Climbing trees',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l7q10',
        text:
            'Who am I? I am a heavy, green parrot from New Zealand that cannot fly.',
        options: ['Kakapo', 'Macaw', 'Lorikeet', 'Budgie'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'level8',
    name: 'Mini Marvels',
    iconData: Icons.bug_report,
    questions: [
      Question(
        id: 'l8q1',
        text: 'How quickly do Hummingbirds flap their wings?',
        options: ['Incredibly fast', 'Very slow', 'Once a minute', 'Never'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l8q2',
        text: 'Fill in the blank: Goldfinches love to eat ______ from plants.',
        options: ['Seeds', 'Leaves', 'Roots', 'Bark'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l8q3',
        text: 'Which word best describes the personality of a tiny Wren?',
        options: ['Loud and energetic', 'Quiet and shy', 'Lazy', 'Mean'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l8q4',
        text:
            'True or False: Nuthatches can walk head-first down a tree trunk.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l8q5',
        text: 'What distinctive color is on the face of a Eurasian Goldfinch?',
        options: ['Red', 'Blue', 'Green', 'Purple'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l8q6',
        text: 'Why do Hummingbirds migrate to warmer places?',
        options: [
          'To find nectar/bugs',
          'To go on vacation',
          'To see friends',
          'To get a tan',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l8q7',
        text:
            'True or False: Hummingbirds have strong legs and can walk very well.',
        options: ['False', 'True'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l8q8',
        text:
            'Who am I? My name sounds just like the call I make: "Chick-a-dee-dee-dee".',
        options: ['Chickadee', 'Sparrow', 'Crow', 'Hawk'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l8q9',
        text:
            'What do parent birds catch to give their babies lots of protein?',
        options: ['Bugs and worms', 'Grass', 'Berries', 'Candy'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l8q10',
        text: 'Find the odd one out: Which of these is the smallest Owl?',
        options: ['Elf Owl', 'Great Horned Owl', 'Barn Owl', 'Snowy Owl'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'level9',
    name: 'Color Explosion',
    iconData: Icons.palette,
    questions: [
      Question(
        id: 'l9q1',
        text: 'Why do male Birds of Paradise do funny dances?',
        options: [
          'To impress a female',
          'To exercise',
          'To fight',
          'To scare predators',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l9q2',
        text: 'True or False: Only the MALE Northern Cardinal is bright red.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l9q3',
        text:
            'Fill in the blank: Blue Jays are famous for their bright ______ feathers.',
        options: ['Blue', 'Red', 'Yellow', 'Green'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l9q4',
        text:
            'Who am I? I am a small bird that looks like a rainbow with red, blue, and green.',
        options: ['Painted Bunting', 'Crow', 'Sparrow', 'Dove'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l9q5',
        text: 'What are the typical colors of a Kingfisher?',
        options: [
          'Blue and Orange',
          'Pink and Purple',
          'Black and White',
          'Grey',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l9q6',
        text:
            'True or False: The Blue-footed Booby actually has bright blue feet.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l9q7',
        text: 'What color is the breast of a European Robin?',
        options: ['Red/Orange', 'Blue', 'Purple', 'Green'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l9q8',
        text:
            'Fill in the blank: Flamingos are pink because they eat food rich in ______.',
        options: ['Natural pigments', 'Sugar', 'Salt', 'Pepper'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l9q9',
        text: 'Why do Hummingbird feathers often look like shiny jewels?',
        options: [
          'They are iridescent',
          'They are painted',
          'They are wet',
          'They are made of glass',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l9q10',
        text: 'Who am I? I am the brown, less colorful partner of the peacock.',
        options: ['Peahen', 'Chicken', 'Turkey', 'Goose'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'level10',
    name: 'Bird Genius',
    iconData: Icons.workspace_premium,
    questions: [
      Question(
        id: 'l10q1',
        text: 'What is "Ornithology" the study of?',
        options: ['Birds', 'Fish', 'Rocks', 'Stars'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l10q2',
        text:
            'True or False: The Arctic Tern flies the longest migration of any bird.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l10q3',
        text: 'How many chambers does a bird\'s heart have?',
        options: ['4 (Like us)', '2', '1', '8'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l10q4',
        text:
            'Fill in the blank: Crows are so smart they can use ______ to get food.',
        options: ['Tools', 'Money', 'Computers', 'Magnets'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l10q5',
        text: 'What is a "Syrinx" in a bird?',
        options: ['A voice box', 'A stomach', 'A wing', 'A foot'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l10q6',
        text:
            'Who am I? I am a famous fossil that is a link between dinosaurs and birds.',
        options: ['Archaeopteryx', 'T-Rex', 'Dodo', 'Eagle'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l10q7',
        text: 'True or False: Birds pee and poop separately like mammals.',
        options: ['False', 'True'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l10q8',
        text: 'What is a "Crop" used for in a bird\'s body?',
        options: ['Storing food', 'Flying', 'Seeing', 'Hearing'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l10q9',
        text: 'What amazing thing can Frigatebirds do while flying?',
        options: ['Sleep', 'Lay eggs', 'Build nests', 'Swim'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'l10q10',
        text:
            'Find the odd one out: Which bird has passed the "mirror test" for self-recognition?',
        options: ['Magpie', 'Chicken', 'Sparrow', 'Duck'],
        correctOptionIndex: 0,
      ),
    ],
  ),
];
