import 'package:dbus/dbus.dart';

import 'model/enums.dart';
import 'model/hint.dart';

/// Helper method for validating notification IDs.
/// Ensures IDs are valid 32-bit integers.
// TODO(proninyaroslav): temp solution
void validateId(int id) {
  ArgumentError.checkNotNull(id, 'id');
  if (id > 0x7FFFFFFF || id < -0x80000000) {
    throw ArgumentError.value(id, 'id',
        'must fit within the size of a 32-bit integer i.e. in the range [-2^31, 2^31 - 1]'); // ignore: lines_longer_than_80_chars
  }
}

/// [LinuxHintValue] utils.
extension LinuxHintValueExtension on LinuxHintValue {
  /// Convert value to [DBusValue].
  DBusValue toDBusValue() {
    switch (type) {
      case LinuxHintValueType.array:
        final List<LinuxHintValue> l = value as List<LinuxHintValue>;
        return DBusArray(
          l.first.toDBusValue().signature,
          l.map((LinuxHintValue v) => v.toDBusValue()),
        );
      case LinuxHintValueType.boolean:
        return DBusBoolean(value);
      case LinuxHintValueType.byte:
        return DBusByte(value);
      case LinuxHintValueType.dict:
        final Map<LinuxHintValue, LinuxHintValue> m =
            value as Map<LinuxHintValue, LinuxHintValue>;
        return DBusDict(
          m.keys.first.toDBusValue().signature,
          m.values.first.toDBusValue().signature,
          m.map(
            (LinuxHintValue key, LinuxHintValue value) =>
                MapEntry<DBusValue, DBusValue>(
              key.toDBusValue(),
              value.toDBusValue(),
            ),
          ),
        );
      case LinuxHintValueType.double:
        return DBusDouble(value);
      case LinuxHintValueType.int16:
        return DBusInt16(value);
      case LinuxHintValueType.int32:
        return DBusInt32(value);
      case LinuxHintValueType.int64:
        return DBusInt64(value);
      case LinuxHintValueType.string:
        return DBusString(value);
      case LinuxHintValueType.struct:
        return DBusStruct(
          (value as List<LinuxHintValue>).map(
            (LinuxHintValue v) => v.toDBusValue(),
          ),
        );
      case LinuxHintValueType.uint16:
        return DBusUint16(value);
      case LinuxHintValueType.uint32:
        return DBusUint32(value);
      case LinuxHintValueType.uint64:
        return DBusUint64(value);
      case LinuxHintValueType.variant:
        return DBusVariant((value as LinuxHintValue).toDBusValue());
    }
  }
}
