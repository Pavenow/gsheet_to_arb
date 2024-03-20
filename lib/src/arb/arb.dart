/*
 * Copyright (c) 2024, Rahmatur Ramadhan
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

class ArbDocument {
  String? locale;
  DateTime? lastModified;
  List<ArbResource>? entries;

  ArbDocument(this.locale, this.lastModified, this.entries);

  Map<String, Object> toJson({bool compact = false}) {
    final json = <String, Object>{};

    json['@@locale'] = locale!;
    json['@@last_modified'] = lastModified!.toIso8601String();

    for (var resource in entries!) {
      json[resource.key] = resource.value;
      if (resource.attributes.isNotEmpty && !compact) {
        json['@${resource.key}'] = resource.attributes;
      }
    }

    return json;
  }

  ArbDocument.fromJson(Map<String, dynamic> json) {
    var entriesMap = <String, ArbResource>{};
    entries = <ArbResource>[];

    json.forEach((key, value) {
      if ('@@locale' == key) {
        locale = value;
      } else if ('@@last_modified' == key) {
        lastModified = DateTime.parse(value);
      } else if (key.startsWith('@')) {
        var entry = entriesMap[key.substring(2)];
        entry!.attributes.addAll(value);
      } else {
        var entry = ArbResource(key, value);
        entries!.add(entry);
        entriesMap[key] = entry;
      }
    });
  }
}

class ArbResource {
  final String key;
  final String value;
  final Map<String, Object> attributes = {};
  final List<ArbResourcePlaceholder> placeholders;
  final String description;
  final String context;

  ArbResource(this.key, this.value,
      {this.description = '',
      this.context = '',
      this.placeholders = const []}) {
    // Possible values are "text", "image", "css"
    attributes['type'] = 'Text';

    if (placeholders.isNotEmpty) {
      attributes['placeholders'] = _formatPlaceholders(placeholders);
    }

    if (description.isNotEmpty) {
      attributes['description'] = description;
    }

    if (context.isNotEmpty) {
      attributes['context'] = context;
    }
  }

  Map<String, Object?> _formatPlaceholders(
      List<ArbResourcePlaceholder> placeholders) {
    final map = <String, Object?>{};

    for (var placeholder in placeholders) {
      final placeholderArgs = <String, Object>{};
      if (placeholder.type != null) {
        placeholderArgs['type'] = placeholder.type!;
      }
      map[placeholder.name!] = placeholderArgs;
    }
    return map;
  }
}

class ArbResourcePlaceholder {
  static String typeText = 'text';
  static String typeNum = 'num';

  final String? name;
  final String? type;
  final String? description;
  final String? example;

  ArbResourcePlaceholder({
    this.name,
    this.type,
    this.description,
    this.example,
  });
}

class ArbBundle {
  final List<ArbDocument> documents;

  ArbBundle(this.documents);
}

class ArbDocumentBuilder {
  String locale;
  DateTime lastModified;
  List<ArbResource> entries = [];

  ArbDocumentBuilder(this.locale, this.lastModified);

  ArbDocument build() {
    final bundle = ArbDocument(locale, lastModified, entries);
    return bundle;
  }

  ArbDocumentBuilder add(ArbResource entry) {
    entries.add(entry);
    return this;
  }
}
