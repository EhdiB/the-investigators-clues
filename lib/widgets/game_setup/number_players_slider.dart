import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_botc_notes/constants.dart';
import 'package:my_botc_notes/models/game_setup.dart';
import 'package:my_botc_notes/widgets/game_setup/game_setup_teams.dart';
import 'package:my_botc_notes/widgets/ui/number_slider.dart';

class NumberPlayersSlider extends StatelessWidget {
  const NumberPlayersSlider({
    super.key,
    required this.numberOfPlayers,
    required this.gameSetup,
    required this.onUpdatePlayersNumber,
  });

  final double numberOfPlayers;
  final GameSetup gameSetup;
  final Function(double) onUpdatePlayersNumber;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              t.numberOfPlayers,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(
              width: 8,
            ),
            GameSetupTeams(gameSetup: gameSetup)
          ],
        ),
        NumberSlider(
          value: numberOfPlayers,
          onChange: onUpdatePlayersNumber,
          min: kMinNumberPlayers,
          max: kMaxNumberPlayers,
        ),
      ],
    );
  }
}