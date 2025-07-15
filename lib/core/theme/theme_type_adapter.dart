import 'package:hive/hive.dart';
import 'app_theme.dart'; // Assuming ThemeType is in app_theme.dart

class ThemeTypeAdapter extends TypeAdapter<ThemeType> {
  @override
  final int typeId = 100; // Unique ID for this adapter (choose any not used)

  @override
  ThemeType read(BinaryReader reader) {
    // Read the index of the enum that was stored
    final int index = reader.readByte();
    return ThemeType.values[index];
  }

  @override
  void write(BinaryWriter writer, ThemeType obj) {
    // Write the index of the enum
    writer.writeByte(obj.index);
  }
}
