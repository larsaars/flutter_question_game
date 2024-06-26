import 'package:flutter/material.dart';
import 'package:question_game/database/gamestate_handler.dart';
import 'package:question_game/ui/routes/game/yesno/yesno_answer.dart';
import 'package:question_game/ui/widgets/my_animated_switcher.dart';
import 'package:question_game/utils/ui_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../ui_defaults.dart';

/// A widget that represents the dialog for submitting an answer in a Yes/No game.
///
/// This widget is stateful, meaning that it has mutable state that can change over time.
/// The state is managed by [_YesNoSubmitAnswerDialogWidgetState].
class YesNoSubmitAnswerDialogWidget extends StatefulWidget {
  /// The function to set the state of the parent widget.
  final StateSetter setState;

  /// The answer object that represents the player's answer.
  final YesNoAnswer answer;

  /// The color to use for the Yes/No text and slider.
  final Color yesNoColor;

  /// Creates a new instance of [YesNoSubmitAnswerDialogWidget].
  ///
  /// The [setState], [answer], and [yesNoColor] arguments must not be null.
  const YesNoSubmitAnswerDialogWidget({
    super.key,
    required this.setState,
    required this.answer,
    required this.yesNoColor,
  });

  @override
  State<YesNoSubmitAnswerDialogWidget> createState() =>
      _YesNoSubmitAnswerDialogWidgetState();
}

/// The state for a [YesNoSubmitAnswerDialogWidget].
class _YesNoSubmitAnswerDialogWidgetState
    extends State<YesNoSubmitAnswerDialogWidget> {
  /// The localizations for the current app locale.
  AppLocalizations? localizations;

  /// A flag that indicates whether the player has answered or not.
  bool _hasAnswered = false;

  /// The number of players in the game, which is also the maximum number of answers.
  final int _numberOfPlayers =
      GameStateHandler.currentGameState?.players.length ?? 0;

  @override
  Widget build(BuildContext context) {
    localizations ??= AppLocalizations.of(context);

    // get side padding of the dialog
    // for that use the default scaffold padding method
    // and use only the horizontal value
    final [horizontalPadding, verticalPadding] =
        UIUtils.determinePadding(context);

    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      shape: RoundedRectangleBorder(
        // set dialog to have no border radius if padding is 0
        borderRadius: horizontalPadding == 0 ? BorderRadius.zero : BorderRadius.circular(50.0),
      ),
      child: Center(
        child: MyAnimatedSwitcher(
          transitionType: MyAnimatedSwitcherTransitionType.fade,
          child: _hasAnswered
              ? Stack(
                  key: const ValueKey(1),
                  children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new),
                            onPressed: () {
                              // go back to the yes/no choice screen
                              widget.setState(() => _hasAnswered = false);
                            },
                          ),
                        )),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: UIDefaults.defaultIconSize,
                          bottom: UIDefaults.defaultButtonHeight,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              localizations!.gameYesNoYourGuess,
                              style: UIDefaults.gameBodyTextStyle,
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              widget.answer.guess.toString(),
                              style: TextStyle(
                                fontFamily: 'alte_haas_grotesk',
                                fontSize: UIDefaults.gameTitleTextSize,
                                color: widget.yesNoColor,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const SizedBox(width: 8.0),
                                Text(
                                  '0',
                                  style: TextStyle(
                                    color: widget.yesNoColor,
                                    fontSize: 24.0,
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                Expanded(
                                  child: Slider(
                                    activeColor: widget.yesNoColor,
                                    thumbColor: widget.yesNoColor,
                                    value: widget.answer.guess.toDouble(),
                                    onChanged: (value) {
                                      widget.setState(() {
                                        widget.answer.guess = value.toInt();
                                      });
                                    },
                                    min: 0,
                                    max: _numberOfPlayers.toDouble(),
                                    divisions: _numberOfPlayers + 1,
                                  ),
                                ),
                                Text(
                                  _numberOfPlayers.toString(),
                                  style: TextStyle(
                                    color: widget.yesNoColor,
                                    fontSize: 24.0,
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton(
                          key: const ValueKey(99),
                          child: const Icon(Icons.check),
                          onPressed: () {
                            // mark in object that the player has answered and update parent state (is done in the parent)
                            widget.answer.hasAnswered = true;
                            // close the dialog
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  key: const ValueKey(2),
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      GameStateHandler
                              .currentGameState?.currentQuestion?.value ??
                          '',
                      style: UIDefaults.gameBodyTextStyle,
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            widget.answer.answer = true;
                            widget.setState(() => _hasAnswered = true);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              localizations!.yes,
                              style: TextStyle(
                                  fontSize: UIDefaults.gameBodyTextSize,
                                  color: widget.yesNoColor),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        ElevatedButton(
                          onPressed: () {
                            widget.answer.answer = false;
                            widget.setState(() => _hasAnswered = true);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              localizations!.no,
                              style: UIDefaults.gameBodyTextStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}