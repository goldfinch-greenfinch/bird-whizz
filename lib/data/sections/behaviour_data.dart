import 'package:flutter/material.dart';
import '../../models/question.dart';
import '../../models/level.dart';

final List<Level> behaviourLevels = [
  Level(
    id: 'behav_l1',
    name: 'Bird Habits',
    iconData: Icons.psychology_outlined,
    questions: [
      Question(
        id: 'life_l1q1',
        text:
            'Fill in the blank: When birds clean and arrange their feathers, it is called ______.',
        options: ['Preening', 'Scrubbing', 'Polishing', 'Shedding'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'life_l1q2',
        text:
            'True or False: "Mobbing" is when small birds chase away a big dangerous bird.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'life_l1q3',
        text: 'Why do birds sit on their eggs?',
        options: [
          'To keep them warm',
          'To hide them',
          'To break them',
          'To paint them',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'life_l1q4',
        text: 'What happens during "Anting"?',
        options: [
          'Birds rub ants on feathers',
          'Birds eat huge ants',
          'Birds step on ants',
          'Birds act like ants',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'life_l1q5',
        text: 'Who am I? I am a male bird singing loudly on a branch.',
        options: [
          'I want a girlfriend',
          'I am hungry',
          'I am lost',
          'I am sleepy',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'life_l1q6',
        text: 'The "Pecking Order" determines...',
        options: [
          'Who is the boss',
          'What to eat',
          'Where to sleep',
          'How to fly',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'life_l1q7',
        text: 'True or False: Some birds can sleep with one eye open.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'life_l1q8',
        text: 'Find the odd one out: Why do birds take dust baths?',
        options: [
          'To get dirty',
          'To clean feathers',
          'To remove bugs',
          'To remove oil',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'life_l1q9',
        text:
            'Fill in the blank: Hiding food to eat it later is called ______.',
        options: ['Caching', 'Cooking', 'Catching', 'Camping'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'life_l1q10',
        text: 'When a bird is cold, it will...',
        options: ['Fluff up its feathers', 'Jump around', 'Fly fast', 'Swim'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'behav_l2',
    name: 'Showing Off',
    iconData: Icons.favorite,
    questions: [
      Question(
        id: 'behav_l2q1',
        text:
            'What do you call a special place where birds gather to dance and find mates?',
        options: ['A Lek', 'A Club', 'A Gym', 'A Nest'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l2q2',
        text:
            'Who am I? I am a Manakin bird famous for a dance move that looks like...',
        options: ['The Moonwalk', 'The Floss', 'A Waltz', 'Tap Dancing'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l2q3',
        text:
            'True or False: Bowerbirds build beautiful structures just to impress females.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l2q4',
        text: 'Do birds stay with the same partner forever?',
        options: ['Some do (like Swans)', 'All do', 'None do', 'Only penguins'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l2q5',
        text:
            'Fill in the blank: When two birds gently touch beaks, it is called ______.',
        options: ['Billing', 'Kissing', 'Biting', 'Pecking'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l2q6',
        text: 'True or False: Female birds never sing, only males do.',
        options: ['False', 'True'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l2q7',
        text: 'What gift do some male birds give to females?',
        options: ['Food', 'Money', 'Toys', 'Books'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l2q8',
        text: 'Why do Peacocks have such giant tails?',
        options: [
          'Females like them',
          'To help them fly',
          'To swim faster',
          'To fight lions',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l2q9',
        text:
            'When two birds sing a song together perfectly, it is called a...',
        options: ['Duet', 'Solo', 'Chorus', 'Battle'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l2q10',
        text: 'Who am I? I am a sneaky Cuckoo who lays eggs in...',
        options: ['Other birds\' nests', 'Caves', 'The ocean', 'Trash cans'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'behav_l3',
    name: 'Meal Time',
    iconData: Icons.restaurant,
    questions: [
      Question(
        id: 'behav_l3q1',
        text: 'How does the Bearded Vulture eat bones?',
        options: [
          'Drops them to break them',
          'Chews them whole',
          'Boils them',
          'Buried them',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l3q2',
        text:
            'Fill in the blank: Skimmers catch fish by dragging their ______ in the water.',
        options: ['Lower beak', 'Wing', 'Foot', 'Tail'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l3q3',
        text:
            'True or False: Some birds steal food from other birds instead of hunting.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l3q4',
        text:
            'Find the odd one out: Which bird eats with its head upside down?',
        options: ['Flamingo', 'Eagle', 'Sparrow', 'Duck'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l3q5',
        text: 'Who am I? I am a Shrike and I stick my prey onto...',
        options: ['Thorns', 'Leaves', 'Clouds', 'Water'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l3q6',
        text: 'Some smart Herons catch fish using...',
        options: ['Bait (like bread)', 'Nets', 'Rods', 'Lasers'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l3q7',
        text: 'How do Woodpeckers find bugs inside trees?',
        options: [
          'Listening and Tapping',
          'Smelling',
          'Guessing',
          'X-ray vision',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l3q8',
        text:
            'Fill in the blank: A "Feeding Frenzy" happens when many birds ______ at once.',
        options: ['Eat', 'Sleep', 'Fly', 'Sing'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l3q9',
        text: 'Pelicans use their giant throat pouch to...',
        options: [
          'Scoop up fish',
          'Store clothes',
          'Carry babies',
          'Make noise',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l3q10',
        text: 'True or False: Some birds actually "farm" by growing fungus.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'behav_l4',
    name: 'Stay Safe',
    iconData: Icons.shield,
    questions: [
      Question(
        id: 'behav_l4q1',
        text: 'Why do some birds pretend to have a broken wing?',
        options: [
          'To lure predators away',
          'To get spare change',
          'To look cool',
          'To stretch',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l4q2',
        text:
            'True or False: "Mobbing" is when birds invite a predator to lunch.',
        options: ['False', 'True'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l4q3',
        text:
            'Who am I? I am a Potoo bird and I hide by looking exactly like...',
        options: ['A tree stump', 'A flower', 'A cloud', 'A rock'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l4q4',
        text:
            'Fill in the blank: When a bird "freezes", it is trying to ______.',
        options: ['Hide', 'Cool down', 'Sleep', 'Dance'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l4q5',
        text: 'Some baby birds defend themselves by vomiting. Is this true?',
        options: ['Yes, it smells bad', 'No, that\'s silly'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l4q6',
        text: 'Baby Hoatzins escape danger by doing what?',
        options: [
          'Dropping into water',
          'Flying into space',
          'Digging a tunnel',
          'Calling the police',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l4q7',
        text: 'An "Alarm Call" means...',
        options: ['Danger!', 'Food is here!', 'Good morning!', 'I love you!'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l4q8',
        text:
            'Find the odd one out: Nature is not always peaceful. Do birds fight?',
        options: ['Yes, over food/nests', 'No, never'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l4q9',
        text: 'How do Owls try to scare away enemies?',
        options: ['Puffing up big', 'Crying', 'Playing dead', 'Singing'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l4q10',
        text: 'Why are many bird eggs spotted?',
        options: ['Camouflage', 'Decoration', 'Measles', 'Mold'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'behav_l5',
    name: 'Bird Friends',
    iconData: Icons.people,
    questions: [
      Question(
        id: 'behav_l5q1',
        text: 'Fill in the blank: A large group of birds is called a ______.',
        options: ['Flock', 'Herd', 'Pack', 'Swarm'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l5q2',
        text: 'Why do birds hang out in flocks?',
        options: [
          'Use many eyes to spot danger',
          'To gossip',
          'To share clothes',
          'To race',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l5q3',
        text:
            'True or False: A "Mixed Flock" has different kinds of birds working together.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l5q4',
        text: 'Can birds recognize their best friends?',
        options: [
          'Yes, many can',
          'No, they are blind',
          'No, they forget',
          'Only their moms',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l5q5',
        text: 'When birds groom each other\'s feathers, what is it called?',
        options: ['Allopreening', 'Fighting', 'Tickling', 'Scratching'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l5q6',
        text: 'Who am I? I am a Crow and I am known for being very...',
        options: ['Social and Smart', 'Shy', 'Quiet', 'Lonely'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l5q7',
        text: 'What is a "Roost"?',
        options: [
          'A place to sleep',
          'A type of food',
          'A funny dance',
          'A baby bird',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l5q8',
        text:
            'Fill in the blank: Starlings flying in giant wavy shapes is called a ______.',
        options: ['Murmuration', 'Tornado', 'Cyclone', 'Circle'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l5q9',
        text: 'True or False: Some birds help their parents raise new babies.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l5q10',
        text: 'Who is usually the "Boss" of a flock?',
        options: [
          'The biggest/strongest',
          'The smallest',
          'The funniest',
          'The bluest',
        ],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'behav_l6',
    name: 'Parenting',
    iconData: Icons.child_care,
    questions: [
      Question(
        id: 'behav_l6q1',
        text: 'How do parents usually bring food to babies?',
        options: [
          'In their beak/crop',
          'Use a bag',
          'Order delivery',
          'In their feet',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l6q2',
        text:
            'Fill in the blank: Parents keep the nest clean by removing ______ sacs.',
        options: ['Fecal (Poop)', 'Food', 'Feather', 'Egg'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l6q3',
        text: 'In most bird families, who feeds the babies?',
        options: ['Both Mom and Dad', 'Only Mom', 'Only Dad', 'The neighbor'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l6q4',
        text: 'How does a Penguin mom find her baby in a giant crowd?',
        options: [
          'By its voice/call',
          'By guessing',
          'She doesn\'t',
          'By name tag',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l6q5',
        text: 'definition: "Brooding" means...',
        options: [
          'Sitting on chicks to warm them',
          'Being angry',
          'Building a nest',
          'Laying eggs',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l6q6',
        text: 'True or False: Bird parents give their babies flying lessons.',
        options: ['False', 'True'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l6q7',
        text: 'What might parents do if a predator comes near the nest?',
        options: [
          'Attack or distract it',
          'Invite it in',
          'Sleep',
          'Sing to it',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l6q8',
        text: 'When a baby bird grows feathers and leaves the nest, it...',
        options: ['Fledges', 'Falls', 'Graduates', 'Retires'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l6q9',
        text: 'What is a "Creche"?',
        options: [
          'A bird daycare',
          'A bird hospital',
          'A bird school',
          'A bird jail',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l6q10',
        text: 'Who am I? I am a Cuckoo and I am a bad parent because...',
        options: [
          'I leave my eggs for others',
          'I eat my eggs',
          'I paint my eggs',
          'I lose my eggs',
        ],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'behav_l7',
    name: 'Bird Talk',
    iconData: Icons.record_voice_over,
    questions: [
      Question(
        id: 'behav_l7q1',
        text: 'Why do birds sing songs?',
        options: [
          'To attract a mate/defend territory',
          'To tell jokes',
          'To order food',
          'To scare ghosts',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l7q2',
        text:
            'True or False: Birds from different places can have regional accents.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l7q3',
        text: 'How do Woodpeckers "talk" to each other?',
        options: ['Drumming on trees', 'Whistling', 'Clapping', 'Stomping'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l7q4',
        text: 'If a bird raises its crest (head feathers), it usually feels...',
        options: ['Excited or alarmed', 'Sleepy', 'Bored', 'Hungry'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l7q5',
        text: 'Why do baby birds squeak so loudly?',
        options: [
          'To beg for food',
          'To practice singing',
          'To annoy parents',
          'To sleep',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l7q6',
        text: 'Can birds communicate using visual colors?',
        options: [
          'Yes, by flashing wings',
          'No, they are colorblind',
          'Only with flags',
          'Never',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l7q7',
        text:
            'Fill in the blank: When a bird bobs its tail up and down, it is called tail ______.',
        options: ['Pumping', 'Waving', 'Shaking', 'Spinning'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l7q8',
        text:
            'True or False: Birds can understand the alarm calls of other species.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l7q9',
        text: 'The Syrix allows some birds to sing...',
        options: [
          'Two notes at once',
          'Under water',
          'Without opening mouth',
          'In French',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l7q10',
        text:
            'Who am I? I am a bird singing very early in the morning during the "Dawn...?"',
        options: ['Chorus', 'Party', 'Meeting', 'Breakfast'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'behav_l8',
    name: 'Clean & Tidy',
    iconData: Icons.cleaning_services,
    questions: [
      Question(
        id: 'behav_l8q1',
        text: 'What is the main reason birds preen their feathers?',
        options: [
          'To keep them aligned and clean',
          'To reduce weight',
          'To look scary',
          'To change color',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l8q2',
        text:
            'Fill in the blank: Birds get conditioning oil from a gland near their ______.',
        options: ['Tail', 'Beak', 'Ear', 'Knee'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l8q3',
        text: 'True or False: Dust baths are used to remove oil and parasites.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l8q4',
        text: 'Why do some birds spread their wings in the sun?',
        options: [
          'To kill parasites/warm up',
          'To get a tan',
          'To catch rain',
          'To hide',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l8q5',
        text:
            'Find the odd one out: Which of these is NOT a way birds clean themselves?',
        options: ['Using soap', 'Dust bathing', 'Sun bathing', 'Preening'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l8q6',
        text: 'How do birds clean their beaks?',
        options: [
          'Wiping them on branches',
          'Licking them',
          'Using a napkin',
          'Dipping in sand',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l8q7',
        text: 'Why do birds put ants on their feathers?',
        options: [
          'Ant acid kills mites',
          'They like the smell',
          'To save snacks',
          'To look spiky',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l8q8',
        text: 'What do birds use a birdbath for?',
        options: [
          'To wash feathers and cool down',
          'To drink only',
          'To fish',
          'To sleep',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l8q9',
        text: 'How does a bird scratch its own head?',
        options: [
          'With its foot',
          'With its wing',
          'With a stick',
          'With its tail',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l8q10',
        text:
            'Fill in the blank: When old feathers fall out and new ones grow, it is called ______.',
        options: ['Molting', 'Shedding', 'Baldness', 'Aging'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'behav_l9',
    name: 'Smarty Pants',
    iconData: Icons.psychology,
    questions: [
      Question(
        id: 'behav_l9q1',
        text: 'How smart is a Crow compared to a human child?',
        options: [
          'Like a 7-year-old',
          'Like a baby',
          'Not smart at all',
          'Like a teenager',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l9q2',
        text: 'The Clark\'s Nutcracker uses its memory to find...',
        options: ['Hidden seeds', 'Its parents', 'New nests', 'Water'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l9q3',
        text: 'True or False: Some birds can count small quantities.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l9q4',
        text: 'Do birds ever play just for fun?',
        options: [
          'Yes, especially parrots/crows',
          'No, never',
          'Only babies',
          'Only when sleeping',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l9q5',
        text: 'Who am I? I am a bird known to grieve when a friend dies.',
        options: ['Magpie/Jay', 'Chicken', 'Ostrich', 'Robin'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l9q6',
        text: 'Why do some Crows drop nuts on busy roads?',
        options: [
          'So cars crush them open',
          'To pave the road',
          'To feed cars',
          'Accidentally',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l9q7',
        text: 'Alex the Parrot was famous because he could...',
        options: [
          'Name colors and shapes',
          'Drive a car',
          'Cook',
          'Fly a plane',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l9q8',
        text:
            'Fill in the blank: Caching food shows that birds can ______ ahead.',
        options: ['Plan', 'Run', 'Dream', 'Sing'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l9q9',
        text: 'What does "Tool Use" mean for a bird?',
        options: [
          'Using a stick to get food',
          'Building a modern house',
          'Typing',
          'Cooking',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l9q10',
        text: 'True or False: A small brain means a bird is stupid.',
        options: ['False', 'True'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'behav_l10',
    name: 'Weird & Wacky',
    iconData: Icons.help_outline,
    questions: [
      Question(
        id: 'behav_l10q1',
        text:
            'Who am I? I am the only bird that truly hibernates when it gets cold.',
        options: ['Common Poorwill', 'Penguin', 'Owl', 'Hawk'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l10q2',
        text: 'The Honeyguide bird works with humans to find...',
        options: ['Beehives', 'Gold', 'Water', 'Caves'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l10q3',
        text:
            'Fill in the blank: The Tailorbird builds a nest by ______ leaves together.',
        options: ['Sewing', 'Gluing', 'Stapling', 'Taping'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l10q4',
        text: 'True or False: Swifts can sleep while flying.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l10q5',
        text: 'Manakins make loud snapping sounds using their...',
        options: ['Wings', 'Beak', 'Toes', 'Knees'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l10q6',
        text: 'The Hamerkop builds a GIGANTIC nest. What is it made of?',
        options: ['Thousands of sticks', 'Mud', 'Leaves', 'Stones'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l10q7',
        text: 'Who am I? I am a Burrowing Owl and I mimic a Rattlesnake to...',
        options: [
          'Scare predators',
          'Make friends',
          'Sing a song',
          'Find water',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l10q8',
        text: 'Find the odd one out: What does the Vampire Finch drink?',
        options: ['Blood', 'Water', 'Nectar', 'Juice'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l10q9',
        text: 'Why does the Hornbill mom seal herself inside a tree?',
        options: [
          'To protect eggs',
          'She is stuck',
          'She is hiding',
          'To sleep forever',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'behav_l10q10',
        text:
            'True or False: Some birds put cigarette butts in nests to kill parasites.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
    ],
  ),
];
