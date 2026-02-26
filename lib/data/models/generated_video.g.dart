// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generated_video.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GeneratedVideoAdapter extends TypeAdapter<GeneratedVideo> {
  @override
  final int typeId = 0;

  @override
  GeneratedVideo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GeneratedVideo(
      id: fields[0] as String,
      videoPath: fields[1] as String,
      thumbnailPath: fields[2] as String,
      createdAt: fields[3] as DateTime,
      metadataJson: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GeneratedVideo obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.videoPath)
      ..writeByte(2)
      ..write(obj.thumbnailPath)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.metadataJson);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeneratedVideoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
