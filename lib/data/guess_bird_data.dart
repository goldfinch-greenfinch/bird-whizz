const _kBirdPrefixes = {
  // gender / age
  'female', 'male', 'juvenile', 'adult',
  // geographic / taxonomic qualifiers
  'eurasian', 'european', 'common', 'northern', 'american', 'indian',
};

/// Strips leading qualifier words (e.g. "Female", "Eurasian") from a bird
/// name, keeping at least one word so the result is never empty.
String stripBirdPrefixes(String name) {
  final words = name.trim().split(RegExp(r'\s+'));
  int i = 0;
  while (i < words.length - 1 &&
      _kBirdPrefixes.contains(words[i].toLowerCase())) {
    i++;
  }
  return words.sublist(i).join(' ');
}

class GuessBirdQuestion {
  final String birdName;
  final String description;
  final String imagePath;
  final List<String> aliases;

  const GuessBirdQuestion({
    required this.birdName,
    required this.description,
    required this.imagePath,
    this.aliases = const [],
  });
}

class GuessBirdLevel {
  final String title;
  final String subtitle;
  final String emoji;
  final List<GuessBirdQuestion> questions;

  const GuessBirdLevel({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.questions,
  });
}

const List<GuessBirdLevel> guessBirdLevels = [
  // ─── Level 1: British Garden & Woodland Birds ───────────────────────────────
  GuessBirdLevel(
    title: 'Garden & Woodland',
    subtitle: 'Birds commonly seen in British gardens and woodlands',
    emoji: '🌳',
    questions: [
      GuessBirdQuestion(
        birdName: 'Robin',
        description:
            'A small, round garden bird with a bright orange-red breast. Males and females look alike. It often follows gardeners digging up worms and has a sweet, melodic song.',
        imagePath: 'assets/bird_photos/european_robin.webp',
        aliases: ['robin', 'english robin', 'robin redbreast'],
      ),
      GuessBirdQuestion(
        birdName: 'Blue Tit',
        description:
            'A tiny, acrobatic bird with a vibrant blue cap, yellow belly and greenish wings. A common and clever garden visitor, once famous for opening foil milk bottle tops to drink the cream.',
        imagePath: 'assets/bird_photos/eurasian_blue_tit.webp',
        aliases: ['blue tit', 'bluetit'],
      ),
      GuessBirdQuestion(
        birdName: 'Great Tit',
        description:
            'The largest of the British tits. It has a bold black head, white cheeks and a bright yellow chest divided by a broad black stripe down the middle. Its loud "teacher-teacher" call is unmistakeable.',
        imagePath: 'assets/bird_photos/great_tit.webp',
        aliases: [],
      ),
      GuessBirdQuestion(
        birdName: 'Coal Tit',
        description:
            'One of the smaller tits, with a glossy black head, white cheeks and a distinctive narrow white patch on the back of the neck. Loves conifer and pine woodland and is a regular garden visitor.',
        imagePath: 'assets/bird_photos/coal_tit.webp',
        aliases: ['coal-tit'],
      ),
      GuessBirdQuestion(
        birdName: 'Long Tailed Tit',
        description:
            'A tiny, round-bodied bird with an astonishingly long tail — longer than its body. Pink, white and black plumage. Usually seen in noisy, chattering flocks moving through hedgerows.',
        imagePath: 'assets/bird_photos/long_tailed_tits.webp',
        aliases: ['long-tailed tit', 'longtailed tit'],
      ),
      GuessBirdQuestion(
        birdName: 'Great Spotted Woodpecker',
        description:
            'A striking black-and-white woodpecker that drums loudly on tree trunks. The male has a bright red patch on the nape; the female\'s head is entirely black. A bold visitor to garden bird feeders.',
        imagePath: 'assets/bird_photos/great_spotted_woodpecker.webp',
        aliases: ['spotted woodpecker'],
      ),
      GuessBirdQuestion(
        birdName: 'Nuthatch',
        description:
            'Blue-grey above and rusty-orange below, with a bold black eye stripe. The only British bird that routinely walks headfirst down vertical tree trunks. Wedges nuts into bark to crack them open.',
        imagePath: 'assets/bird_photos/eurasian_nuthatch.webp',
        aliases: ['nuthatch'],
      ),
      GuessBirdQuestion(
        birdName: 'Chaffinch',
        description:
            'A small finch with warm brownish-olive tones and two distinct white wing bars. The subtly coloured female counterpart of the bright pink-and-blue male. One of Britain\'s most abundant birds.',
        imagePath: 'assets/bird_photos/female_common_chaffinch.webp',
        aliases: ['chaffinch', 'common chaffinch', 'female chaffinch'],
      ),
      GuessBirdQuestion(
        birdName: 'Reed Bunting',
        description:
            'A small, streaky brown bird found in reedbeds, marshes and rough farmland. Heavily streaked above with pale buff underparts and a faint moustache stripe. Often flicks its tail nervously.',
        imagePath: 'assets/bird_photos/female_reed_bunting.webp',
        aliases: ['reed bunting'],
      ),
      GuessBirdQuestion(
        birdName: 'Carrion Crow',
        description:
            'A large, all-black bird with glossy plumage and a heavy black bill. Highly intelligent and adaptable, it is one of Britain\'s most widespread birds. Often seen in pairs and has a harsh, cawing call.',
        imagePath: 'assets/bird_photos/carrion_crow.webp',
        aliases: ['crow', 'black crow'],
      ),
    ],
  ),

  // ─── Level 2: Ducks, Geese & Swans ─────────────────────────────────────────
  GuessBirdLevel(
    title: 'Ducks, Geese & Swans',
    subtitle: 'Waterfowl of lakes, rivers and wetlands',
    emoji: '🦆',
    questions: [
      GuessBirdQuestion(
        birdName: 'Mallard Duck',
        description:
            'The world\'s most familiar duck. The male has an iridescent green head and yellow bill; the female is mottled brown. The ancestor of most domestic duck breeds and found on almost every pond.',
        imagePath: 'assets/bird_photos/mallard_duck.webp',
        aliases: ['mallard'],
      ),
      GuessBirdQuestion(
        birdName: 'Greylag Goose',
        description:
            'A large, bulky goose with pale grey plumage and a hefty orange-pink bill. Found on lakes and reservoirs, it is the ancestor of the farmyard goose. Often seen grazing on grassland near water.',
        imagePath: 'assets/bird_photos/greylag_goose.webp',
        aliases: ['greylag', 'grey lag goose'],
      ),
      GuessBirdQuestion(
        birdName: 'Canada Geese',
        description:
            'A large goose with a distinctive jet-black neck and head, a clean white cheek patch and a brown body. Native to North America but now very widespread across Britain. Has a loud, honking call.',
        imagePath: 'assets/bird_photos/canada_geese.webp',
        aliases: ['canada goose', 'canadian goose'],
      ),
      GuessBirdQuestion(
        birdName: 'Bewick Swan',
        description:
            'The smallest of the wild swans. Pure white plumage with a bill that is mostly black, bearing a variable patch of yellow at the base — the pattern is unique to each individual. Winters in Britain from Siberia.',
        imagePath: 'assets/bird_photos/bewick_swan.webp',
        aliases: ["bewick's swan"],
      ),
      GuessBirdQuestion(
        birdName: 'Mute Swan',
        description:
            'An enormous, graceful all-white bird with an orange bill and a large black knob at its base. One of the heaviest flying birds in Britain, it can be aggressive near its nest. Glides silently on still water.',
        imagePath: 'assets/bird_photos/female_mute_swan.webp',
        aliases: ['mute swan', 'swan'],
      ),
      GuessBirdQuestion(
        birdName: 'Goldeneyes',
        description:
            'A medium-sized diving duck. The male has an iridescent dark green head with a round white spot near the base of the bill and a striking bright golden eye that gives the species its name.',
        imagePath: 'assets/bird_photos/common_goldeneyes.webp',
        aliases: ['goldeneye', 'common goldeneye'],
      ),
      GuessBirdQuestion(
        birdName: 'Pintail',
        description:
            'A slender, elegant duck with a graceful elongated silhouette. The male has a rich chocolate-brown head, a white chest and very long pointed central tail feathers. Often seen on estuaries and flooded fields.',
        imagePath: 'assets/bird_photos/northern_pintail.webp',
        aliases: ['pintail'],
      ),
      GuessBirdQuestion(
        birdName: 'Teal',
        description:
            'Britain\'s smallest dabbling duck. The female is mottled brown and buff with a green and black wing patch visible in flight. Found on shallow, vegetated wetlands. Rises steeply and swiftly when alarmed.',
        imagePath: 'assets/bird_photos/female_eurasian_teal.webp',
        aliases: ['eurasian teal', 'teal', 'common teal'],
      ),
      GuessBirdQuestion(
        birdName: 'Smew',
        description:
            'A compact diving duck with a serrated bill for gripping fish. The male is dazzling white with fine black lines and panda-like eye patches. The female has a chestnut-red head and white cheeks.',
        imagePath: 'assets/bird_photos/smew.webp',
        aliases: [],
      ),
      GuessBirdQuestion(
        birdName: 'Bar Headed Goose',
        description:
            'A pale grey goose with a white head bearing two distinctive black bars across the back of the crown. Famous for its remarkable ability to migrate over the Himalayan mountains at extreme altitude.',
        imagePath: 'assets/bird_photos/bar_headed_goose.webp',
        aliases: ['bar-headed goose'],
      ),
    ],
  ),

  // ─── Level 3: Raptors & Owls ────────────────────────────────────────────────
  GuessBirdLevel(
    title: 'Raptors & Owls',
    subtitle: 'Birds of prey and night hunters',
    emoji: '🦅',
    questions: [
      GuessBirdQuestion(
        birdName: 'Kestrel',
        description:
            'A small reddish-brown falcon instantly recognisable from its habit of hovering motionless in the wind, head angled down, scanning for small mammals and insects below.',
        imagePath: 'assets/bird_photos/common_kestrel.webp',
        aliases: ['kestrel'],
      ),
      GuessBirdQuestion(
        birdName: 'Barn Owl',
        description:
            'A medium-sized owl with a distinctive heart-shaped white face disc, golden-buff upperparts and pure white underparts. Hunts silently at dusk and dawn over farmland and rough grassland.',
        imagePath: 'assets/bird_photos/barn_owl.webp',
        aliases: [],
      ),
      GuessBirdQuestion(
        birdName: 'Snowy Owl',
        description:
            'A large, stunning owl from Arctic tundra. Mostly white with bright yellow eyes. The female is more heavily barred with brown; the male can be nearly pure white. Made famous by a famous fictional owl.',
        imagePath: 'assets/bird_photos/snowy_owl.webp',
        aliases: [],
      ),
      GuessBirdQuestion(
        birdName: 'Great Grey Owl',
        description:
            'The world\'s largest owl by length. It has a massive circular grey facial disc with concentric dark rings, small piercing yellow eyes and no prominent ear tufts. Found in northern boreal forests.',
        imagePath: 'assets/bird_photos/great_grey_owl.webp',
        aliases: ['great gray owl'],
      ),
      GuessBirdQuestion(
        birdName: 'Harris Hawk',
        description:
            'A dark brown raptor with striking chestnut-red on the shoulders and thighs, a white rump and a white-tipped tail. Uniquely among raptors, it hunts cooperatively in family groups.',
        imagePath: 'assets/bird_photos/harris_hawk.webp',
        aliases: ["harris's hawk"],
      ),
      GuessBirdQuestion(
        birdName: 'Bald Eagle',
        description:
            'An iconic North American raptor. The adult has a brilliant white head and tail that contrasts sharply with its dark brown body and yellow bill. It is the national emblem of the United States.',
        imagePath: 'assets/bird_photos/bald_eagle.webp',
        aliases: [],
      ),
      GuessBirdQuestion(
        birdName: 'Short Eared Owl',
        description:
            'A medium-sized owl with pale, streaky buff-brown plumage and tiny "ear" tufts that are barely visible. It is often seen actively hunting low over open moorland, marshes and farmland in daylight.',
        imagePath: 'assets/bird_photos/short_eared_owl.webp',
        aliases: ['short-eared owl'],
      ),
      GuessBirdQuestion(
        birdName: 'Great Horned Owl',
        description:
            'A large, powerful North American owl with prominent feathered "horns" (ear tufts), piercing orange-yellow eyes and a deep, resonant hooting call. One of the most widespread owls in the Americas.',
        imagePath: 'assets/bird_photos/great_horned_owl.webp',
        aliases: [],
      ),
      GuessBirdQuestion(
        birdName: 'Little Owl',
        description:
            'A small, flat-headed owl introduced to Britain in the 19th century. Spotted brown and white with fierce-looking yellow eyes. Often seen perching in daylight on fence posts or branches.',
        imagePath: 'assets/bird_photos/little_owl.webp',
        aliases: [],
      ),
      GuessBirdQuestion(
        birdName: 'Redshanks',
        description:
            'A medium-sized wading bird with brown streaked plumage and long, bright orange-red legs that give it its name. It has a red-based bill and a distinctive alarm call — a loud "tew-tew-tew".',
        imagePath: 'assets/bird_photos/common_redshanks.webp',
        aliases: ['redshank', 'redshanks', 'common redshank'],
      ),
    ],
  ),

  // ─── Level 4: Exotic & Colourful Birds ──────────────────────────────────────
  GuessBirdLevel(
    title: 'Exotic & Colourful',
    subtitle: 'Stunning birds from around the world',
    emoji: '🦜',
    questions: [
      GuessBirdQuestion(
        birdName: 'Flamingo',
        description:
            'A tall wading bird with vivid bright pink plumage, very long thin legs and a uniquely downward-curved pink-and-black bill. Famous for habitually standing on one leg while resting.',
        imagePath: 'assets/bird_photos/american_flamingo.webp',
        aliases: ['flamingo'],
      ),
      GuessBirdQuestion(
        birdName: 'Peacock',
        description:
            'The spectacular male peafowl, with an iridescent blue-green body and an enormous fan-shaped tail train covered in shimmering "eye" spots. It can be extremely noisy, especially at dawn.',
        imagePath: 'assets/bird_photos/indian_peacock.webp',
        aliases: ['peacock', 'peafowl', 'indian peafowl'],
      ),
      GuessBirdQuestion(
        birdName: 'Keel Billed Toucan',
        description:
            'A strikingly colourful Central American bird with a massive rainbow-coloured bill in vivid green, red and orange — almost as long as the bird\'s entire body. Feeds mainly on fruit.',
        imagePath: 'assets/bird_photos/keel_billed_toucan.webp',
        aliases: ['keel-billed toucan', 'rainbow billed toucan'],
      ),
      GuessBirdQuestion(
        birdName: 'Yellow Throated Toucan',
        description:
            'A large toucan with a jet-black body, a vivid yellow throat and chest, and an enormous two-toned bill with a yellow upper ridge outlined in black. Found in Central and South American forests.',
        imagePath: 'assets/bird_photos/yellow_throated_toucan.webp',
        aliases: ['yellow-throated toucan'],
      ),
      GuessBirdQuestion(
        birdName: 'Blue And Yellow Macaw',
        description:
            'A large, loud parrot with brilliant blue upper parts and vivid yellow underparts. A broad bare white face patch and a powerful hooked bill. Frequently kept as a companion bird.',
        imagePath: 'assets/bird_photos/blue_and_yellow_macaw.webp',
        aliases: ['blue and yellow macaw', 'blue-and-yellow macaw', 'blue yellow macaw'],
      ),
      GuessBirdQuestion(
        birdName: 'Blue Macaw',
        description:
            'An entirely blue parrot with a pale grey bare facial patch and dark blue primary feathers. One of the world\'s most recognisable and iconic parrots, widely celebrated in popular culture.',
        imagePath: 'assets/bird_photos/blue_macaw.webp',
        aliases: [],
      ),
      GuessBirdQuestion(
        birdName: 'Cardinal',
        description:
            'A striking North American songbird. The male is vivid all-over crimson red with a distinctive crested head and a black mask surrounding its thick orange-red bill. A favourite garden visitor.',
        imagePath: 'assets/bird_photos/northern_cardinal.webp',
        aliases: ['cardinal', 'red cardinal'],
      ),
      GuessBirdQuestion(
        birdName: 'Blue Tailed Bee Eater',
        description:
            'A brilliantly coloured Asian bird with a vivid blue tail, an emerald-green body, chestnut throat and a long, slightly curved black bill. Often perches conspicuously on overhead wires.',
        imagePath: 'assets/bird_photos/blue_tailed_bee_eater.webp',
        aliases: ['blue-tailed bee-eater', 'blue tail bee eater'],
      ),
      GuessBirdQuestion(
        birdName: 'Lilac Breasted Roller',
        description:
            'An African bird with turquoise-blue belly, a lilac breast, green crown and chestnut back. Famous for the spectacular rolling aerial display it performs in flight, hence its name.',
        imagePath: 'assets/bird_photos/lilac_breasted_roller.webp',
        aliases: ['lilac-breasted roller'],
      ),
      GuessBirdQuestion(
        birdName: 'Yellow Indian Ringnecked Parakeet',
        description:
            'A bright yellow parakeet with a long pointed tail and a distinctive pink and black ring encircling the male\'s neck. A popular cage bird that has also established wild populations in several countries.',
        imagePath: 'assets/bird_photos/yellow_indian_ringnecked_parakeet.webp',
        aliases: [
          'ringnecked parakeet',
          'ring-necked parakeet',
          'indian ringneck',
          'ringneck parakeet',
        ],
      ),
    ],
  ),

  // ─── Level 5: Shore, Sea & Sky ──────────────────────────────────────────────
  GuessBirdLevel(
    title: 'Shore, Sea & Sky',
    subtitle: 'Coastal birds and rare waders from around the world',
    emoji: '🌊',
    questions: [
      GuessBirdQuestion(
        birdName: 'Atlantic Puffin',
        description:
            'A small seabird with a clown-like appearance: black-and-white plumage and a large, brightly striped triangular bill in summer. Nests in burrows on sea cliffs and carries dozens of fish at once.',
        imagePath: 'assets/bird_photos/atlantic_puffin.webp',
        aliases: ['puffin'],
      ),
      GuessBirdQuestion(
        birdName: 'Laughing Gulls',
        description:
            'A medium North American gull named for its distinctive laughing call. In summer it develops a dark brown-black hood and a red bill. Grey wings with black wingtips, and white body.',
        imagePath: 'assets/bird_photos/laughing_gulls.webp',
        aliases: ['laughing gull'],
      ),
      GuessBirdQuestion(
        birdName: 'Black Headed Gull',
        description:
            'A common British gull with a chocolate-brown hood in summer, and a red bill and legs. In winter the hood shrinks to a small dark spot behind the eye. Often seen far inland on playing fields.',
        imagePath: 'assets/bird_photos/black_headed_gull.webp',
        aliases: ['black-headed gull', 'black head gull'],
      ),
      GuessBirdQuestion(
        birdName: 'Frigatebird',
        description:
            'A large tropical seabird with long, angled wings and a deeply forked tail. The male has a vivid scarlet throat pouch that he inflates dramatically like a balloon to attract females at breeding colonies.',
        imagePath: 'assets/bird_photos/frigatebird.webp',
        aliases: ['frigate bird', 'magnificent frigatebird'],
      ),
      GuessBirdQuestion(
        birdName: 'Little Egret',
        description:
            'A small, elegant all-white heron with a black bill, long black legs and strikingly bright yellow feet. Wades delicately in shallow water to catch fish. Now a common sight on British coasts and rivers.',
        imagePath: 'assets/bird_photos/little_egret.webp',
        aliases: ['egret'],
      ),
      GuessBirdQuestion(
        birdName: 'Grey Heron',
        description:
            'A tall, stately wading bird with grey and white plumage. Stands motionless for long periods waiting to spear fish with its dagger-like bill. Folds its long neck into an S-shape in flight.',
        imagePath: 'assets/bird_photos/juvenile_grey_heron.webp',
        aliases: ['grey heron', 'gray heron', 'heron'],
      ),
      GuessBirdQuestion(
        birdName: 'Red Crowned Crane',
        description:
            'One of the world\'s rarest cranes. A tall, graceful white bird with black wings and neck, and a distinctive patch of bare red skin on the crown. Performs elaborate dancing displays and is sacred in East Asia.',
        imagePath: 'assets/bird_photos/red_crowned_crane.webp',
        aliases: ['red-crowned crane', 'japanese crane'],
      ),
      GuessBirdQuestion(
        birdName: 'Male Common Eider',
        description:
            'A large, heavy sea duck. The male has distinctive black-and-white plumage, a pale greenish nape and a long sloping bill. The famously soft down feathers lining its nest are used to fill traditional eiderdown duvets.',
        imagePath: 'assets/bird_photos/male_common_eide.webp',
        aliases: ['eider', 'eider duck', 'common eider'],
      ),
      GuessBirdQuestion(
        birdName: 'Magpie Goose',
        description:
            'A distinctive large black-and-white bird from Australia and New Guinea. It has a bony knobbly protrusion on top of the crown and semi-webbed feet — an unusual feature for a goose. Honks loudly.',
        imagePath: 'assets/bird_photos/magpie_goose.webp',
        aliases: [],
      ),
      GuessBirdQuestion(
        birdName: 'Common Kingfisher',
        description:
            'A small, jewel-like bird with brilliant electric-blue upper parts and vivid orange-chestnut underparts. Sits motionless on a perch before plunging steeply into rivers and streams to catch small fish.',
        imagePath: 'assets/bird_photos/common_kingfisher.webp',
        aliases: ['kingfisher'],
      ),
    ],
  ),
];
