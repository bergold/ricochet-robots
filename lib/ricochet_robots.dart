
library ricochet_robots;


class Game {
  final Ruleset rules;
  GameState _state;
  List<Participant> _participants;
  
  /**
   * Creates a new game with an admin user and a specified [Ruleset]
   */
  Game(Participant admin, this.rules) {
    if (!admin.isAdmin) throw 'user is no admin';
    _participants.add(admin);
  }
  
  void join(Participant participant) {
    if (_state != GameState.WAITING) throw 'Could not join: Game is already running!';
    if (participant.isAdmin) throw 'Could not join: Participant must not be admin';
    _participants.add(participant);
  }
  
  void leave() {}
  
  void start() {}
  
}

class User {
  final String clientid;
  String username;
  
  User(this.clientid);
  
  
}

class Participant extends User {
  final bool isAdmin;
  List<Chip> earned = new List<Chip>();
  
  Participant(clientid)
      : isAdmin = false, 
        super(clientid);
  Participant.asAdmin(clientid)
      : isAdmin = true,
        super(clientid);
  
  void earn(Chip Chip) {
    earned.add(Chip);
  }
  
}

/**
 * Saves final information about a game, like the board, extra rules...
 */
class Ruleset {
  /// A board has 4 panels with two sides.
  static final List<List<int>> boardsegments = [[0, 4], [1, 5], [2, 6], [3, 7]];
  /// A List of the length 4. Each field represents one panel from top-left to bottom-right.
  var board;
  
  Ruleset({board: null}) {
    if (null == board) board = randomBoard;
  }
  
  /**
   * Generates a representation of a random board. See [Ruleset.board].
   */
  List<int> get randomBoard {
    List bscopy = new List.from(boardsegments);
    List b = new List();
    bscopy..shuffle()
          ..forEach((_) {
            List sub = new List.from(_);
            sub.shuffle();
            b.add(sub[0]);
          });
    return b.getRange(0, 4);
  }
}

class Chip {
  /// All Chips that could be earned.
  /// There are 4 colors and in each color 4 symbols plus one extra multi-color whirl.
  static const COLORWHIRL = const Chip._(0);
  static const REDMOON = const Chip._(1);
  static const REDGEAR = const Chip._(2);
  static const REDPLANET = const Chip._(3);
  static const REDCROSS = const Chip._(4);
  static const BLUEMOON = const Chip._(5);
  static const BLUEGEAR = const Chip._(6);
  static const BLUEPLANET = const Chip._(7);
  static const BLUECROSS = const Chip._(8);
  static const GREENMOON = const Chip._(9);
  static const GREENGEAR = const Chip._(10);
  static const GREENPLANET = const Chip._(11);
  static const GREENCROSS = const Chip._(12);
  static const YELLOWMOON = const Chip._(13);
  static const YELLOWGEAR = const Chip._(14);
  static const YELLOWPLANET = const Chip._(15);
  static const YELLOWCROSS = const Chip._(16);
  
  static get values => [COLORWHIRL, REDMOON, REDGEAR, REDPLANET, REDCROSS, 
      BLUEMOON, BLUEGEAR, BLUEPLANET, BLUECROSS, 
      GREENMOON, GREENGEAR, GREENPLANET, GREENCROSS, 
      YELLOWMOON, YELLOWGEAR, YELLOWPLANET, YELLOWCROSS];
  
  final int value;
  
  const Chip._(this.value);
}

class GameState {
  /// Wait, until the admin starts the game.
  static const WAITING = const GameState._(0);
  /// A round is running. Nobody found a solution, yet.
  static const SEARCHING = const GameState._(1);
  /// At least one player found a solution and the timer is running.
  static const UNDERSELLING = const GameState._(2);
  /// The timer ended and the players are showing there ways.
  static const DISSOLVING = const GameState._(3);
  /// The game ended. Every Chip is earned.
  static const ENDED = const GameState._(4);
  
  static get values => [WAITING, SEARCHING, UNDERSELLING, DISSOLVING, ENDED];
  
  final int value;
  
  const GameState._(this.value);
}
