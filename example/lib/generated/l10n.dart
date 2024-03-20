// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by aut0run
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class ExampleLang {
  ExampleLang();

  static ExampleLang? _current;

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static ExampleLang get current {
    assert(_current != null,
        'No instance of ExampleLang was loaded. Try to initialize the ExampleLang delegate before accessing ExampleLang.current.');
    return _current!;
  }

  static Future<ExampleLang> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = ExampleLang();
      ExampleLang._current = instance;
      return instance;
    });
  }

  static ExampleLang of(BuildContext context) {
    final instance = ExampleLang.maybeOf(context);
    assert(instance != null,
        'No instance of ExampleLang present in the widget tree. Did you add ExampleLang.delegate in localizationsDelegates?');
    return instance!;
  }

  static ExampleLang? maybeOf(BuildContext context) {
    return Localizations.of<ExampleLang>(context, ExampleLang);
  }

  /// contains title
  String get title =>
      Intl.message('Title', name: 'title', desc: 'contains title');

  /// contains message
  String get message =>
      Intl.message('Message', name: 'message', desc: 'contains message');

  /// contains app name
  String get appName => Intl.message('Sample Application',
      name: 'appName', desc: 'contains app name');

  /// contains login
  String get login =>
      Intl.message('Login', name: 'login', desc: 'contains login');

  /// contains registration
  String get register =>
      Intl.message('Register', name: 'register', desc: 'contains registration');

  /// number of songs plural
  String numberOfSongsAvailable(int count) => Intl.plural(count,
      zero: 'No songs found.',
      one: 'One song found.',
      two: ' songs found.',
      few: ' songs found.',
      other: ' song found.',
      many: ' songs found.',
      name: 'numberOfSongsAvailable',
      args: [count],
      desc: 'number of songs plural');

  /// currency rupiah
  String amountRupiah(int count) => Intl.plural(count,
      one: ' Indonesian Rupiah',
      other: ' Indonesian Rupiah',
      name: 'amountRupiah',
      args: [count],
      desc: 'currency rupiah');

  /// test special characters
  String get specialCharacters => Intl.message('special: !@#\$%^&*()',
      name: 'specialCharacters', desc: 'test special characters');

  /// Single named argument
  String singleArgument(String name) => Intl.message('Single  argument',
      name: 'singleArgument', args: [name], desc: 'Single named argument');

  /// Two named arguments
  String twoArguments(
    String first,
    String second,
  ) =>
      Intl.message('Argument  and ',
          name: 'twoArguments',
          args: [first, second],
          desc: 'Two named arguments');

  /// long
  /// description
  ///
  /// new
  /// line
  String get longText => Intl.message('line a\nline b\nline c\nlorem\nipsum',
      name: 'longText', desc: 'long\ndescription\n\nnew\nline');

  /// greetings
  String get greet => Intl.message('hallo', name: 'greet', desc: 'greetings');
}

class AppLocalizationDelegate extends LocalizationsDelegate<ExampleLang> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'id'),
      Locale.fromSubtags(languageCode: 'pl'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);

  @override
  Future<ExampleLang> load(Locale locale) => ExampleLang.load(locale);

  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
