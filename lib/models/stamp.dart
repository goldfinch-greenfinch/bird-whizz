class Stamp {
  final String id;
  final String title;
  final String description;
  final String iconPath;

  const Stamp({
    required this.id,
    required this.title,
    required this.description,
    required this.iconPath,
  });
}

// Global list of stamps in the game
final List<Stamp> gameStamps = [
  const Stamp(
    id: 'first_flight',
    title: 'First Flight',
    description: 'Completed your very first quiz level.',
    iconPath: 'assets/bird_icons/robin.webp',
  ),
  const Stamp(
    id: 'dedicated_watcher',
    title: 'Dedicated Watcher',
    description: 'Spend more than 1 hour exploring.',
    iconPath: 'assets/bird_icons/barn_owl.webp',
  ),
  const Stamp(
    id: 'trivia_master',
    title: 'Trivia Master',
    description: 'Answer 50 questions correctly across all quizzes.',
    iconPath: 'assets/bird_icons/jay.webp',
  ),
  const Stamp(
    id: 'vocab_virtuoso',
    title: 'Vocab Virtuoso',
    description: 'Unscramble 20 words.',
    iconPath: 'assets/bird_icons/house_sparrow.webp',
  ),
  const Stamp(
    id: 'perfectionist',
    title: 'Perfectionist',
    description: 'Get a perfect score (3 stars) on any level.',
    iconPath: 'assets/bird_icons/woodpecker.webp',
  ),
  const Stamp(
    id: 'identification_expert',
    title: 'ID Expert',
    description: 'Reach a high score of 50 in Bird ID.',
    iconPath: 'assets/bird_icons/puffin.webp',
  ),
  const Stamp(
    id: 'century_club',
    title: 'Century Club',
    description: 'Answer 100 questions correctly.',
    iconPath: 'assets/bird_icons/heron.webp',
  ),
  const Stamp(
    id: 'marathon_flyer',
    title: 'Marathon Flyer',
    description: 'Answer 500 questions correctly in total.',
    iconPath: 'assets/bird_icons/buzzard.webp',
  ),
  const Stamp(
    id: 'avian_apprentice',
    title: 'Avian Apprentice',
    description: 'Earn a total of 100 stars.',
    iconPath: 'assets/bird_icons/chaffinch.webp',
  ),
  const Stamp(
    id: 'master_ornithologist',
    title: 'Master Ornithologist',
    description: 'Earn a total of 250 stars.',
    iconPath: 'assets/bird_icons/goldfinch.webp',
  ),
  const Stamp(
    id: 'flock_starter',
    title: 'Flock Starter',
    description: 'Complete 10 levels across any section.',
    iconPath: 'assets/bird_icons/greenfinch.webp',
  ),
  const Stamp(
    id: 'quiz_whiz',
    title: 'Quiz Whiz',
    description: 'Answer 250 questions correctly.',
    iconPath: 'assets/bird_icons/coal_tit.webp',
  ),
  // -- Section Completion Stamps --
  const Stamp(
    id: 'trivia_complete',
    title: 'Trivia Expert',
    description: 'Earn a star in every Trivia level.',
    iconPath: 'assets/bird_icons/magpie.webp',
  ),
  const Stamp(
    id: 'biology_complete',
    title: 'Avian Biologist',
    description: 'Earn a star in every Biology level.',
    iconPath: 'assets/bird_icons/blue_tit.webp',
  ),
  const Stamp(
    id: 'habitat_complete',
    title: 'Habitat Explorer',
    description: 'Earn a star in every Habitat level.',
    iconPath: 'assets/bird_icons/mallard.webp',
  ),
  const Stamp(
    id: 'conservation_complete',
    title: 'Conservationist',
    description: 'Earn a star in every Conservation level.',
    iconPath: 'assets/bird_icons/red_kite.webp',
  ),
  const Stamp(
    id: 'behaviour_complete',
    title: 'Behaviour Analyst',
    description: 'Earn a star in every Behaviour level.',
    iconPath: 'assets/bird_icons/starling.webp',
  ),
  const Stamp(
    id: 'families_complete',
    title: 'Family Tie',
    description: 'Earn a star in every Families level.',
    iconPath: 'assets/bird_icons/song_thrush.webp',
  ),
  const Stamp(
    id: 'migration_complete',
    title: 'Migration Navigator',
    description: 'Earn a star in every Migration level.',
    iconPath: 'assets/bird_icons/brambling.webp',
  ),
  const Stamp(
    id: 'colours_complete',
    title: 'Colour Connoisseur',
    description: 'Earn a star in every Colours level.',
    iconPath: 'assets/bird_icons/bullfinch.webp',
  ),
  // -- Bird Identification Stamps --
  const Stamp(
    id: 'id_easy_complete',
    title: 'Eagle Eye: Easy',
    description: 'Complete the Easy Bird Identification challenge.',
    iconPath: 'assets/bird_icons/kestrel.webp',
  ),
  const Stamp(
    id: 'id_medium_complete',
    title: 'Eagle Eye: Medium',
    description: 'Complete the Medium Bird Identification challenge.',
    iconPath: 'assets/bird_icons/goshawk.webp',
  ),
  const Stamp(
    id: 'id_hard_complete',
    title: 'Eagle Eye: Hard',
    description: 'Complete the Hard Bird Identification challenge.',
    iconPath: 'assets/bird_icons/blackbird.webp',
  ),
  // -- Vocabulary / Scramble Stamps --
  const Stamp(
    id: 'scramble_master',
    title: 'Scramble Master',
    description: 'Unscramble all words in the Scramble Section.',
    iconPath: 'assets/bird_icons/jackdaw.webp',
  ),
];
