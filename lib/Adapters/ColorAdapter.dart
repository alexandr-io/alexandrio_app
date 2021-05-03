import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ColorAdapter extends TypeAdapter<Color> {
  @override
  final typeId = 223;

  @override
  Color read(BinaryReader reader) {
    var data = reader.readInt();
    return Color(data);
  }

  @override
  void write(BinaryWriter writer, Color obj) {
    writer.writeInt(obj.value);
  }
}
