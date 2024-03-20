import 'parser/translation_parser.dart';
import 'utils/log.dart';

import 'arb/arb_serializer.dart';
import 'config/plugin_config.dart';
import 'dart/arb_to_dart_generator.dart';
import 'gsheet/ghseet_importer.dart';

class GSheetToArb {
  final GsheetToArbConfig config;

  final _arbSerializer = ArbSerializer();

  GSheetToArb({required this.config});

  void build() async {
    Log.i('Building translation...');
    Log.startTimeTracking();

    final gsheet = config.gsheet;
    final documentId = gsheet!.documentId;

    // import TranslationsDocument
    final importer = GSheetImporter(config: gsheet);
    final document = await importer.import(documentId!);

    // Parse TranslationsDocument to ArbBundle
    final sheetParser =
        TranslationParser(addContextPrefix: config.addContextPrefix ?? false);
    final arbBundle = await sheetParser.parseDocument(document);

    // Save ArbBundle
    _arbSerializer.saveArbBundle(
        arbBundle, config.arbDirectoryPath ?? "lib/l10n");

    // Generate Code from ArbBundle
    if (config.generateCode!) {
      final generator = ArbToDartGenerator();
      generator.generateDartClasses(
        arbBundle,
        config.arbDirectoryPath ?? "lib/l10n",
        config.outputDirectoryPath ?? "lib/generated",
        config.localizationFileName ?? "l10n",
      );
    }

    Log.i('Succeeded after ${Log.stopTimeTracking()}');
  }
}
