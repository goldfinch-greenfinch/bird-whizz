import 'package:flutter/material.dart';
import '../../models/question.dart';
import '../../models/level.dart';

final List<Level> familiesLevels = [
  Level(
    id: 'families_l1',
    name: 'Bird Families',
    iconData: Icons.family_restroom,
    questions: [
      Question(
        id: 'life_l2q1',
        text: 'Who am I? I am very smart and belong to the "Corvid" family.',
        options: ['Crow', 'Duck', 'Chicken', 'Robin'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'life_l2q2',
        text: 'Which bird is in the same family as a Duck?',
        options: ['Goose', 'Eagle', 'Owl', 'Parrot'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'life_l2q3',
        text: 'True or False: Owls have special feathers for silent flight.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'life_l2q4',
        text:
            'The biggest group of birds (Songbirds/Perching birds) are called...',
        options: ['Passerines', 'Raptors', 'Waterfowl', 'Ratites'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'life_l2q5',
        text:
            'Fill in the blank: Woodpeckers are famous for ______ on trees to find bugs.',
        options: ['Pecking/Drumming', 'Sleeping', 'Singing', 'Painting'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'life_l2q6',
        text: 'Find the odd one out: Which of these is NOT a type of Parrot?',
        options: ['Sparrow', 'Macaw', 'Cockatoo', 'Parakeet'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'life_l2q7',
        text: 'Herons have long legs because they live in...',
        options: ['Shallow water', 'Trees', 'Caves', 'Deserts'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'life_l2q8',
        text: '"Birds of Prey" mostly eat...',
        options: ['Meat', 'Seeds', 'Fruit', 'Grass'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'life_l2q9',
        text: 'The American Robin belongs to the ______ family.',
        options: ['Thrush', 'Crow', 'Duck', 'Owl'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'life_l2q10',
        text: 'Gulls are typically found near the...',
        options: ['Ocean', 'Desert', 'Forest', 'Moon'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'fam_l2',
    name: 'Passerines',
    iconData: Icons.music_note,
    questions: [
      Question(
        id: 'fam_l2q1',
        text: 'What is a "Passerine"?',
        options: [
          'A perching bird',
          'A bird of prey',
          'A swimming bird',
          'A dinosaur',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l2q2',
        text:
            'Passerines have special feet for perching. How are their toes arranged?',
        options: [
          '3 facing front, 1 back',
          '2 front, 2 back',
          'All 4 front',
          'Webbed',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l2q3',
        text: 'Which of these is a Passerine?',
        options: ['Sparrow', 'Eagle', 'Duck', 'Ostrich'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l2q4',
        text:
            'True or False: More than half of all bird species are Passerines.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l2q5',
        text: 'Find the odd one out: Which bird is NOT a Passerine?',
        options: ['Hawk', 'Cardinal', 'Robin', 'Blue Jay'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l2q6',
        text: 'Are Parrots considered Passerines?',
        options: ['No', 'Yes', 'Sometimes', 'Only green ones'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l2q7',
        text: 'Passerines are famous for using their "Syrinx" to...',
        options: ['Sing complex songs', 'Swim fast', 'Dig holes', 'Fight'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l2q8',
        text:
            'Who am I? I am a tiny Passerine with a loud voice and a tail that sticks up.',
        options: ['Wren', 'Crow', 'Eagle', 'Pelican'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l2q9',
        text: 'Swallows are Passerines that are expert...',
        options: ['Fliers', 'Swimmers', 'Runners', 'Diggers'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l2q10',
        text: 'Which family of Passerines is considered the smartest?',
        options: ['Corvids (Crows)', 'Thrushes', 'Sparrows', 'Finches'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'fam_l3',
    name: 'Raptors',
    iconData: Icons.visibility,
    questions: [
      Question(
        id: 'fam_l3q1',
        text: 'Raptors catch prey with their sharp claws, called...',
        options: ['Talons', 'Fingernails', 'Toes', 'Hooks'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l3q2',
        text: 'Falcons are most famous for their...',
        options: [
          'Incredible speed',
          'Swimming ability',
          'Singing voice',
          'Good jokes',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l3q3',
        text: 'Who am I? I am a Raptor with a heart-shaped face.',
        options: ['Barn Owl', 'Eagle', 'Hawk', 'Vulture'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l3q4',
        text: 'Ospreys are unique Raptors because they only eat...',
        options: ['Fish', 'Seeds', 'Bugs', 'Grass'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l3q5',
        text: 'Vultures are "Scavengers". This means they...',
        options: [
          'Eat dead animals',
          'Hunt live animals',
          'Eat fruit',
          'Eat nothing',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l3q6',
        text: 'The Secretarybird hunts snakes by...',
        options: [
          'Stomping on them',
          'Flying them high',
          'Singing to them',
          'Pecking them',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l3q7',
        text: 'True or False: Most Owls hunt at night (Nocturnal).',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l3q8',
        text: 'Fill in the blank: An Eagle\'s nest is called an ______.',
        options: ['Aerie', 'Igloo', 'Apartment', 'Burrow'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l3q9',
        text:
            'Find the odd one out: Which bird is NOT closely related to the others?',
        options: ['Owl', 'Hawk', 'Eagle', 'Kite'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l3q10',
        text: 'Falcons have a "tooth" on their beak. What is it for?',
        options: [
          'Breaking prey\'s neck',
          'Chewing gum',
          'Looking cool',
          'Opening seeds',
        ],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'fam_l4',
    name: 'Waterfowl',
    iconData: Icons.water,
    questions: [
      Question(
        id: 'fam_l4q1',
        text: 'Ducks and Geese have what kind of feet?',
        options: ['Webbed', 'Clawed', 'Hooved', 'Sticky'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l4q2',
        text:
            'True or False: Whistling Ducks actually whistle instead of quacking.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l4q3',
        text: 'Who usually makes the loud "Quack" sound?',
        options: ['Female Mallard', 'Male Mallard', 'Baby Duck', 'Goose'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l4q4',
        text: 'Geese are usually ______ than ducks.',
        options: ['Bigger', 'Smaller', 'Quieter', 'Blue'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l4q5',
        text:
            'Find the odd one out: Grebes are water birds but their toes are...',
        options: ['Lobed (not webbed)', 'Webbed', 'Missing', 'Fingers'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l4q6',
        text: 'Loons are amazing divers but are bad at...',
        options: ['Walking on land', 'Swimming', 'Flying', 'Fishing'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l4q7',
        text: '"Dabbling Ducks" feed by...',
        options: [
          'Tipping their tails up',
          'Diving deep',
          'Walking on land',
          'Ordering pizza',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l4q8',
        text: 'Which type of duck dives completely underwater?',
        options: ['Diving Duck', 'Mallard', 'Goose', 'Swan'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l4q9',
        text: 'Flamingos feed by filtering water for...',
        options: ['Shrimp and Algae', 'Big Fish', 'Rocks', 'Sandwiches'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l4q10',
        text: 'The Magpie Goose is black and white like a...',
        options: ['Magpie', 'Rainbow', 'Tiger', 'Tomato'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'fam_l5',
    name: 'Seabirds',
    iconData: Icons.sailing,
    questions: [
      Question(
        id: 'fam_l5q1',
        text:
            'Who am I? I am a seabird that "flies" underwater but cannot fly in the air.',
        options: ['Penguin', 'Puffin', 'Gull', 'Albatross'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l5q2',
        text: 'The Wandering Albatross has the largest ______ of any bird.',
        options: ['Wingspan', 'Beak', 'Foot', 'Head'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l5q3',
        text: 'Pelicans are famous for their...',
        options: ['Giant throat pouch', 'Long legs', 'Red eyes', 'Sharp claws'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l5q4',
        text: 'Gulls are "Opportunists". This means they...',
        options: [
          'Eat almost anything',
          'Only eat fish',
          'Only eat bugs',
          'Don\'t eat',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l5q5',
        text: 'Gannets hunt fish by...',
        options: [
          'Diving from high in the air',
          'Swimming calmly',
          'Asking nicely',
          'Waiting on the beach',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l5q6',
        text: 'Which bird is nicknamed the "Sea Parrot" or "Clown of the Sea"?',
        options: ['Puffin', 'Penguin', 'Eagle', 'Owl'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l5q7',
        text: 'Frigatebirds are pirates! They steal...',
        options: ['Food from other birds', 'Gold coins', 'Ships', 'Hats'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l5q8',
        text: 'True or False: Storm-Petrels appear to walk on water.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l5q9',
        text: 'Terns are often called "Sea Swallows" because they are...',
        options: ['Graceful fliers', 'Purple', 'Slow', 'Fat'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l5q10',
        text: '"Tube-noses" like Petrels use their special nose to...',
        options: [
          'Remove salt from seawater',
          'Blow bubbles',
          'Scare fish',
          'Whistle',
        ],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'fam_l6',
    name: 'Parrots & Toucans',
    iconData: Icons.pest_control_rodent, // No parrot icon
    questions: [
      Question(
        id: 'fam_l6q1',
        text: 'Parrots are famous for their ability to...',
        options: [
          'Mimic human speech',
          'Fly silently',
          'Swim underwater',
          'Catch mice',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l6q2',
        text: 'Parrot feet are "Zygodactyl". This means...',
        options: [
          '2 toes front, 2 toes back',
          '3 toes front, 1 back',
          'Webbed',
          'No toes',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l6q3',
        text: 'Cockatoos are easily recognized by the...',
        options: [
          'Crest on their head',
          'Blue feet',
          'Short beak',
          'Long neck',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l6q4',
        text: 'Who am I? I am a heavy, flightless, nocturnal parrot.',
        options: ['Kakapo', 'Macaw', 'Lorikeet', 'Budgie'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l6q5',
        text: 'Why do Toucans have such big beaks?',
        options: [
          'To reach fruit and release heat',
          'To eat fish',
          'To fight lions',
          'To dig',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l6q6',
        text: 'True or False: Toucans are related to Woodpeckers.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l6q7',
        text: 'The largest flying parrots are the...',
        options: ['Macaws', 'Budgies', 'Lovebirds', 'Parakeets'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l6q8',
        text: 'Parrots use their strong beak like a...',
        options: ['Third foot for climbing', 'Hammer', 'Knife', 'Spoon'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l6q9',
        text: 'Toucans mainly eat...',
        options: ['Fruit', 'Fish', 'Grass', 'Meat'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l6q10',
        text: 'Lories are parrots with brush-tipped tongues to eat...',
        options: ['Nectar', 'Steak', 'Bones', 'Rocks'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'fam_l7',
    name: 'Shorebirds',
    iconData: Icons.waves,
    questions: [
      Question(
        id: 'fam_l7q1',
        text: 'Shorebirds are best suited for life on...',
        options: ['Beaches and Mudflats', 'Trees', 'Mountains', 'Deserts'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l7q2',
        text: 'Sandpipers use their long bills to...',
        options: ['Probe into sand/mud', 'Catch flies', 'Dig holes', 'Fight'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l7q3',
        text: 'Plovers hunt by sight. Their move is...',
        options: [
          'Run, Stop, Peck',
          'Swim, Dive, Eat',
          'Fly, Hover, Grab',
          'Sleep, Wake, Eat',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l7q4',
        text: 'Oystercatchers specialize in eating...',
        options: ['Shellfish (Clams/Mussels)', 'Fish', 'Seaweed', 'Sand'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l7q5',
        text: 'Find the odd one out: Which bird is NOT a Shorebird?',
        options: ['Heron', 'Sandpiper', 'Plover', 'Oystercatcher'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l7q6',
        text:
            'Who am I? I am a black and white shorebird with extremely long pink legs.',
        options: ['Black-necked Stilt', 'Robin', 'Eagle', 'Duck'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l7q7',
        text:
            'True or False: Some shorebirds migrate from the Arctic to South America.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l7q8',
        text: 'Different beak lengths allow shorebirds to...',
        options: [
          'Eat different food in the same place',
          'Sing different songs',
          'Look pretty',
          'Fight better',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l7q9',
        text: 'The Jacana has huge toes to walk on...',
        options: ['Lily pads', 'Ice', 'Clouds', 'Fire'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l7q10',
        text: 'Shorebird chicks hatch ready to run. This means they are...',
        options: ['Precocial', 'Altricial', 'Helpless', 'Sleepy'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'fam_l8',
    name: 'Songbirds',
    iconData: Icons.music_video,
    questions: [
      Question(
        id: 'fam_l8q1',
        text: 'Old World Sparrows (like the House Sparrow) live...',
        options: [
          'Near people/Cities',
          'In deep jungles',
          'In Antarctica',
          'In the ocean',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l8q2',
        text: 'Finches have a thick, conical beak for eating...',
        options: ['Seeds', 'Fish', 'Meat', 'Nectar'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l8q3',
        text: 'Warblers are often small, colorful, and eat...',
        options: ['Insects', 'Fish', 'Mice', 'Grass'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l8q4',
        text: 'Thrushes (like Robins) are famous for their...',
        options: [
          'Beautiful songs',
          'Bad attitude',
          'Slow flight',
          'Green color',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l8q5',
        text: 'The Red-winged Blackbird loves to live in...',
        options: ['Marshes/Swamps', 'Deserts', 'Caves', 'Attics'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l8q6',
        text: 'Who am I? I am a red songbird with a crest on my head.',
        options: ['Northern Cardinal', 'Robin', 'Crow', 'Blue Jay'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l8q7',
        text: 'Tanagers are birds of the forest canopy that love...',
        options: ['Fruit', 'Fish', 'Mud', 'Snow'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l8q8',
        text: 'A huge flock of Starlings moving together is called a...',
        options: ['Murmuration', 'Parade', 'Party', 'School'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l8q9',
        text: 'Wrens are tiny birds with a big voice and a tail that...',
        options: [
          'Sticks straight up',
          'Drags on the ground',
          'Is missing',
          'Is blue',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l8q10',
        text:
            'True or False: Songbirds have to learn their songs from their parents.',
        options: ['True (mostly)', 'False, they are born knowing it'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'fam_l9',
    name: 'Gamebirds',
    iconData: Icons.sports, // loosely game
    questions: [
      Question(
        id: 'fam_l9q1',
        text: 'Chickens, Turkeys, and Quail are all...',
        options: [
          'Gamebirds (Galliformes)',
          'Songbirds',
          'Raptors',
          'Waterfowl',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l9q2',
        text: 'Male Pheasants are known for their...',
        options: [
          'Long, beautiful tails',
          'Loud bark',
          'Swimming skills',
          'Huge nests',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l9q3',
        text: 'A group of Quail is called a...',
        options: ['Covey', 'Herd', 'Pack', 'Swarm'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l9q4',
        text: 'Grouse are famous for their odd...',
        options: ['Mating displays/Dances', 'Singing', 'Flying', 'Swimming'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l9q5',
        text: 'The Peacock\'s "tail" is actually called a...',
        options: ['Train', 'Dress', 'Cape', 'Flag'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l9q6',
        text: 'Guineafowl are covered in...',
        options: ['Polka-dots', 'Stripes', 'Squares', 'Stars'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l9q7',
        text: 'Gamebirds are usually better at ______ than flying.',
        options: ['Walking/Running', 'Swimming', 'Singing', 'Climbing'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l9q8',
        text: 'Megapodes don\'t sit on eggs. Instead they...',
        options: [
          'Build a compost mound to warm them',
          'Put them in fire',
          'Put them in water',
          'Carry them',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l9q9',
        text: 'What is a male chicken called?',
        options: ['Rooster', 'Hen', 'Drake', 'Bull'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l9q10',
        text: 'The ancestor of the domestic Chicken is the...',
        options: ['Red Junglefowl', 'Turkey', 'Dodo', 'Eagle'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'fam_l10',
    name: 'Ratites',
    iconData: Icons.question_mark,
    questions: [
      Question(
        id: 'fam_l10q1',
        text: 'Ratites are a group of birds that...',
        options: ['Cannot fly', 'Fly very fast', 'Swim only', 'Sing opera'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l10q2',
        text: 'Who am I? I am the largest bird in the world.',
        options: ['Ostrich', 'Emu', 'Kiwi', 'Robin'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l10q3',
        text: 'The Emu is found in...',
        options: ['Australia', 'Africa', 'America', 'Europe'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l10q4',
        text: 'The Kiwi lays an egg that is...',
        options: ['Huge for its body size', 'Tiny', 'Blue', 'Invisible'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l10q5',
        text: 'Cassowaries have a hard helmet called a...',
        options: ['Casque', 'Hat', 'Crown', 'Horn'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l10q6',
        text: 'The Rhea looks like a small Ostrich but lives in...',
        options: ['South America', 'China', 'France', 'The Moon'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l10q7',
        text: 'Which giant Ratite is now extinct?',
        options: ['Moa / Elephant Bird', 'Chicken', 'Ostrich', 'Emu'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l10q8',
        text:
            'True or False: Ratites have a flat breastbone because they don\'t need big flight muscles.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l10q9',
        text: 'Tinamous are the only Ratite relatives that can...',
        options: ['Fly', ' swim', 'Talk', 'Teleport'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'fam_l10q10',
        text: 'Ostriches can run faster than...',
        options: ['A horse', 'A car', 'A plane', 'Light'],
        correctOptionIndex: 0,
      ),
    ],
  ),
];
