import 'package:flutter/foundation.dart';

class EnumUtils {
  static K enumDecode<K, String>(
    List<dynamic> enumEntries,
    Object? source, {
    K? unknownValue,
  }) {
    Map<K, String> enumValues = Map<K, String>.fromIterable(enumEntries,
        key: (enumEntry) => enumEntry,
        value: (enumEntry) => describeEnum(enumEntry) as String);

    if (source == null) {
      throw ArgumentError(
        'A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}',
      );
    }

    return enumValues.entries.singleWhere(
      (e) => e.value == source,
      orElse: () {
        if (unknownValue == null) {
          throw ArgumentError(
            '`$source` is not one of the supported values: '
            '${enumValues.values.join(', ')}',
          );
        }
        return MapEntry(unknownValue, enumValues.values.first);
      },
    ).key;
  }
}
