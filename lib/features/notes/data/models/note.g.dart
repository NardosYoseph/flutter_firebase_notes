// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Note _$NoteFromJson(Map<String, dynamic> json) => _Note(
  id: json['id'] as String,
  userId: json['userId'] as String,
  title: json['title'] as String,
  content: json['content'] as String,
  createdAt: _timestampToDateTime(json['createdAt']),
  updatedAt: _timestampToDateTime(json['updatedAt']),
);

Map<String, dynamic> _$NoteToJson(_Note instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'title': instance.title,
  'content': instance.content,
  'createdAt': _dateTimeToTimestamp(instance.createdAt),
  'updatedAt': _dateTimeToTimestamp(instance.updatedAt),
};
