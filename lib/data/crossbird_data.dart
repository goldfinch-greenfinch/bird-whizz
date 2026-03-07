class CrossbirdWord {
  final int clueNumber;
  final String direction; // 'across' or 'down'
  final int startRow;
  final int startCol;
  final String answer;
  final String clue;

  const CrossbirdWord({
    required this.clueNumber,
    required this.direction,
    required this.startRow,
    required this.startCol,
    required this.answer,
    required this.clue,
  });

  List<(int, int)> get cells {
    return List.generate(answer.length, (i) {
      return direction == 'across'
          ? (startRow, startCol + i)
          : (startRow + i, startCol);
    });
  }

  String get label =>
      '$clueNumber-${direction[0].toUpperCase()}${direction.substring(1)}';
}

class CrossbirdPuzzle {
  final String id;
  final String title;
  final int rows;
  final int cols;
  final List<CrossbirdWord> words;

  const CrossbirdPuzzle({
    required this.id,
    required this.title,
    required this.rows,
    required this.cols,
    required this.words,
  });
}

// Puzzle 1 grid (8 rows x 9 cols):
//   col: 0 1 2 3 4 5 6 7 8
// row 0:  . . . W R E N . .
// row 1:  . . . . O . I . .
// row 2:  . . . . B . G . .
// row 3:  O S T R I C H . .
// row 4:  . . . . N . T . .
// row 5:  . . . . . . J A Y
// row 6:  . . . S K U A . .
// row 7:  . . . . . . R . .
//
// Puzzle 2 grid (7 rows x 9 cols):
//   col: 0 1 2 3 4 5 6 7 8
// row 0:  G O L D F I N C H
// row 1:  O . . U . . . . .
// row 2:  S W A N . . . . .
// row 3:  H . . L I N N E T
// row 4:  A . . I . . . . .
// row 5:  W R Y N E C K . .
// row 6:  K . . . . . . . .
//
// Puzzle 3 grid (7 rows x 9 cols):
//   col: 0 1 2 3 4 5 6 7 8
// row 0:  . C . . . . S . .
// row 1:  D U N N O C K . .
// row 2:  . C . . . . Y . .
// row 3:  . K . . . . L . .
// row 4:  C O R N C R A K E
// row 5:  . O . . . . R . .
// row 6:  . . S T O R K . .
//
// Puzzle 4 grid (7 rows x 7 cols):
//   col: 0 1 2 3 4 5 6
// row 0:  . . Q U A I L
// row 1:  . . U . . . .
// row 2:  . . E G R E T
// row 3:  . . T . . . .
// row 4:  B U Z Z A R D
// row 5:  . . A . . . .
// row 6:  . . L O O N .

