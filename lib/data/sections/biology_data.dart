import 'package:flutter/material.dart';
import '../../models/question.dart';
import '../../models/level.dart';

final List<Level> biologyLevels = [
  Level(
    id: 'bio_l1',
    name: 'Feather Forms',
    iconData: Icons.biotech,
    questions: [
      Question(
        id: 'bio_l1q1',
        text:
            'Fill in the blank: Feathers are made of ______, the same material as your fingernails.',
        options: ['Keratin', 'Calcium', 'Enamel', 'Bone'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l1q2',
        text: 'Which specific feathers help a bird fly?',
        options: [
          'Flight Feathers',
          'Down Feathers',
          'Tail Feathers',
          'Ear Feathers',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l1q3',
        text: 'Why do birds put oil on their feathers?',
        options: [
          'To make them waterproof',
          'To turn them red',
          'To make them heavy',
          'To smell good',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l1q4',
        text:
            'True or False: "Molting" is when a bird sheds old feathers to grow new ones.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l1q5',
        text:
            'The hard stick running down the center of a feather is called the...',
        options: ['Shaft', 'Branch', 'Trunk', 'Root'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l1q6',
        text: 'Why do many male birds have bright colorful feathers?',
        options: [
          'To attract a mate',
          'To hide in the grass',
          'To scare away bugs',
          'To stay warm',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l1q7',
        text:
            'Find the odd one out: A blue feather is not actually blue! It is...',
        options: [
          'A trick of light',
          'Painted by parents',
          'Stained by berries',
          'Bruised',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l1q8',
        text: 'Which fluffy feathers keep a bird warm?',
        options: [
          'Down Feathers',
          'Flight Feathers',
          'Tail Feathers',
          'Wing Feathers',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l1q9',
        text: 'How often do most birds change all their feathers?',
        options: ['Once a year', 'Every week', 'Every 10 years', 'Never'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l1q10',
        text: 'Feathers stay smooth because they zip together with tiny...',
        options: ['Hooks', 'Glue', 'Magnets', 'Knots'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'bio_l2',
    name: 'Bird Bodies',
    iconData: Icons.medical_services_outlined,
    questions: [
      Question(
        id: 'bio_l2q1',
        text: 'True or False: Adult birds do not have teeth.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l2q2',
        text: 'Why are bird bones hollow?',
        options: [
          'To be light for flying',
          'To store extra air',
          'To float in water',
          'Because they are weak',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l2q3',
        text: 'Where are the biggest muscles in a bird?',
        options: ['Chest (for flying)', 'Legs', 'Neck', 'Tail'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l2q4',
        text: 'Find the odd one out: A bird\'s heart beats...',
        options: ['Very fast', 'Slowly', 'Once an hour', 'Only when sleeping'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l2q5',
        text:
            'Since they have no teeth, what part of the stomach grinds up food?',
        options: ['The Gizzard', 'The Throat', 'The Beak', 'The Tongue'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l2q6',
        text:
            'Fill in the blank: Birds store food to eat later in a pouch called the ______.',
        options: ['Crop', 'Pocket', 'Cheek', 'Sock'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l2q7',
        text: 'Birds have super-efficient lungs to help them...',
        options: ['Fly high', 'Sing loud', 'Sleep long', 'Swim deep'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l2q8',
        text: 'Which sense is the most powerful in Eagles?',
        options: ['Sight', 'Smell', 'Taste', 'Touch'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l2q9',
        text: 'Who am I? I am the special voice box that allows birds to sing.',
        options: ['Syrinx', 'Larynx', 'Whistle', 'Drum'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l2q10',
        text: 'Why do Owls have such huge eyes?',
        options: [
          'To see in the dark',
          'To look scary',
          'To read books',
          'To see colors better',
        ],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'bio_l3',
    name: 'Egg-cellent Biology',
    iconData: Icons.egg_outlined,
    questions: [
      Question(
        id: 'bio_l3q1',
        text: 'Eggshells are mostly made of what material?',
        options: ['Calcium', 'Iron', 'Glass', 'Wood'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l3q2',
        text: 'What does the yellow Yolk do for the chick?',
        options: [
          'Provides food',
          'Provides water',
          'Provides air',
          'Provides entertainment',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l3q3',
        text: 'Who am I? I lay the largest egg in the world.',
        options: ['Ostrich', 'Chicken', 'Robin', 'Eagle'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l3q4',
        text: 'The clear white part of the egg (Albumin) works like...',
        options: ['A cushion/water supply', 'A pillow', 'Glue', 'Paint'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l3q5',
        text: 'True or False: Birds build nests mainly to hold their eggs.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l3q6',
        text:
            'Fill in the blank: Sitting on eggs to keep them warm is called ______.',
        options: ['Incubation', 'Hibernation', 'Relaxation', 'Vacation'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l3q7',
        text: 'Why is the Cuckoo bird called a "Brood Parasite"?',
        options: [
          'It lays eggs in other nests',
          'It eats bugs',
          'It has ticks',
          'It is messy',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l3q8',
        text: 'How does a chick breathe inside the egg?',
        options: [
          'Through tiny pores in the shell',
          'It holds its breath',
          'Through a straw',
          'It doesn\'t breathe',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l3q9',
        text: 'What tool does a chick use to break out of the shell?',
        options: ['Egg tooth', 'Hammer', 'Claw', 'Beak'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l3q10',
        text: 'What color are American Robin eggs?',
        options: ['Blue', 'Red', 'Yellow', 'Purple'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'bio_l4',
    name: 'Bird Senses',
    iconData: Icons.visibility_outlined,
    questions: [
      Question(
        id: 'bio_l4q1',
        text: 'True or False: Most birds have a very poor sense of smell.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l4q2',
        text: 'What is the "Nictitating Membrane"?',
        options: [
          'A third see-through eyelid',
          'A wing bone',
          'A tail feather',
          'A type of food',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l4q3',
        text: 'Many birds can see a type of light humans cannot. What is it?',
        options: ['UV Light', 'X-Rays', 'Radio Waves', 'Heat'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l4q4',
        text: 'Why are Owl ears crooked (one higher than the other)?',
        options: [
          'To pinpoint sounds accurately',
          'It is an accident',
          'To hold glasses',
          'To fly faster',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l4q5',
        text:
            'Who am I? I am a Vulture and unlike other birds, I have an amazing sense of...',
        options: ['Smell', 'Taste', 'Humor', 'Style'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l4q6',
        text:
            'Birds have amazing balance thanks to a special organ in their...',
        options: ['Inner ear', 'Beak', 'Tail', 'Knee'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l4q7',
        text: 'Find the odd one out: Robins find worms mostly by...',
        options: [
          'Looking for them',
          'Smelling them',
          'Feeling vibrations',
          'Tasting dirt',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l4q8',
        text: 'Which is bigger: An Ostrich\'s eye or its brain?',
        options: ['Eye', 'Brain', 'Neither', 'Both are tiny'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l4q9',
        text: 'Hummingbirds are attracted to which color the most?',
        options: ['Red', 'Black', 'Grey', 'Brown'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l4q10',
        text:
            'Fill in the blank: Woodcocks can see 360 degrees because their eyes are on the ______ of their head.',
        options: ['Sides', 'Front', 'Top', 'Bottom'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'bio_l5',
    name: 'Beaks & Eats',
    iconData: Icons.rice_bowl,
    questions: [
      Question(
        id: 'bio_l5q1',
        text: 'Why do different birds have such different beaks?',
        options: [
          'It depends on what they eat',
          'To look different',
          'For singing',
          'No reason',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l5q2',
        text: 'Owls cough up a ball of bones and fur called a...',
        options: ['Pellet', 'Marble', 'Stone', 'Egg'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l5q3',
        text: 'Who am I? I have a crossed beak to pry open pine cones.',
        options: ['Red Crossbill', 'Eagle', 'Sparrow', 'Robin'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l5q4',
        text: 'True or False: Hummingbirds use their tongues to lap up nectar.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l5q5',
        text: 'Why do Macaws have such strong, thick beaks?',
        options: [
          'To crack hard nuts',
          'To fight',
          'To dig holes',
          'To climb trees',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l5q6',
        text:
            'Fill in the blank: A "Granivore" is a bird that mainly eats ______.',
        options: ['Seeds', 'Fish', 'Bugs', 'Meat'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l5q7',
        text: 'How do Flamingos eat?',
        options: [
          'With their head upside down',
          'With a spoon',
          'While lying down',
          'With their feet',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l5q8',
        text: 'Do birds chew their food?',
        options: [
          'No, they swallow it whole',
          'Yes, carefully',
          'Only meat',
          'Only fruit',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l5q9',
        text: 'Herons use their sharp beak like a ____________ to catch fish.',
        options: ['Spear', 'Spoon', 'Net', 'Hook'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l5q10',
        text: 'The Shrike eats by impaling its prey on...',
        options: ['Thorns', 'Leaves', 'Rocks', 'Clouds'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'bio_l6',
    name: 'Nests & Chicks',
    iconData: Icons.favorite,
    questions: [
      Question(
        id: 'bio_l6q1',
        text:
            'Baby ducks hatch with feathers and can swim immediately. They are...',
        options: ['Precocial', 'Altricial', 'Special', 'Official'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l6q2',
        text: 'Baby Robins hatch naked and helpless. They are...',
        options: ['Altricial', 'Precocial', 'Artificial', 'Beneficial'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l6q3',
        text: 'Why do parents lose feathers on their belly (Brood Patch)?',
        options: [
          'To transfer heat to eggs',
          'They are stressed',
          'To make the nest soft',
          'To swim faster',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l6q4',
        text:
            'True or False: Most birds raise their babies together (Mom and Dad).',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l6q5',
        text: 'Who usually has the job of singing and defending territory?',
        options: ['The Male', 'The Female', 'The Baby', 'The Neighbor'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l6q6',
        text: 'Birds that nest in dark holes often lay eggs that are...',
        options: ['White', 'Black', 'Invisible', 'Camo'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l6q7',
        text: 'Who sits on the eggs?',
        options: [
          'It varies by species',
          'Always the Mom',
          'Always the Dad',
          'Neither',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l6q8',
        text:
            'Fill in the blank: A chick that has just grown feathers and left the nest is a ______.',
        options: ['Fledgling', 'Hatchling', 'Nestling', 'Yearling'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l6q9',
        text: 'Why are female birds usually dull and brown?',
        options: [
          'For camouflage on the nest',
          'Because they are dirty',
          'They like mud',
          'No reason',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l6q10',
        text: 'Who am I? I am a Swiftlet and I make my nest entirely out of...',
        options: ['Saliva (Spit)', 'Mud', 'Sticks', 'Leaves'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'bio_l7',
    name: 'Migration',
    iconData: Icons.flight_takeoff,
    questions: [
      Question(
        id: 'bio_l7q1',
        text: 'What is the main reason birds fly south for winter?',
        options: [
          'To find food',
          'To stay warm',
          'To meet friends',
          'To exercise',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l7q2',
        text:
            'Who am I? I fly the longest migration of any bird (Pole to Pole).',
        options: ['Arctic Tern', 'Penguin', 'Eagle', 'Sparrow'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l7q3',
        text: 'Find the odd one out: Which tool do birds NOT use to navigate?',
        options: ['Google Maps', 'The Sun', 'The Stars', 'Magnetic Fields'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l7q4',
        text: 'True or False: All birds migrate.',
        options: ['False', 'True'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l7q5',
        text: 'An "Irruption" is when...',
        options: [
          'Many birds move due to lack of food',
          'A volcano explodes',
          'Birds stop singing',
          'Birds get sick',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l7q6',
        text: 'Why do many small songbirds migrate at night?',
        options: [
          'To avoid predators and stay cool',
          'To see the moon',
          'Traffic is lighter',
          'To sleep',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l7q7',
        text:
            'Fill in the blank: A major route used by migrating birds is called a ______.',
        options: ['Flyway', 'Highway', 'Skyway', 'Runway'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l7q8',
        text: 'What do birds eat to fuel their long flights?',
        options: ['Fatty foods', 'Sugar', 'Water', 'Rocks'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l7q9',
        text: 'Which insect is famous for migrating like a bird?',
        options: ['Monarch Butterfly', 'Ant', 'Bee', 'Mosquito'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l7q10',
        text:
            'True or False: Bar-tailed Godwits can fly 8 days without stopping.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'bio_l8',
    name: 'Bird Smarts',
    iconData: Icons.psychology,
    questions: [
      Question(
        id: 'bio_l8q1',
        text: 'Which two groups of birds are considered the smartest?',
        options: [
          'Crows and Parrots',
          'Ducks and Geese',
          'Robins and Wrens',
          'Chickens and Turkeys',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l8q2',
        text: 'True or False: Magpies can recognize themselves in a mirror.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l8q3',
        text: 'Crows show intelligence by using sticks as...',
        options: ['Tools', 'Weapons', 'Toys', 'Decorations'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l8q4',
        text: 'Parrots can mimic human speech. What does "mimic" mean?',
        options: ['Copy sound', 'Read', 'Write', 'Understand'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l8q5',
        text:
            'Fill in the blank: Nutcrackers hide seeds and use their amazing ______ to find them later.',
        options: ['Memory', 'Nose', 'Eyes', 'Ears'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l8q6',
        text: 'Who am I? I am a Kea parrot and I love to...',
        options: [
          'Solve puzzles and play',
          'Sleep all day',
          'Eat fish',
          'Swim',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l8q7',
        text: 'What can a Mockingbird do?',
        options: [
          'Sing the songs of other birds',
          'Fly backward',
          'Swim underwater',
          'Run very fast',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l8q8',
        text: 'Pigeons are famous for their ability to...',
        options: ['Find their way home', 'Do math', 'Paint', 'Cook'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l8q9',
        text: 'Bird songs have complex rules, similar to human...',
        options: ['Language', 'Traffic', 'Sports', 'Cooking'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l8q10',
        text: 'True or False: Some birds teach their young how to find food.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'bio_l9',
    name: 'Dino Birds',
    iconData: Icons.history_edu,
    questions: [
      Question(
        id: 'bio_l9q1',
        text: 'True or False: Birds are the only living dinosaurs.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l9q2',
        text:
            'Fill in the blank: Archaeopteryx was a famous fossil with feathers and ______.',
        options: ['Teeth', 'Fur', 'Fins', 'Horns'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l9q3',
        text: 'Which living animal is the closest relative to birds?',
        options: ['Crocodile', 'Snake', 'Frog', 'Shark'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l9q4',
        text: 'Who am I? I am a Hoatzin chick and I have claws on my...',
        options: ['Wings', 'Beak', 'Ears', 'Feet'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l9q5',
        text: 'What is a "Ratite"?',
        options: [
          'A large flightless bird (like an Ostrich)',
          'A tiny bird',
          'A water bird',
          'A bat',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l9q6',
        text: 'Why did birds lose their heavy teeth and jaws?',
        options: [
          'To save weight for flying',
          'They rotted',
          'To look better',
          'To eat bugs',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l9q7',
        text: 'The largest group of birds today is the...',
        options: [
          'Passerines (Perching Birds)',
          'Raptors',
          'Waterfowl',
          'Penguins',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l9q8',
        text: 'How long have birds been on Earth?',
        options: [
          'Millions of years',
          'Questions of years',
          '100 years',
          '10 years',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l9q9',
        text: 'True or False: Birds lived at the same time as T-Rex.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l9q10',
        text:
            'When unrelated animals evolve to look the same (like Penguins and Puffins), it is...',
        options: ['Convergent Evolution', 'Magic', 'Copying', 'Coincidence'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'bio_l10',
    name: 'Amazing Adaptations',
    iconData: Icons.handyman,
    questions: [
      Question(
        id: 'bio_l10q1',
        text: 'How can Seabirds drink saltwater?',
        options: [
          'They have special salt glands',
          'They boil it',
          'They don\'t drink',
          'They eat snow',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l10q2',
        text:
            'Fill in the blank: Hummingbirds enter a deep sleep called ______ to save energy.',
        options: ['Torpor', 'Coma', 'Nap', 'Hibernation'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l10q3',
        text: 'Why do Penguins have solid, heavy bones?',
        options: [
          'To help them dive deeper',
          'To fly better',
          'To run fast',
          'It is a mistake',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l10q4',
        text: 'Woodpeckers wrap their long tongue around their brain. Why?',
        options: [
          'To cushion the brain from impact',
          'To keep it warm',
          'To taste thoughts',
          'No reason',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l10q5',
        text: 'The Ptarmigan turns white in winter to...',
        options: [
          'Blend in with snow',
          'Look pretty',
          'Scare wolves',
          'Stay cool',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l10q6',
        text: 'Why do Swifts have such tiny weak feet?',
        options: [
          'They almost never land on the ground',
          'They swim',
          'They walk a lot',
          'They lost them',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l10q7',
        text: 'Who am I? I am an Anhinga and I spread my wings to...',
        options: ['Dry my feathers', 'Fly', 'Hug', 'Hide'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l10q8',
        text: 'Why do Vultures have bald heads?',
        options: [
          'To keep clean while eating',
          'To get a tan',
          'To look scary',
          'They pulled feathers out',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l10q9',
        text: 'True or False: Dipper birds can walk underwater.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'bio_l10q10',
        text: 'The Secretarybird uses its long legs to...',
        options: ['Stomp on snakes', 'Dance', 'Jump high', 'Run away'],
        correctOptionIndex: 0,
      ),
    ],
  ),
];
