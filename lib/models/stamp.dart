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
  const Stamp(
    id: 'star_collector',
    title: 'Star Collector',
    description: 'Earn your first 10 stars.',
    iconPath: 'assets/bird_icons/goldcrest.webp',
  ),
  const Stamp(
    id: 'flawless_flyer',
    title: 'Flawless Flyer',
    description: 'Get a perfect score (3 stars) on 10 different levels.',
    iconPath: 'assets/bird_icons/kingfisher.webp',
  ),
  const Stamp(
    id: 'dedicated_birder',
    title: 'Dedicated Birder',
    description: 'Complete 50 levels across any section.',
    iconPath: 'assets/bird_icons/wren.webp',
  ),
  const Stamp(
    id: 'legendary_watcher',
    title: 'Legendary Watcher',
    description: 'Answer 1000 questions correctly in total.',
    iconPath: 'assets/bird_icons/lapwing.webp',
  ),
  const Stamp(
    id: 'scramble_champion',
    title: 'Scramble Champion',
    description: 'Unscramble 50 words.',
    iconPath: 'assets/bird_icons/nuthatch.webp',
  ),
  const Stamp(
    id: 'id_master',
    title: 'ID Master',
    description: 'Reach a high score of 100 in Bird ID.',
    iconPath: 'assets/bird_icons/waxwing.webp',
  ),
  // -- 20 New Varied Stamps --
  const Stamp(
    id: 'time_flies',
    title: 'Time Flies',
    description: 'Play the game for 10 total hours.',
    iconPath: 'assets/bird_icons/loon.webp',
  ),
  const Stamp(
    id: 'frequent_flyer',
    title: 'Frequent Flyer',
    description: 'Play the game for 24 total hours.',
    iconPath: 'assets/bird_icons/fulmar.webp',
  ),
  const Stamp(
    id: 'smart_cookie',
    title: 'Smart Cookie',
    description: 'Answer 2,000 questions correctly.',
    iconPath: 'assets/bird_icons/crow.webp',
  ),
  const Stamp(
    id: 'know_it_owl',
    title: 'Know-It-Owl',
    description: 'Answer 5,000 questions correctly.',
    iconPath: 'assets/bird_icons/rook.webp',
  ),
  const Stamp(
    id: 'constellation',
    title: 'Constellation',
    description: 'Earn an incredible 350 Stars.',
    iconPath: 'assets/bird_icons/skylark.webp',
  ),
  const Stamp(
    id: 'level_100',
    title: 'Centurion',
    description: 'Complete 100 different levels.',
    iconPath: 'assets/bird_icons/turnstone.webp',
  ),
  const Stamp(
    id: 'flawless_flock',
    title: 'Flawless Flock',
    description: 'Get a perfect 3 stars on 50 levels.',
    iconPath: 'assets/bird_icons/dunlin.webp',
  ),
  const Stamp(
    id: 'wordsmith',
    title: 'Wordsmith',
    description: 'Unscramble 250 words.',
    iconPath: 'assets/bird_icons/blackcap.webp',
  ),
  const Stamp(
    id: 'anagram_ace',
    title: 'Anagram Ace',
    description: 'Unscramble 500 words.',
    iconPath: 'assets/bird_icons/chiffchaff.webp',
  ),
  const Stamp(
    id: 'spelling_bee',
    title: 'Spelling Bee',
    description: 'Score a high score of 20 in Scramble.',
    iconPath: 'assets/bird_icons/stonechat.webp',
  ),
  const Stamp(
    id: 'sharp_shooter',
    title: 'Sharp Shooter',
    description: 'High Score of 250 in Bird ID.',
    iconPath: 'assets/bird_icons/snipe.webp',
  ),
  const Stamp(
    id: 'hawk_eyed',
    title: 'Hawk-Eyed',
    description: 'High Score of 500 in Bird ID.',
    iconPath: 'assets/bird_icons/curlew.webp',
  ),
  const Stamp(
    id: 'bird_paparazzi',
    title: 'Paparazzi',
    description: 'High Score of 1000 in Bird ID.',
    iconPath: 'assets/bird_icons/oystercatcher.webp',
  ),
  const Stamp(
    id: 'trivia_addict',
    title: 'Trivia Addict',
    description: 'Answer 50 Trivia questions correctly.',
    iconPath: 'assets/bird_icons/pheasant.webp',
  ),
  const Stamp(
    id: 'biology_buff',
    title: 'Biology Buff',
    description: 'Answer 50 Biology questions correctly.',
    iconPath: 'assets/bird_icons/dipper.webp',
  ),
  const Stamp(
    id: 'habitat_hero',
    title: 'Habitat Hero',
    description: 'Answer 50 Habitat questions correctly.',
    iconPath: 'assets/bird_icons/teal.webp',
  ),
  const Stamp(
    id: 'conservation_champion',
    title: 'Nature Champ',
    description: 'Answer 50 Conservation questions correctly.',
    iconPath: 'assets/bird_icons/wigeon.webp',
  ),
  const Stamp(
    id: 'behavior_boss',
    title: 'Behavior Boss',
    description: 'Answer 50 Behaviour questions correctly.',
    iconPath: 'assets/bird_icons/redshank.webp',
  ),
  const Stamp(
    id: 'family_fanatic',
    title: 'Family Fanatic',
    description: 'Answer 50 Families questions correctly.',
    iconPath: 'assets/bird_icons/linnet.webp',
  ),
  const Stamp(
    id: 'migration_marvel',
    title: 'Migrator',
    description: 'Answer 50 Migration questions correctly.',
    iconPath: 'assets/bird_icons/yellowhammer.webp',
  ),
  // -- 10 Additional New Stamps --
  const Stamp(
    id: 'colours_champ',
    title: 'Colours Champ',
    description: 'Answer 50 Colours questions correctly.',
    iconPath: 'assets/bird_icons/gull.webp',
  ),
  const Stamp(
    id: 'weekend_warrior',
    title: 'Weekend Warrior',
    description: 'Play the game for 48 total hours.',
    iconPath: 'assets/bird_icons/eider.webp',
  ),
  const Stamp(
    id: 'flawless_master',
    title: 'Flawless Master',
    description: 'Get a perfect 3 stars on 75 levels.',
    iconPath: 'assets/bird_icons/avocet.webp',
  ),
  const Stamp(
    id: 'quiz_guru',
    title: 'Quiz Guru',
    description: 'Answer 10,000 questions correctly.',
    iconPath: 'assets/bird_icons/siskin.webp',
  ),
  const Stamp(
    id: 'id_legend',
    title: 'ID Legend',
    description: 'Reach a high score of 2000 in Bird ID.',
    iconPath: 'assets/bird_icons/coot.webp',
  ),
  const Stamp(
    id: 'scramble_legend',
    title: 'Scramble Legend',
    description: 'Unscramble 1,000 words.',
    iconPath: 'assets/bird_icons/dunnock.webp',
  ),
  const Stamp(
    id: 'spelling_master',
    title: 'Spelling Master',
    description: 'Score a high score of 30 in Scramble.',
    iconPath: 'assets/bird_icons/great_tit.webp',
  ),
  const Stamp(
    id: 'trivia_titan',
    title: 'Trivia Titan',
    description: 'Answer 150 Trivia questions correctly.',
    iconPath: 'assets/bird_icons/moorhen.webp',
  ),
  const Stamp(
    id: 'biology_brain',
    title: 'Biology Brain',
    description: 'Answer 150 Biology questions correctly.',
    iconPath: 'assets/bird_icons/pintail.webp',
  ),
  const Stamp(
    id: 'habitat_hound',
    title: 'Habitat Hound',
    description: 'Answer 150 Habitat questions correctly.',
    iconPath: 'assets/bird_icons/razorbill.webp',
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
  // -- Daily Challenge Stamps --
  const Stamp(
    id: 'daily_bonus_1',
    title: 'Early Riser',
    description: 'Complete your first Daily Bird Challenge.',
    iconPath: 'assets/bird_icons/robin.webp',
  ),
  const Stamp(
    id: 'daily_bonus_5',
    title: 'Daily Dedication',
    description: 'Complete 5 Daily Bird Challenges.',
    iconPath: 'assets/bird_icons/jay.webp',
  ),
  const Stamp(
    id: 'daily_bonus_20',
    title: 'Habitual Hatchling',
    description: 'Complete 20 Daily Bird Challenges.',
    iconPath: 'assets/bird_icons/woodpecker.webp',
  ),
  const Stamp(
    id: 'daily_bonus_50',
    title: 'Routine Raptor',
    description: 'Complete 50 Daily Bird Challenges.',
    iconPath: 'assets/bird_icons/puffin.webp',
  ),
  const Stamp(
    id: 'daily_bonus_100',
    title: 'Centurion Scholar',
    description: 'Complete 100 Daily Bird Challenges.',
    iconPath: 'assets/bird_icons/barn_owl.webp',
  ),
  const Stamp(
    id: 'daily_bonus_365',
    title: 'Year-Round Birder',
    description: 'Complete 365 Daily Bird Challenges.',
    iconPath: 'assets/bird_icons/red_kite.webp',
  ),
  // -- Login Streak Stamps --
  const Stamp(
    id: 'first_login',
    title: 'First Sighting',
    description: 'Log into the app for the very first time.',
    iconPath: 'assets/bird_icons/house_sparrow.webp',
  ),
  const Stamp(
    id: 'login_streak_3',
    title: 'Returning Flock',
    description: 'Log in for 3 days in a row.',
    iconPath: 'assets/bird_icons/gull.webp',
  ),
  const Stamp(
    id: 'login_streak_7',
    title: 'Weekly Wings',
    description: 'Log in for 7 days in a row.',
    iconPath: 'assets/bird_icons/lapwing.webp',
  ),
  // -- Vocabulary / Scramble Stamps --
  const Stamp(
    id: 'scramble_master',
    title: 'Scramble Master',
    description: 'Unscramble all words in the Scramble Section.',
    iconPath: 'assets/bird_icons/jackdaw.webp',
  ),
  // -- Endless Mode Stamps --
  const Stamp(
    id: 'endless_streak_10',
    title: 'Endless Hatchling',
    description: 'Reach a streak of 10 in Endless Mode.',
    iconPath: 'assets/bird_icons/robin.webp',
  ),
  const Stamp(
    id: 'endless_streak_20',
    title: 'Endless Glider',
    description: 'Reach a streak of 20 in Endless Mode.',
    iconPath: 'assets/bird_icons/jay.webp',
  ),
  const Stamp(
    id: 'endless_streak_50',
    title: 'Endless Soarer',
    description: 'Reach a streak of 50 in Endless Mode.',
    iconPath: 'assets/bird_icons/barn_owl.webp',
  ),
  const Stamp(
    id: 'endless_streak_100',
    title: 'Endless Legend',
    description: 'Answer 100 Endless Mode questions in a row.',
    iconPath: 'assets/bird_icons/red_kite.webp',
  ),
  // -- Rescue the Bird Stamps --
  const Stamp(
    id: 'rescue_rookie',
    title: 'Rescue Rookie',
    description: 'Rescue your very first bird from its egg.',
    iconPath: 'assets/bird_icons/robin.webp',
  ),
  const Stamp(
    id: 'rescue_ranger',
    title: 'Rescue Ranger',
    description: 'Rescue 10 birds in the Rescue the Bird game.',
    iconPath: 'assets/bird_icons/greenfinch.webp',
  ),
  const Stamp(
    id: 'rescue_hero',
    title: 'Rescue Hero',
    description: 'Rescue 25 birds in the Rescue the Bird game.',
    iconPath: 'assets/bird_icons/barn_owl.webp',
  ),
];