final List<CrossbirdPuzzle> crossbirdPuzzles = [
  const CrossbirdPuzzle(
    id: 'crossbird_1',
    title: 'Night & Day',
    rows: 8,
    cols: 9,
    words: [
      CrossbirdWord(
        clueNumber: 1,
        direction: 'across',
        startRow: 0,
        startCol: 3,
        answer: 'WREN',
        clue: "Britain's tiniest common bird with a disproportionately loud song",
      ),
      CrossbirdWord(
        clueNumber: 2,
        direction: 'down',
        startRow: 0,
        startCol: 4,
        answer: 'ROBIN',
        clue: "Britain's best-loved garden bird, famous for its red breast",
      ),
      CrossbirdWord(
        clueNumber: 3,
        direction: 'down',
        startRow: 0,
        startCol: 6,
        answer: 'NIGHTJAR',
        clue: "Nocturnal bird with an eerie churring call, active at dusk and dawn",
      ),
      CrossbirdWord(
        clueNumber: 4,
        direction: 'across',
        startRow: 3,
        startCol: 0,
        answer: 'OSTRICH',
        clue: "The world's largest bird — flightless but the fastest runner on two legs",
      ),
      CrossbirdWord(
        clueNumber: 5,
        direction: 'across',
        startRow: 5,
        startCol: 6,
        answer: 'JAY',
        clue: "Colourful, noisy crow with a harsh screech and a love of acorns",
      ),
      CrossbirdWord(
        clueNumber: 6,
        direction: 'across',
        startRow: 6,
        startCol: 3,
        answer: 'SKUA',
        clue: "Piratical seabird that chases and robs other birds of their catch",
      ),
    ],
  ),
  const CrossbirdPuzzle(
    id: 'crossbird_2',
    title: 'Woodland & Shore',
    rows: 7,
    cols: 9,
    words: [
      CrossbirdWord(
        clueNumber: 1,
        direction: 'across',
        startRow: 0,
        startCol: 0,
        answer: 'GOLDFINCH',
        clue: "Jewel-like finch with a crimson face and golden wing-bar",
      ),
      CrossbirdWord(
        clueNumber: 1,
        direction: 'down',
        startRow: 0,
        startCol: 0,
        answer: 'GOSHAWK',
        clue: "Powerful woodland raptor built for high-speed pursuit through trees",
      ),
      CrossbirdWord(
        clueNumber: 2,
        direction: 'down',
        startRow: 0,
        startCol: 3,
        answer: 'DUNLIN',
        clue: "Small wading bird that forms vast, twisting flocks over estuaries in winter",
      ),
      CrossbirdWord(
        clueNumber: 3,
        direction: 'across',
        startRow: 2,
        startCol: 0,
        answer: 'SWAN',
        clue: "Graceful white waterbird and an enduring symbol of elegance",
      ),
      CrossbirdWord(
        clueNumber: 4,
        direction: 'across',
        startRow: 3,
        startCol: 3,
        answer: 'LINNET',
        clue: "Small rosy-breasted finch, once widely kept in cages for its sweet song",
      ),
      CrossbirdWord(
        clueNumber: 5,
        direction: 'across',
        startRow: 5,
        startCol: 0,
        answer: 'WRYNECK',
        clue: "Cryptically camouflaged migrant and an oddity among the woodpecker family",
      ),
    ],
  ),
  const CrossbirdPuzzle(
    id: 'crossbird_3',
    title: 'Meadow & Heath',
    rows: 7,
    cols: 9,
    words: [
      CrossbirdWord(
        clueNumber: 1,
        direction: 'down',
        startRow: 0,
        startCol: 1,
        answer: 'CUCKOO',
        clue: "Brood parasite whose two-note call is the most recognised herald of spring",
      ),
      CrossbirdWord(
        clueNumber: 2,
        direction: 'down',
        startRow: 0,
        startCol: 6,
        answer: 'SKYLARK',
        clue: "Famous for its soaring song-flight high above open farmland and moorland",
      ),
      CrossbirdWord(
        clueNumber: 3,
        direction: 'across',
        startRow: 1,
        startCol: 0,
        answer: 'DUNNOCK',
        clue: "Quiet, mouse-like garden bird with a surprisingly complex love life",
      ),
      CrossbirdWord(
        clueNumber: 4,
        direction: 'across',
        startRow: 4,
        startCol: 0,
        answer: 'CORNCRAKE',
        clue: "Elusive craking bird of hay meadows, now rarely heard in Britain",
      ),
      CrossbirdWord(
        clueNumber: 5,
        direction: 'across',
        startRow: 6,
        startCol: 2,
        answer: 'STORK',
        clue: "Large white bird of legend, said to deliver newborn babies",
      ),
    ],
  ),
  const CrossbirdPuzzle(
    id: 'crossbird_4',
    title: 'World Birds',
    rows: 7,
    cols: 7,
    words: [
      CrossbirdWord(
        clueNumber: 1,
        direction: 'across',
        startRow: 0,
        startCol: 2,
        answer: 'QUAIL',
        clue: "Small, secretive gamebird whose call sounds like 'wet-my-lips'",
      ),
      CrossbirdWord(
        clueNumber: 1,
        direction: 'down',
        startRow: 0,
        startCol: 2,
        answer: 'QUETZAL',
        clue: "Brilliantly plumed Central American bird, sacred to the ancient Maya",
      ),
      CrossbirdWord(
        clueNumber: 2,
        direction: 'across',
        startRow: 2,
        startCol: 2,
        answer: 'EGRET',
        clue: "Elegant white heron that has made a remarkable return to British wetlands",
      ),
      CrossbirdWord(
        clueNumber: 3,
        direction: 'across',
        startRow: 4,
        startCol: 0,
        answer: 'BUZZARD',
        clue: "Britain's most common large raptor, soaring on broad, fingered wings",
      ),
      CrossbirdWord(
        clueNumber: 4,
        direction: 'across',
        startRow: 6,
        startCol: 2,
        answer: 'LOON',
        clue: "North American diving bird renowned for its eerie, haunting call",
      ),
    ],
  ),
];
