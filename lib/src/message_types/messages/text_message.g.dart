// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextMessageModel _$TextMessageModelFromJson(Map<String, dynamic> json) =>
    TextMessageModel(
      author: UserModel.fromJson(json['author'] as Map<String, dynamic>),
      createdAt: json['createdAt'] as int?,
      id: json['id'] as String,
      metadata: json['metadata'] as Map<String, dynamic>?,
      previewData: json['previewData'] == null
          ? null
          : PreviewDataModel.fromJson(
              json['previewData'] as Map<String, dynamic>),
      remoteId: json['remoteId'] as String?,
      repliedMessage: json['repliedMessage'] == null
          ? null
          : MessageModel.fromJson(
              json['repliedMessage'] as Map<String, dynamic>),
      roomId: json['roomId'] as String?,
      showStatus: json['showStatus'] as bool?,
      receivedTime: json['receivedTime'] == null
          ? null
          : MessageReceivedTime.fromJson(
              json['receivedTime'] as Map<String, dynamic>),
      status: $enumDecodeNullable(_$StatusEnumMap, json['status']),
      text: json['text'] as String,
      type: $enumDecodeNullable(_$MessageTypeEnumMap, json['type']),
      isOwner: json['isOwner'] as bool?,
      updatedAt: json['updatedAt'] as int?,
    );

Map<String, dynamic> _$TextMessageModelToJson(TextMessageModel instance) =>
    <String, dynamic>{
      'author': instance.author,
      'createdAt': instance.createdAt,
      'id': instance.id,
      'metadata': instance.metadata,
      'remoteId': instance.remoteId,
      'repliedMessage': instance.repliedMessage,
      'roomId': instance.roomId,
      'showStatus': instance.showStatus,
      'status': _$StatusEnumMap[instance.status],
      'type': _$MessageTypeEnumMap[instance.type]!,
      'updatedAt': instance.updatedAt,
      'receivedTime': instance.receivedTime,
      'isOwner': instance.isOwner,
      'previewData': instance.previewData,
      'text': instance.text,
    };

const _$StatusEnumMap = {
  Status.delivered: 'delivered',
  Status.error: 'error',
  Status.seen: 'seen',
  Status.sending: 'sending',
  Status.sent: 'sent',
};

const _$MessageTypeEnumMap = {
  MessageType.audio: 'audio',
  MessageType.custom: 'custom',
  MessageType.file: 'file',
  MessageType.image: 'image',
  MessageType.system: 'system',
  MessageType.text: 'text',
  MessageType.unsupported: 'unsupported',
  MessageType.video: 'video',
};
