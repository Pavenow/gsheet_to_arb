import 'package:intl/intl.dart';

import 'generated/intl/messages_all.dart';
import 'generated/l10n.dart';

void main() async {
  print('MAIN');

  Intl.defaultLocale = 'id';
  await initializeMessages(Intl.defaultLocale ?? "en");

  final l10n = ExampleLang();

  print(l10n.title);
  print(l10n.login);
  print(l10n.singleArgument('arg'));
  print(l10n.twoArguments('arg1', 'arg2'));

  // plurals
  print(l10n.numberOfSongsAvailable(0));
  print(l10n.numberOfSongsAvailable(1));
  print(l10n.numberOfSongsAvailable(2));
  print(l10n.numberOfSongsAvailable(5));
  print(l10n.numberOfSongsAvailable(10));
}
