import 'package:flutter/material.dart';
import 'package:question_game/database/gamestate_handler.dart';
import 'package:question_game/ui/widgets/centered_text_icon_button.dart';
import 'package:question_game/ui/widgets/default_scaffold.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../ui_defaults.dart';

class GameSelectionPage extends StatelessWidget {
  const GameSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    bool hasMoreThanOneSavedGameStates =
        GameStateHandler.getSavedGameStatesCount() > 1;

    return DefaultScaffold(
      child: Center(
        child: IntrinsicWidth(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CenteredTextIconButton(
                icon: Icons.fiber_new,
                text: loc!.gameSelectionPageNewGame,
                textColor: UIDefaults.colorPrimary,
                iconColor: UIDefaults.colorPrimary,
                onPressed: () {
                  // load new game state and then navigate to
                  // enter the player names
                  GameStateHandler.playNewGame();
                  Navigator.pushReplacementNamed(context, '/current-players');
                },
              ),
              CenteredTextIconButton(
                icon: Icons.last_page,
                text: loc.gameSelectionPageContinueLastGame,
                onPressed: () {
                  // load last game state and then navigate to game
                  GameStateHandler.playLastGame();
                  Navigator.pushReplacementNamed(context, '/game');
                },
              ),
              if (hasMoreThanOneSavedGameStates)
                CenteredTextIconButton(
                  icon: Icons.list,
                  text: loc.gameSelectionPageChooseOldGame,
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/old-games-list'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
