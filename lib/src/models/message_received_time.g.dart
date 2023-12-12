// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_received_time.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageReceivedTime _$MessageReceivedTimeFromJson(Map<String, dynamic> json) =>
    MessageReceivedTime(
      timeText: json['timeText'] as String?,
      timeDate: json['timeDate'] == null
          ? null
          : DateTime.parse(json['timeDate'] as String),
    );

Map<String, dynamic> _$MessageReceivedTimeToJson(
        MessageReceivedTime instance) =>
    <String, dynamic>{
      'timeText': instance.timeText,
      'timeDate': instance.timeDate?.toIso8601String(),
    };
