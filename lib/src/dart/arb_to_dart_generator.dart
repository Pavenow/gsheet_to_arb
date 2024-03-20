/*
 * Copyright (c) 2024, Rahmatur Ramadhan
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

import 'dart:io';

import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import '../arb/arb.dart';
import '../utils/log.dart';
import '_icu_parser.dart';
import '_intl_translation_generator.dart';
import 'package:intl_translation/src/messages/message.dart';
import 'package:intl_translation/src/messages/literal_string_message.dart';
import 'package:intl_translation/src/messages/submessages/plural.dart';
import 'package:intl_translation/src/messages/composite_message.dart';

import 'package:petitparser/petitparser.dart';

import 'templates.dart';

class ArbToDartGenerator {
  final intlTranslation = IntlTranslationGenerator();

  void generateDartClasses(
    ArbBundle bundle,
    String arbDirectoryPath,
    String outputDirectoryPath,
    String className, {
    bool? addContextPrefix,
  }) {
    Log.i('Genrating Dart classes from ARB...');
    Log.startTimeTracking();

    _buildIntlListFile(bundle, outputDirectoryPath, className);

    intlTranslation.generateLookupTables(
      arbDirectoryPath,
      outputDirectoryPath,
      className,
    );
    Log.i(
        'Genrating Dart classes from ARB completed, took ${Log.stopTimeTracking()}');
  }

  void _buildIntlListFile(
      ArbBundle bundle, String directory, String className) {
    var translationClass = Class((ClassBuilder builder) {
      langTemplates(builder, className);
      bundle.documents.first.entries!.forEach((ArbResource entry) {
        var method = _getResourceMethod(entry);
        builder.methods.add(method);
      });
    });
    var delegateClass = Class(
      (ClassBuilder builder) => delegateTemplates(
        builder,
        bundle.documents.map((e) => e.locale!).toList(),
        className,
      ),
    );

    final library = Library((LibraryBuilder builder) {
      builder.comments.add("GENERATED CODE - DO NOT MODIFY BY HAND");
      builder.directives.addAll([
        Directive.import('package:flutter/material.dart'),
        Directive.import('package:intl/intl.dart'),
        Directive.import('intl/messages_all.dart')
      ]);
      builder.body.addAll([
        translationClass,
        delegateClass,
      ]);
    });

    final emitter = DartEmitter(allocator: Allocator.simplePrefixing());
    final emitted = library.accept(emitter);
    final formatted = DartFormatter().format('${emitted}');

    final file = File('${directory}/l10n.dart');
    file.createSync();
    file.writeAsStringSync(formatted);
  }

  Method _getResourceMethod(ArbResource resource) {
    return Method((MethodBuilder builder) {
      final key = resource.key;
      final docs = _fixSpecialCharacters(
              resource.attributes['description'] == null
                  ? ''
                  : (resource.attributes['description'] as String))!
          .replaceAll('\\n', '\n/// ');

      final methodName = key;
      // (addContextPrefix ? '${resource.context.toLowerCase()}_' : '') + ReCase(key).camelCase;

      builder
        ..name = methodName
        ..returns = const Reference('String')
        ..lambda = true
        ..docs.add('/// ${docs}');

      if (resource.placeholders.isNotEmpty) {
        return _getResourceFullMethod(resource, builder);
      } else {
        return _getResourceGetter(resource, builder);
      }
    });
  }

  void _getResourceFullMethod(ArbResource resource, MethodBuilder builder) {
    final key = resource.key;
    final value = _escapeString(resource.value);
    final description = _escapeString(resource.attributes['description'] == null
        ? ''
        : (resource.attributes['description'] as String));

    var args = <String>[];
    resource.placeholders.forEach((ArbResourcePlaceholder placeholder) {
      builder.requiredParameters.add(Parameter((ParameterBuilder builder) {
        args.add(placeholder.name!);
        final argumentType = placeholder.type == ArbResourcePlaceholder.typeNum
            ? 'int'
            : 'String';
        builder
          ..name = placeholder.name!
          ..type = Reference(argumentType);
      }));
    });

    builder
      ..body = Code(
          _getCode(value!, key: key, args: args, description: description!));
  }

  void _getResourceGetter(ArbResource resource, MethodBuilder builder) {
    final key = resource.key;
    final value = _escapeString(resource.value);
    final description = _escapeString(resource.attributes['description'] == null
        ? key
        : (resource.attributes['description'] as String));

    builder
      ..type = MethodType.getter
      ..body = Code(
          '''Intl.message('${value}', name: '${key}', desc: '${description}')''');
  }

  ///
  /// intl_translation
  ///
  final Parser<dynamic> _pluralParser = CustomIcuParser().message;
  final Parser<dynamic> _plainParser = CustomIcuParser().nonIcuMessage;

  String _getCode(String value,
      {required String key, required String description, required List args}) {
    Message message = _pluralParser.parse(value).value;
    if (message is LiteralString && message.string.isEmpty) {
      message = _plainParser.parse(value).value;
    }
    if (message is Plural) {
      final pluralBuilder = StringBuffer();
      pluralBuilder.write('Intl.plural(count,');
      void addIfNotNull(String key, Message? message) {
        if (message != null) {
          final val = _getMessageCode(message);
          pluralBuilder.write('$key:\'$val\',');
        }
      }

      addIfNotNull('zero', message.zero);
      addIfNotNull('one', message.one);
      addIfNotNull('two', message.two);
      addIfNotNull('few', message.few);
      addIfNotNull('other', message.other);
      addIfNotNull('many', message.many);

      pluralBuilder.write(
        'name: \'${key}\',',
      );
      pluralBuilder.write(
        'args: [${args.join(", ")}],',
      );
      pluralBuilder.write(
        'desc: \'${description}\'',
      );
      pluralBuilder.write(')');

      final code = pluralBuilder.toString();

      return code;
    }
    final code = _getMessageCode(message);
    return """Intl.message('${code}', name: '$key', args: [${args.join(", ")}], desc: '${description}')""";
  }

  String _getMessageCode(Message message) {
    final builder = StringBuffer();

    if (message is LiteralString) {
      return message.string;
    }

    if (message is CustomVariableSubstitution) {
      return '\$${message.variableName}';
    }

    if (message is Plural) {}

    if (message is CompositeMessage) {
      return _getComositeMessageCode(message);
    }

    return builder.toString();
  }

  String _getComositeMessageCode(CompositeMessage composite) {
    final builder = StringBuffer();
    for (var message in composite.pieces) {
      builder.write(_getMessageCode(message));
    }
    return builder.toString();
  }

  String? _fixSpecialCharacters(String? value) {
    if (value == null) {
      return value;
    }
    return value.replaceAll('\n', '\\n');
  }
}

const int _ASCII_END = 0x7f;
const int _ASCII_START = 0x0;
const int _UNICODE_END = 0x10ffff;
const int _C0_START = 0x00;
const int _C0_END = 0x1f;

String? _escapeString(String? string) {
  if (string == null) {
    return null;
  }

  if (string.isEmpty) {
    return string;
  }

  var sb = StringBuffer();
  var i = 0;
  for (var c in string.runes) {
    if (c >= _C0_START && c <= _C0_END) {
      switch (c) {
        case 9:
          sb.write('\\t');
          break;
        case 10:
          sb.write('\\n');
          break;
        case 13:
          sb.write('\\r');
          break;
        default:
          sb.write(toUnicode(c));
      }
    } else if (c >= _ASCII_START && c <= _ASCII_END) {
      switch (c) {
        case 34:
          sb.write('\\\"');
          break;
        case 36:
          sb.write('\\\$');
          break;
        case 39:
          sb.write("\\\'");
          break;
        case 92:
          sb.write('\\\\');
          break;
        default:
          sb.write(string[i]);
      }
    } else if (_isPrintable(c)) {
      sb.write(string[i]);
    } else {
      sb.write(toUnicode(c));
    }

    i++;
  }

  return sb.toString();
}

String toUnicode(int? charCode) {
  if (charCode == null || charCode < 0 || charCode > _UNICODE_END) {
    throw ArgumentError('charCode: $charCode');
  }

  var hex = charCode.toRadixString(16);
  var length = hex.length;
  if (length < 4) {
    hex = hex.padLeft(4, '0');
  }

  return '\\u$hex';
}

bool _isPrintable(int character) {
  return true;
}
