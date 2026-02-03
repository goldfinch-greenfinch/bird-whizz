import 'package:flutter/material.dart';
import '../../models/question.dart';
import '../../models/level.dart';

final List<Level> coloursLevels = [
  Level(
    id: 'col_l1',
    name: 'Bird Rainbows',
    iconData: Icons.palette,
    questions: [
      Question(
        id: 'life_l4q1',
        text: 'Hummingbirds shine like jewels because their feathers are...',
        options: [
          'Reflective/Iridescent',
          'Made of metal',
          'Painted',
          'Covered in glitter',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'life_l4q2',
        text:
            'Fill in the blank: The Male Northern Cardinal is famous for being bright ______.',
        options: ['Red', 'Blue', 'Green', 'Yellow'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'life_l4q3',
        text: 'Why do white birds like Seagulls often have black wing tips?',
        options: [
          'To make feathers stronger',
          'To look cool',
          'To scare fish',
          'They are dirty',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'life_l4q4',
        text: 'What is "Leucism" in a bird?',
        options: [
          'Feathers with no color (White patches)',
          'A disease',
          'Losing a beak',
          'Having no feet',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'life_l4q5',
        text:
            'True or False: Female birds are often brown to hide on the nest.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'life_l4q6',
        text:
            'When a male and female bird look completely different, it is called...',
        options: ['Sexual Dimorphism', 'Confusion', 'Molting', 'Aging'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'life_l4q7',
        text:
            'True or False: There is no such thing as "True Blue" pigment in bird feathers.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'life_l4q8',
        text: 'Who am I? I am a Goldfinch and I have a bright red...',
        options: ['Face', 'Tail', 'Foot', 'Belly'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'life_l4q9',
        text: 'Birds can see a "secret" color range called...',
        options: ['Ultraviolet (UV)', 'X-Ray', 'Radio', 'Super Red'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'life_l4q10',
        text: 'Flamingos are pink because...',
        options: [
          'Their food has pigment',
          'They get sunburned',
          'They hold their breath',
          'They are born pink',
        ],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'col_l2',
    name: 'Colors from Food',
    iconData: Icons.brush,
    questions: [
      Question(
        id: 'col_l2q1',
        text: 'Black and brown colors come from a pigment called...',
        options: ['Melanin', 'Chlorophyll', 'Ink', 'Charcoal'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l2q2',
        text:
            'Fill in the blank: Birds get red and yellow colors from their ______.',
        options: ['Food', 'Parents', 'Sunlight', 'Water'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l2q3',
        text: 'Who am I? I am a Turaco and I am the only bird with true...',
        options: ['Green pigment', 'Blue bones', 'Gold eyes', 'Silver feet'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l2q4',
        text:
            'True or False: Parrots make their own red colors instead of getting them from food.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l2q5',
        text: 'Why do flight feathers often contain black Melanin?',
        options: [
          'It makes them stronger',
          'It makes them lighter',
          'It tastes bad',
          'It is warm',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l2q6',
        text: 'Find the odd one out: Which pigment does NOT exist in birds?',
        options: [
          'True Blue',
          'Red (Carotenoid)',
          'Black (Melanin)',
          'Brown (Melanin)',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l2q7',
        text: 'What happens to Flamingos if they don\'t eat shrimp/algae?',
        options: [
          'They turn white/grey',
          'They turn blue',
          'They die instantly',
          'They turn green',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l2q8',
        text: 'Crows are black because of...',
        options: [
          'Lots of Melanin',
          'Eating coal',
          'Flying at night',
          'Absorbing shadows',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l2q9',
        text:
            'Rusty red colors are usually made of "Phaeomelanin". Is this true?',
        options: ['Yes', 'No'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l2q10',
        text: 'Can birds produce the color yellow by themselves?',
        options: [
          'Usually no, it\'s from food',
          'Yes, always',
          'Only ducks',
          'Only owls',
        ],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'col_l3',
    name: 'Shiny & Bright',
    iconData: Icons.looks,
    questions: [
      Question(
        id: 'col_l3q1',
        text: 'If you ground up a Blue Jay feather, what color would it be?',
        options: ['Brown/Grey', 'Blue', 'Green', 'White'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l3q2',
        text: 'Iridescent feathers change color depending on...',
        options: [
          'The angle of light',
          'The bird\'s mood',
          'The temperature',
          'The wind',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l3q3',
        text:
            'True or False: The blue color in birds is a trick of the light (Physics).',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l3q4',
        text: 'Hummingbird throats shine like metal. This is called a...',
        options: ['Gorget', 'Necklace', 'Scarf', 'Tie'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l3q5',
        text:
            'Fill in the blank: White feathers look white because they ______ all light.',
        options: ['Scatter/Reflect', 'Absorb', 'Eat', 'Hide'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l3q6',
        text: 'Find the odd one out: Which of these is NOT a structural color?',
        options: ['Red', 'Blue', 'Iridescent Green', 'White'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l3q7',
        text: 'Green birds are usually a mix of Structural Blue and...',
        options: [
          'Yellow pigment',
          'Red pigment',
          'Green paint',
          'Grass stains',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l3q8',
        text: 'Do iridescent colors fade in the sun like pigments do?',
        options: [
          'No, they stay bright',
          'Yes, very fast',
          'They turn clear',
          'They melt',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l3q9',
        text: 'The "Super Black" bird of paradise absorbs...',
        options: [
          '99.9% of light',
          '50% of light',
          'Sound waves',
          'Radio waves',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l3q10',
        text: 'Peacocks have "eyes" on their tails made of...',
        options: ['Iridescent feathers', 'Real eyes', 'Stickers', 'Glass'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'col_l4',
    name: 'Hiding Patterns',
    iconData: Icons.texture,
    questions: [
      Question(
        id: 'col_l4q1',
        text: 'What is "Countershading"?',
        options: [
          'Dark back, light belly',
          'Polka dots',
          'Stripes everywhere',
          'Bright neon colors',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l4q2',
        text: 'How does countershading help a bird?',
        options: [
          'It hides their 3D shape',
          'It scares predators',
          'It attacks bugs',
          'It keeps them warm',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l4q3',
        text: 'Who am I? I am a Quail and I am brown and streaky to...',
        options: [
          'Hide in dead grass',
          'Look like a rock',
          'Look like a stick',
          'Be seen easily',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l4q4',
        text:
            'Fill in the blank: Dark stripes across the eye help to hide the bird\'s ______.',
        options: ['Eye shape', 'Beak', 'Ear', 'Nose'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l4q5',
        text: 'Why are baby chicks often spotted?',
        options: [
          'To look like sunlight on leaves',
          'They are sick',
          'They are dirty',
          'Decoration',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l4q6',
        text: 'The Killdeer has black bands on its chest to...',
        options: [
          'Break up its outline',
          'Hold its breath',
          'Look tough',
          'Store food',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l4q7',
        text: 'Owls have feather patterns that look exactly like...',
        options: ['Tree bark', 'Clouds', 'Bricks', 'Water'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l4q8',
        text: 'What are "Wing Bars"?',
        options: [
          'Stripes on the wing',
          'A place birds drink',
          'A gym for birds',
          'Heavy weights',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l4q9',
        text:
            'True or False: Spots and streaks make it harder for predators to see a bird\'s edges.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l4q10',
        text: 'A flashy color patch on a duck\'s wing is called a...',
        options: ['Speculum', 'Mirror', 'Window', 'Door'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'col_l5',
    name: 'Dressed to Impress',
    iconData: Icons.favorite_border,
    questions: [
      Question(
        id: 'col_l5q1',
        text: 'What is the main reason male birds are colorful?',
        options: [
          'To attract females',
          'To hide',
          'To stay cool',
          'They can\'t help it',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l5q2',
        text:
            'True or False: Bright colors can show that a male bird is healthy and strong.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l5q3',
        text: 'What is the downside of being bright red?',
        options: [
          'Predators can see you',
          'You get hot',
          'You can\'t fly',
          'You fall down',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l5q4',
        text:
            'Who am I? I am an Eclectus Parrot. The males are green, but the females are...',
        options: ['Bright Red/Blue', 'Yellow', 'Black', 'White'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l5q5',
        text:
            'After breeding, male ducks accidentally turn brown. This is called...',
        options: [
          'Eclipse Plumage',
          'Boring Mode',
          'Sleeping Mode',
          'Hiding Mode',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l5q6',
        text: 'The Painted Bunting is famous for...',
        options: [
          'Looking like a rainbow',
          'Being invisible',
          'Being all black',
          'Having no feathers',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l5q7',
        text: 'Bowerbirds impress females not with feathers, but with...',
        options: ['Blue trinkets/objects', 'Food', 'Money', 'Rocks'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l5q8',
        text: 'Find the odd one out: In Phalaropes, who is more colorful?',
        options: ['The Female', 'The Male', 'Neither', 'The Baby'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l5q9',
        text: 'Some birds have secret patterns that only glow under...',
        options: ['UV Light', 'Moonlight', 'Flashlights', 'Fire'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l5q10',
        text: 'Birds that mate for life (Monogamous) are often...',
        options: ['Similar in color', 'Opposite colors', 'Purple', 'Grey'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'col_l6',
    name: 'Outfit Changes',
    iconData: Icons.change_circle,
    questions: [
      Question(
        id: 'col_l6q1',
        text: 'When do American Goldfinches turn bright yellow?',
        options: [
          'In the Spring (Breeding)',
          'In Winter',
          'In Fall',
          'At night',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l6q2',
        text:
            'Fill in the blank: Feathers eventually get ragged and suffer from ______.',
        options: ['Wear', 'Rust', 'Mold', 'Dents'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l6q3',
        text:
            'True or False: Starlings get their spots because the tips of their feathers wear off.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l6q4',
        text: 'What do we call the process of replacing old feathers?',
        options: ['Molting', 'Shedding', 'Exploding', 'Refilling'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l6q5',
        text: 'How often do most birds molt?',
        options: ['1-2 times a year', 'Every week', 'Every 10 years', 'Never'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l6q6',
        text: 'Why can\'t ducks fly for a few weeks in summer?',
        options: [
          'They molt all wing feathers at once',
          'They are too fat',
          'They are tired',
          'They sell their wings',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l6q7',
        text: '"Basic Plumage" is another name for...',
        options: [
          'Winter/Non-breeding colors',
          'Summer colors',
          'Party clothes',
          'Baby colors',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l6q8',
        text: '"Alternate Plumage" usually refers to...',
        options: [
          'Breeding colors',
          'Sleeping colors',
          'Camouflage',
          'Hunting gear',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l6q9',
        text: 'Who am I? I turn completely white in winter to match the snow.',
        options: ['Ptarmigan', 'Crow', 'Robin', 'Parrot'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l6q10',
        text: 'If a bird is stressed while growing feathers, it gets...',
        options: ['Stress bars', 'Grey hair', 'Wrinkles', 'Acne'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'col_l7',
    name: 'Super Vision',
    iconData: Icons.visibility,
    questions: [
      Question(
        id: 'col_l7q1',
        text: 'Who has better color vision: Humans or Birds?',
        options: ['Birds', 'Humans', 'They are the same', 'Dogs'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l7q2',
        text: 'Birds have four color cones. Humans have...',
        options: ['Three', 'Two', 'Ten', 'One'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l7q3',
        text: 'Kestrels can find field mice by tracking their...',
        options: ['Urine (glowing in UV)', 'Footprints', 'Shadows', 'Squeaks'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l7q4',
        text:
            'True or False: To a bird, a male and female Blue Tit look identical.',
        options: ['False', 'True'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l7q5',
        text: 'Plants make berries bright red so birds will...',
        options: [
          'See/Eat them',
          'Hide them',
          'Ignore them',
          'Paint with them',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l7q6',
        text:
            'Fill in the blank: Birds have tiny oil ______ in their eyes to filter light.',
        options: ['Droplets', 'Lamps', 'Buckets', 'Spoons'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l7q7',
        text: 'Are any birds completely colorblind?',
        options: [
          'No, almost never',
          'Yes, all owls',
          'Yes, all ducks',
          'Yes, all crows',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l7q8',
        text: 'Why do Cuckoo eggs mimic the host eggs?',
        options: [
          'So the parents don\'t reject them',
          'To look pretty',
          'By accident',
          'To hatch faster',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l7q9',
        text: 'Owls trade color vision for better...',
        options: ['Night vision', 'Hearing', 'Smelling', 'Tasting'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l7q10',
        text: 'Why do nocturnal birds have such huge black pupils?',
        options: [
          'To let in maximum light',
          'To look cute',
          'To scare mice',
          'To protect from sun',
        ],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'col_l8',
    name: 'Odd Colors',
    iconData: Icons.error_outline,
    questions: [
      Question(
        id: 'col_l8q1',
        text: 'How can you tell a true Albino bird?',
        options: [
          'It has pink/red eyes',
          'It has blue eyes',
          'It has black eyes',
          'It wears glasses',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l8q2',
        text:
            'A bird that is pale or has white patches (But normal eyes) is...',
        options: ['Leucistic', 'Albino', 'Sleeping', 'Frozen'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l8q3',
        text: 'What is "Melanism"?',
        options: [
          'Too much black pigment',
          'Too much red',
          'Too much white',
          'Too much blue',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l8q4',
        text:
            'If a red bird eats the wrong food, it might turn yellow. This is...',
        options: ['Xanthochroism', 'Albinism', 'Leucism', 'Botulism'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l8q5',
        text: 'Why don\'t Albino birds live very long?',
        options: [
          'Predators see them easily',
          'They get cold',
          'They can\'t fly',
          'They are lonely',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l8q6',
        text: 'True or False: Albino birds often have poor eyesight.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l8q7',
        text: 'Which is more common: Leucism or Albinism?',
        options: ['Leucism', 'Albinism', 'Neither', 'Both are the same'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l8q8',
        text: 'Who am I? I am a "Half-sider" Cardinal.',
        options: [
          'Half Male color, Half Female color',
          'Half bird, half squirrel',
          'Half red, Half Blue',
          'Half Invisible',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l8q9',
        text: 'Can dirt or pollution change a bird\'s color?',
        options: ['Yes, by staining', 'No', 'Impossible', 'Only paint'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l8q10',
        text: 'A "Dilute" plumage bird looks...',
        options: ['Washed out / Faded', 'Bright neon', 'Jet black', 'Shiny'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'col_l9',
    name: 'Beaks & Feet',
    iconData: Icons.pan_tool,
    questions: [
      Question(
        id: 'col_l9q1',
        text: 'Who am I? I am a Booby named after my bright...',
        options: ['Blue feet', 'Red nose', 'Green ears', 'Yellow tail'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l9q2',
        text: 'What happens to a Starling\'s beak in spring?',
        options: [
          'It turns yellow',
          'It falls off',
          'It turns blue',
          'It grows teeth',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l9q3',
        text: 'Why do Toucans have such colorful beaks?',
        options: [
          'To attract mates/Social signal',
          'To hide in candy shops',
          'To paint',
          'To glow at night',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l9q4',
        text:
            'True or False: Puffins shed the colorful part of their beak after summer.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l9q5',
        text: 'A Turkey\'s head changes color when it is...',
        options: ['Excited or Angry', 'Asleep', 'Flying', 'Swimming'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l9q6',
        text: 'Most Eagles and Hawks have what color legs?',
        options: ['Yellow', 'Blue', 'Green', 'Purple'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l9q7',
        text: 'A Male Blackbird has a bright yellow...',
        options: ['Eye ring and Beak', 'Foot', 'Wing', 'Tail'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l9q8',
        text: 'Coots have strange feet that are often...',
        options: ['Green/Blueish', 'Bright Red', 'Pink', 'Orange'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l9q9',
        text: 'Why do baby birds have bright red/yellow mouths?',
        options: [
          'To show parents where to put food',
          'To look scary',
          'To sing louder',
          'To bite',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l9q10',
        text: 'Can a bird\'s leg color fade if it is sick?',
        options: ['Yes', 'No', 'Never', 'Only in winter'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'col_l10',
    name: 'Colorful Stars',
    iconData: Icons.palette_outlined,
    questions: [
      Question(
        id: 'col_l10q1',
        text: 'Which duck is famous for being "The Most Beautiful"?',
        options: ['Mandarin Duck', 'Mallard', 'Goose', 'Swan'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l10q2',
        text: 'Who am I? I am a Roller with a breast colored...',
        options: ['Lilac (Purple)', 'Black', 'Brown', 'Grey'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l10q3',
        text: 'The Resplendent Quetzal is famous for its...',
        options: [
          'Shiny Green feathers',
          'Dull brown feathers',
          'Bald head',
          'Short tail',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l10q4',
        text: 'Rainbow Lorikeets eat...',
        options: ['Nectar and Pollen', 'Fish', 'Mice', 'Steak'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l10q5',
        text: 'Identify the bird: I am bright red with black wings.',
        options: ['Scarlet Tanager', 'Crow', 'Blue Jay', 'Robin'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l10q6',
        text: 'An Indigo Bunting is what color?',
        options: ['Deep Blue', 'Bright Red', 'Yellow', 'Green'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l10q7',
        text: 'European Goldfinches have a bright red...',
        options: ['Face', 'Wing', 'Foot', 'Belly'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l10q8',
        text: 'Who is the "Bluebird of Happiness"?',
        options: ['Mountain Bluebird', 'Crow', 'Raven', 'Turkey'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l10q9',
        text: 'Where do most super-colorful Fruit Doves live?',
        options: ['Rainforests', 'Deserts', 'The Arctic', 'Cities'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'col_l10q10',
        text: 'The Pied Kingfisher is strictly...',
        options: [
          'Black and White',
          'Blue and Orange',
          'Red and Green',
          'Yellow and Purple',
        ],
        correctOptionIndex: 0,
      ),
    ],
  ),
];
