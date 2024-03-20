// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a id locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'id';

  static String m0(count) =>
      "${Intl.plural(count, one: '${count} Rupiah Indonesia', other: '${count} Rupiah Indonesia')}";

  static String m1(count) =>
      "${Intl.plural(count, zero: 'Tidak ada lagu yang ditemukan.', one: 'Satu lagu ditemukan.', two: '${count} lagu ditemukan.', few: '${count} lagu ditemukan.', many: '${count} lagu ditemukan.', other: '${count} lagu ditemukan.')}";

  static String m2(name) => "Satu ${name} argumen";

  static String m3(first, second) => "Argumen ${first} dan ${second}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "amountRupiah": m0,
        "appName": MessageLookupByLibrary.simpleMessage("Contoh Aplikasi"),
        "greet": MessageLookupByLibrary.simpleMessage("halo"),
        "login": MessageLookupByLibrary.simpleMessage("Masuk"),
        "longText": MessageLookupByLibrary.simpleMessage(
            "garis a\ngaris b\ngaris c\nlorem\nipsum"),
        "message": MessageLookupByLibrary.simpleMessage("Pesan"),
        "numberOfSongsAvailable": m1,
        "register": MessageLookupByLibrary.simpleMessage("Daftar"),
        "singleArgument": m2,
        "specialCharacters":
            MessageLookupByLibrary.simpleMessage("spesial: !@#\$%^&*()"),
        "title": MessageLookupByLibrary.simpleMessage("Judul"),
        "twoArguments": m3
      };
}
