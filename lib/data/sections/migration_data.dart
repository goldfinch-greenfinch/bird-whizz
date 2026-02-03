import 'package:flutter/material.dart';
import '../../models/question.dart';
import '../../models/level.dart';

final List<Level> migrationLevels = [
  Level(
    id: 'mig_l1',
    name: 'Time to Fly',
    iconData: Icons.flight,
    questions: [
      Question(
        id: 'life_l3q1',
        text: 'How do birds generally know it is time to migrate?',
        options: [
          'The days get shorter (Day Length)',
          'Traffic gets bad',
          'TV tells them',
          'They get bored',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'life_l3q2',
        text:
            'True or False: Birds use landmarks like rivers and mountains to find their way.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'life_l3q3',
        text:
            'Before migrating, birds get jittery and restless. This behavior is called...',
        options: ['Zugunruhe', 'Dancing', 'Sleepwalking', 'Playing'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'life_l3q4',
        text:
            'The Bar-tailed Godwit holds the record for flying non-stop across the...',
        options: [
          'Pacific Ocean',
          'Swimming pool',
          'Atlantic Ocean',
          'Indian Ocean',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'life_l3q5',
        text: '"Partial Migration" means...',
        options: [
          'Some birds stay, some go',
          'Birds fly halfway',
          'Birds walk only',
          'Birds swim only',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'life_l3q6',
        text: 'Why do birds fly high up in the sky?',
        options: [
          'For good wind and cool air',
          'To eat clouds',
          'To see footprints',
          'To escape rain',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'life_l3q7',
        text: 'A "Stopover Site" is a place where birds land to...',
        options: ['Rest and eat', 'Build a nest', 'End the trip', 'Play games'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'life_l3q8',
        text:
            'Find the odd one out: Which of these birds migrates by swimming?',
        options: ['Adelie Penguin', 'Robin', 'Hawk', 'Duck'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'life_l3q9',
        text:
            'Young birds often know where to go without being taught. This is called...',
        options: ['Instinct', 'Google Maps', 'Magic', 'Guessing'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'life_l3q10',
        text:
            'Fill in the blank: A major route used by many birds is called a ______.',
        options: ['Flyway', 'Highway', 'Skyway', 'Subway'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'mig_l2',
    name: 'How Birds Fly',
    iconData: Icons.air,
    questions: [
      Question(
        id: 'mig_l2q1',
        text: 'Soaring birds (like Eagles) save energy by riding...',
        options: ['Rising warm air (Thermals)', 'Elevators', 'Clouds', 'Rain'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l2q2',
        text:
            'A bird\'s wing is curved to create lift. This shape is called an...',
        options: ['Airfoil', 'Square', 'Circle', 'Triangle'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l2q3',
        text: 'Albatrosses use the wind over ocean waves to glide. This is...',
        options: ['Dynamic Soaring', 'Surfing', 'Falling', 'Swimming'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l2q4',
        text: 'Why do Geese fly in a V-shape?',
        options: [
          'To save energy (Aerodynamics)',
          'To look cool',
          'To see better',
          'To spell words',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l2q5',
        text:
            'True or False: Birds have massive chest muscles to power their wings.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l2q6',
        text: 'Some birds fly for days by sleeping with...',
        options: ['Half their brain', 'Eyes open', 'No brain', 'A pillow'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l2q7',
        text: 'Hummingbirds are "powered flyers" because they...',
        options: [
          'Flap constantly',
          'Glide mostly',
          'Use batteries',
          'Float on wind',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l2q8',
        text: '"Wing Loading" compares a bird\'s weight to its...',
        options: ['Wing area', 'Beak size', 'Foot size', 'Head size'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l2q9',
        text: 'Who am I? I am a seabird with the longest wingspan for gliding.',
        options: ['Wandering Albatross', 'Penguin', 'Robin', 'Sparrow'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l2q10',
        text: 'Woodpeckers save energy by flying in a bouncy way called...',
        options: ['Bounding flight', 'Smooth flight', 'Hovering', 'Soaring'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'mig_l3',
    name: 'Finding the Way',
    iconData: Icons.explore,
    questions: [
      Question(
        id: 'mig_l3q1',
        text: 'Birds have a built-in compass that can sense...',
        options: [
          'Magnetic fields',
          'Wind direction',
          'Temperature',
          'Humidity',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l3q2',
        text: 'During the day, birds navigate using the...',
        options: ['Sun', 'Moon', 'Clouds', 'Cars'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l3q3',
        text: 'At night, many birds find North by looking at...',
        options: ['The Stars', 'Streetlights', 'The Moon', 'Fireflies'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l3q4',
        text:
            'True or False: Some seabirds (like Petrels) use their sense of smell to find home.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l3q5',
        text: 'If you move a baby bird far away, it might...',
        options: [
          'Get lost (It has compass but no map)',
          'Find its way easily',
          'Teleport',
          'Ask for directions',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l3q6',
        text: 'Birds use both a "Compass" (Direction) and a...',
        options: ['"Map" (Location)', 'Phone', 'Watch', 'Radio'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l3q7',
        text: 'Big landmarks like coastlines and mountains help birds...',
        options: ['Know where they are', 'Find food', 'Hide', 'Sleep'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l3q8',
        text: 'Birds can hear deep sounds from storms/waves called...',
        options: ['Infrasound', 'Ultrasound', 'Megasound', 'Supersound'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l3q9',
        text:
            'Fill in the blank: The direction a bird wants to fly is often written in its ______.',
        options: ['Genes/DNA', 'Feathers', 'Beak', 'Feet'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l3q10',
        text: 'Birds calibrate their compass at sunset using...',
        options: ['Polarized light', 'The Moon', 'The stars', 'The wind'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'mig_l4',
    name: 'Getting Ready',
    iconData: Icons.fitness_center,
    questions: [
      Question(
        id: 'mig_l4q1',
        text: 'What is the best fuel for a long migration flight?',
        options: ['Fat', 'Sugar', 'Water', 'Leaves'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l4q2',
        text: 'Before migrating, some birds eat so much they...',
        options: ['Double their weight', 'Explode', 'Can\'t fly', 'Turn green'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l4q3',
        text: '"Hyperphagia" is a fancy word for...',
        options: [
          'Over-eating',
          'Flying fast',
          'Sleeping a lot',
          'Singing loud',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l4q4',
        text:
            'True or False: A bird\'s internal organs can shrink to save weight for flight.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l4q5',
        text: 'Why do birds molt (replace feathers) before migrating?',
        options: [
          'To have strong, fresh wings',
          'To look pretty',
          'To be warmer',
          'To be softer',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l4q6',
        text: 'How do hormones tell a bird to migrate?',
        options: [
          'By making them feel restless',
          'By making them sleep',
          'By making them sing',
          'By making them hide',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l4q7',
        text:
            'Insect-eating birds often switch to eating ______ in fall to gain fat.',
        options: ['Berries/Fruit', 'Grass', 'Rocks', 'Dirt'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l4q8',
        text: 'Burning fat creates energy and...',
        options: ['Water', 'Smoke', 'Fire', 'Dust'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l4q9',
        text: 'Does migrating take a lot of energy?',
        options: [
          'Yes, it is exhausting',
          'No, it is easy',
          'Only for fat birds',
          'Only for small birds',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l4q10',
        text:
            'Fill in the blank: Hormones triggered by ______ tell birds to allow fat to build up.',
        options: ['Day length', 'Temperature', 'Rain', 'Wind'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'mig_l5',
    name: 'Dangerous Journey',
    iconData: Icons.warning,
    questions: [
      Question(
        id: 'mig_l5q1',
        text: 'Why are bright city lights dangerous for migrating birds?',
        options: [
          'They confuse/attract birds causing collisions',
          'They burn birds',
          'They are too hot',
          'They are ugly',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l5q2',
        text: 'A "Fallout" happens when bad weather forces...',
        options: [
          'Many birds to land at once',
          'Birds to fly higher',
          'Birds to swim',
          'Birds to turn back',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l5q3',
        text: 'Eleonora\'s Falcon hunts migrating birds to feed its...',
        options: ['Babies', 'Friends', 'Neighbors', 'Pets'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l5q4',
        text: 'Outdoor cats are a huge threat when tired birds...',
        options: ['Land to rest', 'Fly high', 'Swim', 'Sleep in clouds'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l5q5',
        text: 'Why is crossing a desert dangerous?',
        options: [
          'No food or water',
          'Too much sand',
          'Too many trees',
          'Traffic jams',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l5q6',
        text: 'Lights on oil rigs at sea can cause birds to...',
        options: [
          'Circle until they are exhausted',
          'Land and party',
          'Fish',
          'Sleep',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l5q7',
        text: 'True or False: Birds are safe from predators while migrating.',
        options: ['False', 'True'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l5q8',
        text: 'If a forest stopover is cut down, birds...',
        options: [
          'Cannot refuel',
          'Fly faster',
          'Are happy',
          'Sleep there anyway',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l5q9',
        text: 'Wind turbines should be placed away from...',
        options: ['Major flyways', 'Cities', 'Farms', 'Roads'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l5q10',
        text:
            'Fill in the blank: ______ is the biggest threat to migrating birds.',
        options: ['Habitat Loss', 'Rain', 'Wind', 'Noise'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'mig_l6',
    name: 'Record Breakers',
    iconData: Icons.emoji_events,
    questions: [
      Question(
        id: 'mig_l6q1',
        text:
            'Who holds the record for the longest non-stop flight (11,000km)?',
        options: ['Bar-tailed Godwit', 'Eagle', 'Sparrow', 'Robin'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l6q2',
        text: 'Rüppell\'s Vulture holds the record for flying...',
        options: ['Highest (37,000 ft)', 'Lowest', 'Fastest', 'Slowest'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l6q3',
        text: 'Which bird has the longest migration overall (Pole to Pole)?',
        options: ['Arctic Tern', 'Penguin', 'Goose', 'Duck'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l6q4',
        text: 'Bar-headed Geese migrate over the highest mountains, the...',
        options: ['Himalayas', 'Rockies', 'Alps', 'Andes'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l6q5',
        text: 'The Common Swift stays in the air without landing for...',
        options: ['10 months', '10 minutes', '10 hours', '10 days'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l6q6',
        text: 'Find the odd one out: Which of these birds migrates very far?',
        options: ['Cardinal (Resident)', 'Arctic Tern', 'Red Knot', 'Godwit'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l6q7',
        text: 'The Rufous Hummingbird is tiny but flies from...',
        options: [
          'Alaska to Mexico',
          'Tree to Tree',
          'Park to Park',
          'Home to School',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l6q8',
        text: 'Who am I? I am an Albatross named Wisdom, the oldest wild bird.',
        options: ['Laysan Albatross', 'Eagle', 'Hawk', 'Owl'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l6q9',
        text: 'Some Penguins swim thousands of miles. This is a...',
        options: ['Migration', 'Vacation', 'Mistake', 'Race'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l6q10',
        text: 'Monarch Butterflies migrate like birds to...',
        options: ['Mexico', 'Canada', 'Alaska', 'Europe'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'mig_l7',
    name: 'Migration Patterns',
    iconData: Icons.shuffle,
    questions: [
      Question(
        id: 'mig_l7q1',
        text: 'What is "Altitudinal Migration"?',
        options: [
          'Moving up/down a mountain',
          'Moving East/West',
          'Moving North/South',
          'Walking backwards',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l7q2',
        text: 'Latitudinal Migration is the most common. It means moving...',
        options: [
          'North and South',
          'East and West',
          'Up and Down',
          'Fast and Slow',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l7q3',
        text: 'An "Irruption" is when birds migrate because...',
        options: [
          'Their food source failed',
          'They want to',
          'It is sunny',
          'They are lost',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l7q4',
        text: 'Loop Migration means birds take...',
        options: [
          'A different path home',
          'The same path home',
          'A bus',
          'A train',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l7q5',
        text: 'Birds that do NOT migrate are called...',
        options: ['Residents', 'Tourists', 'Lazy', 'Sleeping'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l7q6',
        text:
            'True or False: In "Partial Migration", only some birds of a species migrate.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l7q7',
        text: 'What is a "Vagrant" bird?',
        options: [
          'One that got lost/blew off course',
          'A resident',
          'A baby',
          'A pet',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l7q8',
        text: 'Nomadic birds like Crossbills move around to find...',
        options: ['Pine cones/Seeds', 'Cities', 'Beaches', 'Toys'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l7q9',
        text: 'Emus are nomadic and follow the...',
        options: ['Rain', 'Sun', 'Moon', 'Wind'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l7q10',
        text: 'Why do Snowy Owls sometimes appear far South?',
        options: [
          'Lack of lemmings (food)',
          'It is too cold',
          'They like the beach',
          'To see people',
        ],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'mig_l8',
    name: 'Bird Tracking',
    iconData: Icons.gps_fixed,
    questions: [
      Question(
        id: 'mig_l8q1',
        text: 'How do scientists track birds with "Banding"?',
        options: [
          'Putting a metal ring on the leg',
          'Painting them',
          'Talking to them',
          'Following them',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l8q2',
        text: 'A "Geolocator" tracks a bird by recording...',
        options: [
          'Light levels (Sunrise/Sunset)',
          'Sounds',
          'Steps',
          'Heartbeat',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l8q3',
        text: 'What tool can show flocks of birds on a map like rain?',
        options: ['Weather Radar', 'TV', 'Microscope', 'Telescope'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l8q4',
        text: 'Motus towers pick up signals from tiny...',
        options: ['Radio tags', 'Phones', 'Cameras', 'Lights'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l8q5',
        text:
            'True or False: Satellite tags are used for larger birds like Eagles.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l8q6',
        text: 'Before technology, how did people study migration?',
        options: [
          'Watching the Moon',
          'Asking the birds',
          'Guessing',
          'Dreaming',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l8q7',
        text: 'Scientists use soft "Mist Nets" to...',
        options: [
          'Catch birds safely for banding',
          'Catch fish',
          'Catch bugs',
          'Catch leaves',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l8q8',
        text: 'eBird is a way for regular people to...',
        options: [
          'Share bird sightings',
          'Buy birds',
          'Sell birds',
          'Cook birds',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l8q9',
        text: 'Chemicals in feathers (Isotopes) can tell us...',
        options: [
          'Where a bird grew a feather',
          'What color it is',
          'How old it is',
          'Its name',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l8q10',
        text: 'Why do we track birds?',
        options: [
          'To protect them and their habitats',
          'To hunt them',
          'To annoy them',
          'For fun only',
        ],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'mig_l9',
    name: 'Rest Stops',
    iconData: Icons.hotel,
    questions: [
      Question(
        id: 'mig_l9q1',
        text: 'A good "Stopover" is like a bird...',
        options: ['Gas Station/Restaurant', 'School', 'Office', 'Hospital'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l9q2',
        text: 'Why are stopovers critical?',
        options: [
          'Birds run out of fat/fuel',
          'Birds get bored',
          'Birds want to play',
          'Birds forget the way',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l9q3',
        text: 'True or False: Birds spend more time at stopovers than flying.',
        options: ['True', 'False'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l9q4',
        text: 'The Yellow Sea is a famous stopover for...',
        options: ['Shorebirds', 'Penguins', 'Owls', 'Parrots'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l9q5',
        text: 'Red Knots stop in Delaware Bay to eat...',
        options: ['Horseshoe Crab eggs', 'Pizza', 'Fish', 'Seaweed'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l9q6',
        text: 'If a stopover is destroyed, birds might...',
        options: [
          'Die or fail migration',
          'Find a better one easily',
          'Not care',
          'Fly faster',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l9q7',
        text: 'A "Staging Area" is a place where birds gather...',
        options: [
          'Before migration to fuel up',
          'After migration',
          'To sleep',
          'To play',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l9q8',
        text: 'Some birds use a "Fly-and-stop" strategy, while others...',
        options: ['Make huge jumps', 'Walk', 'Swim', 'Crawl'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l9q9',
        text:
            'Fill in the blank: Your ______ can be a mini stopover for migrating birds.',
        options: ['Backyard', 'Kitchen', 'Car', 'Pocket'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l9q10',
        text: 'Safe stopovers need plenty of...',
        options: ['Food and Cover', 'Noise', 'Lights', 'People'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  Level(
    id: 'mig_l10',
    name: 'Climate Change',
    iconData: Icons.thermostat,
    questions: [
      Question(
        id: 'mig_l10q1',
        text: 'If spring comes too earlier, birds might arrive...',
        options: [
          'Too late for the peak insect hatch',
          'On time',
          'Early',
          'Yesterday',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l10q2',
        text: 'This timing mismatch is called...',
        options: [
          'Phenological Mismatch',
          'Bad luck',
          'Time travel',
          'Confusion',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l10q3',
        text: 'If chicks don\'t have enough bugs to eat, they...',
        options: ['Might starve', 'Eat plants', 'Eat rocks', 'Sleep'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l10q4',
        text: 'Many birds are shifting their range...',
        options: ['North (to cooler areas)', 'South', 'East', 'West'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l10q5',
        text: '"Short-stopping" is when birds (like Geese)...',
        options: [
          'Don\'t migrate as far South',
          'Fly too far',
          'Stop flying',
          'Crash',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l10q6',
        text: 'Droughts caused by climate change dry up...',
        options: ['Critical wetlands/Stopovers', 'Oceans', 'Cities', 'Roads'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l10q7',
        text: 'Changing wind patterns can make migration...',
        options: ['More energy expensive (Harder)', 'Easier', 'Faster', 'Fun'],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l10q8',
        text: 'Can birds evolve fast enough to keep up with climate change?',
        options: [
          'It is very difficult',
          'Yes easily',
          'No never',
          'They don\'t try',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l10q9',
        text: 'High Arctic birds are losing their home as...',
        options: [
          'Trees grow further North',
          'Ice melts',
          'Cities grow',
          'It gets colder',
        ],
        correctOptionIndex: 0,
      ),
      Question(
        id: 'mig_l10q10',
        text: 'Climate change causes more extreme weather, which causes...',
        options: [
          'Mortality (Death) during migration',
          'Happy birds',
          'Faster flights',
          'More food',
        ],
        correctOptionIndex: 0,
      ),
    ],
  ),
];
