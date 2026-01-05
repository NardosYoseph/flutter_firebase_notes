import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'note.freezed.dart';
part 'note.g.dart';


DateTime _timestampToDateTime(Object? value) {
  if (value is Timestamp) return value.toDate();
  if (value is String) return DateTime.parse(value);
  if (value is DateTime) return value;
  throw ArgumentError('Invalid timestamp value: $value');
}

Object _dateTimeToTimestamp(DateTime value) => Timestamp.fromDate(value);

@freezed
abstract class Note with _$Note {
  const factory Note({
    required String id,
    required String userId,
    required String title,
    required String content,
    @JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp)
    required DateTime createdAt,
    @JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp)
    required DateTime updatedAt,
  }) = _Note;

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
}
