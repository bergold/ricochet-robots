library ricochetrobots;

import 'messages.dart';

class Game {
  Ruleset rules;
  GameState _state;
  List<Participant> _participants;
  
  Function _send;
  
  Game(String adminClientId);
  
  set onmessage(Function value) {
    if (_send != null) throw new UnsupportedError('Callback is already set.');
    _send = value;
  }
  
  void sendMsg(MessageBase msg) {
    
  }
  
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
    if (null == board) board = randomBoard();
  }
  
  /**
   * Generates a representation of a random board. See [Ruleset.board].
   */
  static List<int> randomBoard() {
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
  static const colorwhirl = const Chip._(0);
  static const redmoon = const Chip._(1);
  static const redgear = const Chip._(2);
  static const redplanet = const Chip._(3);
  static const redcross = const Chip._(4);
  static const bluemoon = const Chip._(5);
  static const bluegear = const Chip._(6);
  static const blueplanet = const Chip._(7);
  static const bluecross = const Chip._(8);
  static const greenmoon = const Chip._(9);
  static const greengear = const Chip._(10);
  static const greenplanet = const Chip._(11);
  static const greencross = const Chip._(12);
  static const yellowmoon = const Chip._(13);
  static const yellowgear = const Chip._(14);
  static const yellowplanet = const Chip._(15);
  static const yellowcross = const Chip._(16);
  
  static get values => [colorwhirl, redmoon, redgear, redplanet, redcross, 
      bluemoon, bluegear, blueplanet, bluecross, 
      greenmoon, greengear, greenplanet, greencross, 
      yellowmoon, yellowgear, yellowplanet, yellowcross];
  
  final int value;
  
  const Chip._(this.value);
}

class GameState {
  /// Wait, until the admin starts the game.
  static const settingup = const GameState._(0);
  /// A round is running. Nobody found a solution, yet.
  static const running = const GameState._(1);
  /// At least one player found a solution and the timer is running.
  static const underselling = const GameState._(2);
  /// The timer ended and the players are showing there ways.
  static const dissolving = const GameState._(3);
  /// The game ended. Every Chip is earned.
  static const ended = const GameState._(4);
  
  static get values => [settingup, running, underselling, dissolving, ended];
  
  final int value;
  
  const GameState._(this.value);
}
