import 'package:flutter/material.dart';
import '../../models/question.dart';
import '../../models/level.dart';

final List<Level> conservationLevels = [
  Level(
    id: 'con_l1',
    name: 'Dangers',
    iconData: Icons.warning_amber_rounded,
    questions: [
      Question(
        id: 'con_l1q1',
        text: 'What is the biggest problem facing wild birds today?',
        options: [
          'Losing their homes (Habitat Loss)',
          'Eating too much',
          'Rainy days',
          'Boredom',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l1q2',
        text:
            'True or False: Outdoor cats catch and eat millions of birds every year.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l1q3',
        text: 'Why is plastic trash in the ocean bad for birds?',
        options: [
          'They mistake it for food',
          'They build bad nests',
          'They play with it',
          'It scares them',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l1q4',
        text:
            'Fill in the blank: ______ is when birds travel long distances to find food or warmer weather.',
        options: ['Migration', 'Hibernation', 'Vacation', 'Exploration'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l1q5',
        text: 'Why do birds often fly into windows?',
        options: [
          'They see reflections of trees',
          'They want to come inside',
          'They are chasing bugs',
          'They like the glass',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l1q6',
        text: 'What does it mean if a bird is "Endangered"?',
        options: [
          'It might disappear forever',
          'It is very common',
          'It lives in a zoo',
          'It attacks people',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l1q7',
        text:
            'Who am I? I am a famous flightless bird that went extinct long ago.',
        options: ['Dodo', 'Chicken', 'Ostrich', 'Penguin'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l1q8',
        text: 'We can help birds in our yards by planting...',
        options: [
          'Native trees and flowers',
          'Plastic plants',
          'Rocks',
          'Signs',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l1q9',
        text:
            'True or False: A warming planet makes it harder for birds to know when to migrate.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l1q10',
        text: 'Chemicals sprayed on farms (Pesticides) can hurt birds by...',
        options: [
          'Poisoning their food',
          'Making them grow too big',
          'Turning them green',
          'Helping them fly',
        ],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'con_l2',
    name: 'Helping Hands',
    iconData: Icons.eco,
    questions: [
      Question(
        id: 'con_l2q1',
        text: 'Bald Eagles were saved not by fighting, but by banning...',
        options: ['A dangerous chemical (DDT)', 'Bread', 'Cars', 'Kites'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l2q2',
        text: 'What is a "Bird Sanctuary"?',
        options: [
          'A safe place protected for birds',
          'A cage',
          'A pet store',
          'A dangerous forest',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l2q3',
        text:
            'True or False: Bird feeders are especially helpful during cold winters.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l2q4',
        text:
            'Find the odd one out: Which animal is the logo for the World Wildlife Fund (WWF)?',
        options: ['Panda', 'Eagle', 'Robin', 'Owl'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l2q5',
        text:
            'Who am I? I am a rare, heavy parrot from New Zealand that people are working hard to save.',
        options: ['Kakapo', 'Macaw', 'Budgie', 'Cockatoo'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l2q6',
        text:
            'Fill in the blank: "Citizen ______" means regular people help scientists count birds.',
        options: ['Science', 'Math', 'Art', 'Sports'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l2q7',
        text: 'Why is saving wetlands important?',
        options: [
          'They provide homes and food',
          'They are good for parking',
          'They look nice',
          'To swim in',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l2q8',
        text: 'The California Condor was saved from extinction by...',
        options: [
          'Captive breeding and release',
          'Magic',
          'Aliens',
          'Becoming a pet',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l2q9',
        text: 'A "Native" plant is one that...',
        options: [
          'Naturally grows in your area',
          'Comes from space',
          'Is made of plastic',
          'Is dead',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l2q10',
        text: 'Can kids help save birds?',
        options: [
          'Yes, definitely!',
          'No, never',
          'Only grown-ups',
          'Only teachers',
        ],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'con_l3',
    name: 'Lost Homes',
    iconData: Icons.warning,
    questions: [
      Question(
        id: 'con_l3q1',
        text: 'Many rainforest birds are losing their homes because of...',
        options: [
          'Logging/Cutting trees',
          'Too much rain',
          'Loud noises',
          'Monkeys',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l3q2',
        text: 'Fill in the blank: Wetlands are often drained to build ______.',
        options: ['Houses and Farms', 'Oceans', 'Rivers', 'Mountains'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l3q3',
        text: 'Why do grassland birds have nowhere to nest?',
        options: [
          'Grasslands are turned into farms',
          'Grass is too tall',
          'They prefer trees',
          'They live in caves',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l3q4',
        text: 'When a large forest is broken into tiny pieces, it is called...',
        options: ['Fragmentation', 'Explosion', 'Decorating', 'Gardening'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l3q5',
        text:
            'True or False: Birds on islands are safe because predators can\'t swim.',
        options: ['False', 'True'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l3q6',
        text: 'An "Indicator Species" tells us if...',
        options: [
          'The environment is healthy',
          'It is going to rain',
          'It is lunchtime',
          'Winter is coming',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l3q7',
        text: 'Which type of bird home is disappearing the fastest?',
        options: ['Grasslands', 'Deserts', 'Mountaintops', 'Clouds'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l3q8',
        text: 'How do oil spills hurt birds?',
        options: [
          'Oil destroys waterproof feathers',
          'It makes them slip',
          'It smells good',
          'It dyes them black',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l3q9',
        text: 'Too many bright city lights at night can...',
        options: [
          'Confuse migrating birds',
          'Help birds see',
          'Keep birds warm',
          'Make birds happy',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l3q10',
        text: 'Why do birds need quiet beaches?',
        options: [
          'To rest during long trips',
          'To build sandcastles',
          'To swim',
          'To play volleyball',
        ],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'con_l4',
    name: 'Unwanted Guests',
    iconData: Icons.bug_report,
    questions: [
      Question(
        id: 'con_l4q1',
        text: 'What is an "Invasive Species"?',
        options: [
          'An animal that causes harm in a new place',
          'A polite visitor',
          'A native bird',
          'A friendly pet',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l4q2',
        text: 'Rats are dangerous to birds because they eat...',
        options: ['Eggs and chicks', 'Rocks', 'Dirt', 'Trees'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l4q3',
        text:
            'Who am I? I am a popular pet, but if let outside, I am a major predator of birds.',
        options: ['Cat', 'Dog', 'Hamster', 'Goldfish'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l4q4',
        text:
            'True or False: The European Starling is an invasive pest in North America.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l4q5',
        text: 'Invasive snakes on the island of Guam ate almost all the...',
        options: ['Birds', 'Rocks', 'Dirt', 'Cars'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l4q6',
        text: 'Why did the Dodo go extinct?',
        options: [
          'Humans and invasive animals ate them',
          'They flew away',
          'It got too hot',
          'They got lost',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l4q7',
        text: 'A "Feral" animal is one that used to be a pet but has...',
        options: [
          'Gone wild',
          'Learned tricks',
          'Found a home',
          'Gone to sleep',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l4q8',
        text: 'Fill in the blank: Invasive plants are often called ______.',
        options: ['Weeds', 'Flowers', 'Vegetables', 'Trees'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l4q9',
        text: 'How do we fix the problem of invasive species?',
        options: [
          'By removing them',
          'By feeding them',
          'By petting them',
          'By ignoring them',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l4q10',
        text: 'Why are island birds so vulnerable?',
        options: [
          'They aren\'t used to predators',
          'They can\'t fly well',
          'They are small',
          'They are friendly',
        ],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'con_l5',
    name: 'Warming World',
    iconData: Icons.thermostat,
    questions: [
      Question(
        id: 'con_l5q1',
        text: 'How does warmer weather affect migration?',
        options: [
          'Birds might arrive too early/late',
          'Birds fly faster',
          'Birds stay home',
          'Birds swim instead',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l5q2',
        text:
            'Fill in the blank: If birds arrive too early, they might miss the peak of ______ availability.',
        options: ['Insect/Bug', 'Sun', 'Wind', 'Rain'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l5q3',
        text: 'Why are mountain birds moving higher up?',
        options: [
          'To find cooler air',
          'To see better',
          'To touch clouds',
          'To find snow',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l5q4',
        text: 'Rising sea levels are dangerous for birds that nest...',
        options: ['On the coast/beach', 'In trees', 'In caves', 'On mountains'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l5q5',
        text:
            'True or False: As the world warms, many birds are moving their range North.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l5q6',
        text: 'Ocean changes make it harder for seabirds to find...',
        options: ['Fish', 'Water', 'Friends', 'Boats'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l5q7',
        text: 'Stronger storms can hurt birds by...',
        options: [
          'Destroying nests/trees',
          'Getting them wet',
          'Waking them up',
          'Scaring them',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l5q8',
        text: 'What happens if the climate changes too fast?',
        options: [
          'Birds can\'t adapt',
          'Birds fly faster',
          'Birds evolve instantly',
          'Nothing',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l5q9',
        text: 'Who am I? I am an Arctic bird losing my icy home.',
        options: [
          'Polar Bear (Wait, I mean Ivory Gull)',
          'Parrot',
          'Robin',
          'Flamingo',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l5q10',
        text: 'We can help stop warming by using less...',
        options: ['Energy/Fossil Fuels', 'Water', 'Air', 'Dirt'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'con_l6',
    name: 'Bird Heroes',
    iconData: Icons.person_add,
    questions: [
      Question(
        id: 'con_l6q1',
        text: 'Who wrote "Silent Spring" to warn about dangerous chemicals?',
        options: [
          'Rachel Carson',
          'Abraham Lincoln',
          'Taylor Swift',
          'Santa Claus',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l6q2',
        text: 'What was the book "Silent Spring" about?',
        options: [
          'The danger of pesticides (DDT)',
          'A quiet season',
          'Birds sleeping',
          'No insects',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l6q3',
        text: 'John James Audubon was famous for...',
        options: ['Painting beautiful birds', 'Singing', 'Running', 'Cooking'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l6q4',
        text: 'The RSPB is a huge charity in the UK. What does it do?',
        options: [
          'Protects birds',
          'Feeds birds',
          'Sells birds',
          'Cooks birds',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l6q5',
        text: 'Buying a "Duck Stamp" helps pay for...',
        options: ['Protecting wetlands', 'Mail', 'Ducks', 'Stamps'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l6q6',
        text:
            'True or False: Sir David Attenborough narrates nature documentaries.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l6q7',
        text:
            'Who am I? I am the animal on the World Wildlife Fund (WWF) logo.',
        options: ['Panda', 'Bird', 'Fish', 'Cat'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l6q8',
        text: 'BirdLife International is a global team that...',
        options: [
          'Protects birds everywhere',
          'Eats birds',
          'Sells birds',
          'Paints birds',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l6q9',
        text: 'President Teddy Roosevelt created the first....',
        options: ['National Wildlife Refuge', 'Theme Park', 'Zoo', 'Pet Store'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l6q10',
        text: 'Can YOU be a bird hero?',
        options: ['Yes, by caring!', 'No', 'Maybe', 'Only if you can fly'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'con_l7',
    name: 'You Can Help',
    iconData: Icons.home,
    questions: [
      Question(
        id: 'con_l7q1',
        text: 'How can you stop birds from hitting your windows?',
        options: [
          'Put stickers/decals on the glass',
          'Open them',
          'Clean them',
          'Break them',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l7q2',
        text: 'What is a great food to put in a bird feeder?',
        options: ['Sunflower seeds', 'Bread', 'Pizza', 'Candy'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l7q3',
        text: 'True or False: Feeding ducks bread is actually bad for them.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l7q4',
        text: 'Why should you wait until fall to trim bushes?',
        options: [
          'To avoid disturbing nests',
          'It is too hot',
          'The leaves are green',
          'The bushes will cry',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l7q5',
        text: 'Keeping cats indoors helps save...',
        options: ['Millions of birds', 'Furniture', 'Carpets', 'Toys'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l7q6',
        text: 'Why plant "Native" plants?',
        options: [
          'They have the bugs birds eat',
          'They are ugly',
          'They are plastic',
          'They grow fast',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l7q7',
        text: 'Only pick up a baby bird if...',
        options: [
          'It has no feathers/Is hurt',
          'It is cute',
          'It is singing',
          'You want a pet',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l7q8',
        text: 'Picking up trash prevents it from...',
        options: ['Hurting wildlife', 'Looking bad', 'Smelling', 'Floating'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l7q9',
        text:
            'Fill in the blank: You must ______ bird feeders regularly to prevent disease.',
        options: ['Clean', 'Paint', 'Hide', 'Break'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l7q10',
        text: 'Why are dead trees (Snags) good?',
        options: [
          'They are homes for Owls/Woodpeckers',
          'They are ugly',
          'They are firewood',
          'They fall down',
        ],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'con_l8',
    name: 'Rare & Special',
    iconData: Icons.error_outline,
    questions: [
      Question(
        id: 'con_l8q1',
        text: 'Who am I? I am a flightless Parrot from New Zealand.',
        options: ['Kakapo', 'Macaw', 'Kea', 'Budgie'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l8q2',
        text: 'The California Condor is highly endangered because of...',
        options: [
          'Lead poisoning',
          'Cold weather',
          'Too much food',
          'Being small',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l8q3',
        text: 'The Spoon-billed Sandpiper is named after its...',
        options: [
          'Spoon-shaped beak',
          'Spoon-shaped feet',
          'Love of spoons',
          'Eating habits',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l8q4',
        text: 'True or False: The Ivory-billed Woodpecker might be extinct.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l8q5',
        text: 'Albatrosses are rare because they...',
        options: [
          'Live only in the ocean',
          'Are invisible',
          'Don\'t exist',
          'Are aliens',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l8q6',
        text: 'Vultures are important because they...',
        options: [
          'Clean up dead animals',
          'Are pretty',
          'Sing well',
          'Scare kids',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l8q7',
        text: 'Who am I? I am a bright blue Macaw that is extinct in the wild.',
        options: ['Spix\'s Macaw', 'Blue Jay', 'Parakeet', 'Robin'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l8q8',
        text: 'Yellow-eyed Penguins are found only in...',
        options: ['New Zealand', 'New York', 'North Pole', 'Florida'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l8q9',
        text:
            'Fill in the blank: An animal found in only one place is called ______.',
        options: ['Endemic', 'Pandemic', 'Epidemic', 'Systemic'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l8q10',
        text: 'What does "Extinct" mean?',
        options: ['Gone forever', 'Hiking', 'Sleeping', 'Hiding'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'con_l9',
    name: 'Bird Laws',
    iconData: Icons.gavel,
    questions: [
      Question(
        id: 'con_l9q1',
        text: 'True or False: It is illegal to hurt most wild birds.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l9q2',
        text: 'Is it okay to keep a feather you find from a Bald Eagle?',
        options: [
          'No, it is illegal',
          'Yes, it\'s find',
          'Yes, for a hat',
          'Yes, for a toy',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l9q3',
        text: 'We have laws to stop people from...',
        options: [
          'Selling rare birds',
          'Feeding birds',
          'Drawing birds',
          'Watching birds',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l9q4',
        text: 'You should never touch a bird\'s...',
        options: ['Nest and eggs', 'Feeder', 'Bath', 'Tree'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l9q5',
        text: 'The Endangered Species Act is a law that...',
        options: [
          'Protects animals at risk',
          'Protects cars',
          'Protects toys',
          'Protects rocks',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l9q6',
        text: 'Why is the pet trade bad for parrots?',
        options: [
          'They are taken from the wild',
          'They eat too much',
          'They are loud',
          'They bite',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l9q7',
        text: 'Hawks are protected, so it is illegal to...',
        options: ['Shoot them', 'Look at them', 'Photograph them', 'Name them'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l9q8',
        text: 'If you break bird laws, you might have to...',
        options: ['Pay a fine', 'Get a prize', 'Get a sticker', 'Eat broccoli'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l9q9',
        text:
            'Fill in the blank: Laws have helped many bird populations ______.',
        options: ['Recover', 'Disappear', 'Hide', 'Explode'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l9q10',
        text:
            'Find the odd one out: Which bird is usually NOT protected by law?',
        options: ['City Pigeon', 'Robin', 'Hawk', 'Eagle'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'con_l10',
    name: 'Happy Endings',
    iconData: Icons.star,
    questions: [
      Question(
        id: 'con_l10q1',
        text: 'The Bald Eagle is a success story because...',
        options: [
          'It is no longer endangered',
          'It is extinct',
          'It left',
          'It turned blue',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l10q2',
        text: 'Scientists wore bird costumes to teach Whooping Cranes to...',
        options: ['Migrate', 'Dance', 'Sing', 'Swim'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l10q3',
        text: 'Ospreys returned after we cleaned up...',
        options: ['Pollution', 'Forests', 'Deserts', 'Cities'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l10q4',
        text: 'Canada Geese are now very common in...',
        options: ['Parks and cities', 'Caves', 'Volcanoes', 'Space'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l10q5',
        text: 'True or False: Conservation works when people help.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l10q6',
        text: 'Bluebirds were helped by people building...',
        options: ['Nest boxes', 'Bird baths', 'Tiny cars', 'Bird shoes'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l10q7',
        text: 'What does "Rewilding" mean?',
        options: [
          'Returning nature to the wild',
          'Camping',
          'Yelling',
          'Running fast',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l10q8',
        text: 'Who makes the biggest difference for birds?',
        options: ['Everyone working together', 'No one', 'Aliens', 'Robots'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l10q9',
        text: 'The future of birds is...',
        options: ['In our hands', 'Hopeless', 'Scary', 'Boring'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'con_l10q10',
        text: 'Birds bring us joy with their...',
        options: ['Songs and flight', 'Quietness', 'Sleeping', 'Hiding'],
        correctOptionIndex: 0,
      ),
    ],
  ),
];
