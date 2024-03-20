import 'package:code_builder/code_builder.dart';

ClassBuilder langTemplates(ClassBuilder builder, String className) {
  builder.name = className;
  builder.docs.add("""\n\n
// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by aut0run
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes
""");
  builder.constructors.add(Constructor());
  builder.fields.add(
    Field((b) => b
      ..static = true
      ..type = Reference("$className?")
      ..name = "_current"),
  );
  builder.fields.add(
    Field((b) => b
      ..static = true
      ..modifier = FieldModifier.constant
      ..type = const Reference("AppLocalizationDelegate")
      ..name = "delegate"
      ..assignment = const Code("AppLocalizationDelegate()")),
  );
  builder.methods.add(
    Method((b) => b
      ..static = true
      ..returns = Reference(className)
      ..type = MethodType.getter
      ..name = "current"
      ..body = Code(
          "assert(_current != null, 'No instance of $className was loaded. Try to initialize the $className delegate before accessing $className.current.');\nreturn _current!;")),
  );
  builder.methods.add(
    Method((b) => b
      ..static = true
      ..returns = Reference("Future<$className>")
      ..name = "load"
      ..requiredParameters.add(Parameter((b) => b
        ..type = const Reference("Locale")
        ..name = "locale"))
      ..body = Code("""
final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = $className();
      $className._current = instance;
      return instance;
    });
"""
          .trim())),
  );
  builder.methods.add(
    Method((b) => b
      ..static = true
      ..returns = Reference(className)
      ..name = "of"
      ..requiredParameters.add(Parameter((b) => b
        ..type = const Reference("BuildContext")
        ..name = "context"))
      ..body = Code("""
final instance = $className.maybeOf(context);
    assert(instance != null, 'No instance of $className present in the widget tree. Did you add $className.delegate in localizationsDelegates?');
    return instance!;
"""
          .trim())),
  );
  builder.methods.add(
    Method((b) => b
      ..static = true
      ..returns = Reference("$className?")
      ..name = "maybeOf"
      ..requiredParameters.add(Parameter((b) => b
        ..type = const Reference("BuildContext")
        ..name = "context"))
      ..body =
          Code("return Localizations.of<$className>(context, $className);")),
  );
  return builder;
}

ClassBuilder delegateTemplates(
        ClassBuilder builder, List<String> locales, String className) =>
    builder
      ..name = "AppLocalizationDelegate"
      ..extend = refer('LocalizationsDelegate<$className>')
      ..constructors.add(Constructor((b) => b..constant = true))
      ..methods.addAll([
        Method(
          (b) => b
            ..returns = const Reference("List<Locale>")
            ..type = MethodType.getter
            ..name = "supportedLocales"
            ..body = Code("""
                            return const <Locale>[
                              ${locales.map((locale) => _generateLocale(locale)).join("\n")}
                            ];  
                          """
                .trim()),
        ),
        Method(
          (b) => b
            ..returns = const Reference("@override\n bool")
            ..name = "isSupported"
            ..requiredParameters.add(Parameter((b) => b
              ..type = const Reference("Locale")
              ..name = "locale"))
            ..lambda = true
            ..body = const Code("_isSupported(locale)"),
        ),
        Method(
          (b) => b
            ..returns = Reference("@override\n Future<$className>")
            ..name = "load"
            ..requiredParameters.add(Parameter((b) => b
              ..type = const Reference("Locale")
              ..name = "locale"))
            ..lambda = true
            ..body = Code("$className.load(locale)"),
        ),
        Method(
          (b) => b
            ..returns = const Reference("@override\n bool")
            ..name = "shouldReload"
            ..requiredParameters.add(Parameter((b) => b
              ..type = const Reference("AppLocalizationDelegate")
              ..name = "old"))
            ..lambda = true
            ..body = const Code("false"),
        ),
        Method(
          (b) => b
            ..returns = const Reference("bool")
            ..name = "_isSupported"
            ..requiredParameters.add(Parameter((b) => b
              ..type = const Reference("Locale")
              ..name = "locale"))
            ..body = Code("""
                        for (var supportedLocale in supportedLocales) {
                          if (supportedLocale.languageCode == locale.languageCode) {
                            return true;
                          }
                        } 
                        return false;
                    """
                .trim()),
        )
      ]);

String _generateLocale(String locale) {
  var parts = locale.split('_');

  if (isLangScriptCountryLocale(locale)) {
    return '      Locale.fromSubtags(languageCode: \'${parts[0]}\', scriptCode: \'${parts[1]}\', countryCode: \'${parts[2]}\'),';
  } else if (isLangScriptLocale(locale)) {
    return '      Locale.fromSubtags(languageCode: \'${parts[0]}\', scriptCode: \'${parts[1]}\'),';
  } else if (isLangCountryLocale(locale)) {
    return '      Locale.fromSubtags(languageCode: \'${parts[0]}\', countryCode: \'${parts[1]}\'),';
  } else {
    return '      Locale.fromSubtags(languageCode: \'${parts[0]}\'),';
  }
}

bool isLangScriptCountryLocale(String locale) =>
    RegExp(r'^[a-z]{2,3}_[A-Z][a-z]{3}_([A-Z]{2}|[0-9]{3})$').hasMatch(locale);

bool isLangScriptLocale(String locale) =>
    RegExp(r'^[a-z]{2,3}_[A-Z][a-z]{3}$').hasMatch(locale);

bool isLangCountryLocale(String locale) =>
    RegExp(r'^[a-z]{2,3}_([A-Z]{2}|[0-9]{3})$').hasMatch(locale);
