import 'dart:developer';

import 'package:my_botc_notes/data/characters.dart';
import 'package:my_botc_notes/models/character.dart';
import 'package:my_botc_notes/models/custom_info_token.dart';
import 'package:my_botc_notes/models/game_setup.dart';
import 'package:my_botc_notes/models/info_token.dart';
import 'package:my_botc_notes/models/player.dart';
import 'package:my_botc_notes/models/reminder.dart';
import 'package:my_botc_notes/models/script.dart';

class GameSession {
  GameSession({
    required this.gameSetup,
    required this.script,
    required this.players,
    this.isStorytellerMode = false,
    this.demonBluffs,
    this.lunaticBluffs,
  });

  final GameSetup gameSetup;
  final Script script;
  final List<Player> players;
  List<Character?>? demonBluffs;
  List<Character?>? lunaticBluffs;

  bool isStorytellerMode;

  String gamePhase = 'N1';

  String? _notes;
  String? _playerInfoToken;
  List<CustomInfoToken>? _customInfoTokensSimplified;
  Character? _fabled;

  String? get notes {
    return _notes;
  }

  String? get playerInfoToken {
    return _playerInfoToken;
  }

  List<CustomInfoToken>? get customInfoTokensSimplified {
    return _customInfoTokensSimplified;
  }

  List<InfoToken>? get customInfoTokens {
    if (_customInfoTokensSimplified == null) {
      return null;
    }
    return _customInfoTokensSimplified!
        .map((token) => InfoToken(
              id: token.text.length > 10
                  ? token.text.substring(0, 8)
                  : token.text,
              label: token.text,
              regularPart1: token.text,
              bold: '',
              regularPart2: '',
              tokenSlots: token.tokenSlotsNumber != null
                  ? List.generate(token.tokenSlotsNumber!, (index) => null)
                  : null,
            ))
        .toList();
  }

  Character? get fabled {
    return _fabled;
  }

  int get numberOfPlayers {
    return players.length;
  }

  List<String> get inPlayCharactersIds {
    if (!isStorytellerMode) {
      return [];
    }

    final List<String> ids = [];
    for (final player in players) {
      if (player.characterId != null) {
        ids.add(player.characterId!);
      }
    }
    return ids;
  }

  List<String> get alivePlayersCharactersIds {
    if (!isStorytellerMode) {
      return [];
    }

    final List<String> ids = [];
    for (final player in players) {
      if (player.characterId != null && !player.isDead) {
        ids.add(player.characterId!);
      }
    }
    return ids;
  }

  List<String> get alivePlayersWithoutAbilityCharactersIds {
    if (!isStorytellerMode) {
      return [];
    }

    final List<String> ids = [];
    for (final player in players) {
      final character = player.characterId == null
          ? null
          : sessionCharacters
              .where((character) => character.id == player.characterId)
              .first;

      if (character != null &&
          character.reminders != null &&
          character.reminders!.any((reminder) => reminder == 'No ability') &&
          player.reminders != null &&
          player.reminders!
              .any((reminder) => reminder.reminder == 'No ability')) {
        ids.add(player.characterId!);
      }
    }

    return ids;
  }

  List<Character> get sessionCharacters {
    final additionalCharactersIds = inPlayCharactersIds
        .where((characterId) => !script.charactersIds.contains(characterId))
        .toList();
    final additionalCharacters = additionalCharactersIds
        .map((characterId) => charactersMap[characterId]!)
        .toList();

    return [...script.characters, ...additionalCharacters];
  }

  List<Reminder> get reminders {
    final remindersLists = sessionCharacters.map<List<Reminder>>((character) {
      final reminders =
          character.reminders == null || character.reminders!.isEmpty
              ? []
              : character.reminders!
                  .map<Reminder>((reminder) => Reminder(
                        tokenId: character.id,
                        reminder: reminder,
                      ))
                  .toList();

      final remindersGlobal = character.remindersGlobal == null ||
              character.remindersGlobal!.isEmpty
          ? []
          : character.remindersGlobal!
              .map<Reminder>((reminder) => Reminder(
                    tokenId: character.id,
                    reminder: reminder,
                  ))
              .toList();

      return [...reminders, ...remindersGlobal];
    }).toList();

    final reminders =
        remindersLists.where((reminders) => reminders.isNotEmpty).toList();

    return reminders.expand<Reminder>((item) => item).toList();
  }

  int get numberOfGhostVotes {
    return players
        .where((player) => player.isDead && player.hasGhostVote)
        .length;
  }

  int get numberOfAlivePlayers {
    return players.where((player) => !player.isDead).length;
  }

  int get numberOfVotesRequiredToExecute {
    return (numberOfAlivePlayers / 2).ceil();
  }

  set setGamePhase(String newGamePhase) {
    gamePhase = newGamePhase;
  }

  set setNotes(String notes) {
    _notes = notes;
  }

  set setPlayerInfoToken(String infoToken) {
    _playerInfoToken = infoToken;
  }

  set setCustomInfoTokensSimplified(List<CustomInfoToken> infoTokens) {
    _customInfoTokensSimplified = infoTokens;
  }

  set setFabled(Character fabled) {
    _fabled = fabled;
  }

  set setDemonBluffs(List<Character?> updatedDemonBluffs) {
    demonBluffs = updatedDemonBluffs;
  }

  set setLunaticBluffs(List<Character?> updatedLunaticBluffs) {
    lunaticBluffs = updatedLunaticBluffs;
  }

  set setsStorytellerMode(bool newIsStorytellerMode) {
    isStorytellerMode = newIsStorytellerMode;
  }

  GameSession.fromJson(Map<String, dynamic> json)
      : gameSetup = GameSetup.fromJson(json['gameSetup']),
        players = List.from(json['players'])
            .map((item) => Player.fromJson(item))
            .toList(),
        script = Script.fromJson(json['script']),
        gamePhase = json['gamePhase'],
        _notes = json['notes'] as String?,
        _playerInfoToken = json['infoToken'] as String?,
        _customInfoTokensSimplified = json['customInfoTokensSimplified'] != null
            ? List.from(json['customInfoTokensSimplified'])
                .map((item) => CustomInfoToken.fromJson(item))
                .toList()
            : null,
        _fabled =
            json['fabled'] == null ? null : Character.fromJson(json['fabled']),
        isStorytellerMode = json['isStorytellerMode'] as bool,
        demonBluffs = json['demonBluffs'] == null
            ? null
            : List.from(json['demonBluffs'])
                .map((item) => item == null ? null : Character.fromJson(item))
                .toList(),
        lunaticBluffs = json['lunaticBluffs'] == null
            ? null
            : List.from(json['lunaticBluffs'])
                .map((item) => item == null ? null : Character.fromJson(item))
                .toList();

  Map<String, dynamic> toJson() {
    return {
      'gameSetup': gameSetup.toJson(),
      'players': players.map((player) => player.toJson()).toList(),
      'script': script.toJson(),
      'gamePhase': gamePhase,
      'notes': notes,
      'fabled': fabled,
      'infoToken': playerInfoToken,
      'customInfoTokensSimplified':
          customInfoTokensSimplified?.map((token) => token.toJson()).toList(),
      'isStorytellerMode': isStorytellerMode,
      'demonBluffs':
          demonBluffs?.map((character) => character?.toJson()).toList(),
      'lunaticBluffs':
          lunaticBluffs?.map((character) => character?.toJson()).toList(),
    };
  }
}