import 'package:chat_ui/chat_ui.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
part 'text_message.g.dart';

/// A class that represents text message.
@JsonSerializable()
@immutable
abstract class TextMessageModel extends MessageModel {
  /// Creates a text message.
  const TextMessageModel._({
    required super.author,
    super.createdAt,
    required super.id,
    super.metadata,
    this.previewData,
    super.remoteId,
    super.repliedMessage,
    super.receivedTime,
    super.roomId,
    super.showStatus,
    super.status,
    super.isOwner,
    required this.text,
    MessageType? type,
    super.updatedAt,
  }) : super(type: type ?? MessageType.text);

  const factory TextMessageModel({
    required UserModel author,
    int? createdAt,
    required String id,
    Map<String, dynamic>? metadata,
    PreviewDataModel? previewData,
    String? remoteId,
    MessageModel? repliedMessage,
    String? roomId,
    bool? showStatus,
    MessageReceivedTime? receivedTime,
    Status? status,
    required String text,
    MessageType? type,
    bool? isOwner,
    int? updatedAt,
  }) = _TextMessageModel;

  /// Creates a text message from a map (decoded JSON).
  factory TextMessageModel.fromJson(Map<String, dynamic> json) =>
      _$TextMessageModelFromJson(json);

  /// Creates a full text message from a partial one.
  factory TextMessageModel.fromPartial({
    required UserModel author,
    int? createdAt,
    required String id,
    required PartialText partialText,
    String? remoteId,
    MessageReceivedTime? receivedTime,
    String? roomId,
    bool? showStatus,
    Status? status,
    bool? isOwner,
    int? updatedAt,
  }) =>
      _TextMessageModel(
        receivedTime: receivedTime,
        author: author,
        createdAt: createdAt,
        id: id,
        metadata: partialText.metadata,
        previewData: partialText.previewData,
        remoteId: remoteId,
        repliedMessage: partialText.repliedMessage,
        roomId: roomId,
        isOwner: isOwner,
        showStatus: showStatus,
        status: status,
        text: partialText.text,
        type: MessageType.text,
        updatedAt: updatedAt,
      );

  /// See [PreviewData].
  final PreviewDataModel? previewData;

  /// User's message.
  final String text;

  /// Equatable props.
  @override
  List<Object?> get props => [
        author,
        createdAt,
        id,
        metadata,
        previewData,
        remoteId,
        repliedMessage,
        roomId,
        showStatus,
        status,
        text,
        updatedAt,
      ];

  @override
  MessageModel copyWith({
    bool? isOwner,
    UserModel? author,
    int? createdAt,
    String? id,
    Map<String, dynamic>? metadata,
    PreviewDataModel? previewData,
    String? remoteId,
    MessageModel? repliedMessage,
    String? roomId,
    bool? showStatus,
    Status? status,
    String? text,
    MessageReceivedTime? receivedTime,
    int? updatedAt,
  });

  /// Converts a text message to the map representation, encodable to JSON.
  @override
  Map<String, dynamic> toJson() => _$TextMessageModelToJson(this);
}

/// A utility class to enable better copyWith.
class _TextMessageModel extends TextMessageModel {
  const _TextMessageModel({
    required super.author,
    super.createdAt,
    required super.id,
    super.metadata,
    super.previewData,
    super.remoteId,
    super.repliedMessage,
    super.roomId,
    super.receivedTime,
    super.showStatus,
    super.isOwner,
    super.status,
    required super.text,
    super.type,
    super.updatedAt,
  }) : super._();

  @override
  MessageModel copyWith({
    bool? isOwner,
    MessageReceivedTime? receivedTime,
    UserModel? author,
    dynamic createdAt = _Unset,
    String? id,
    dynamic metadata = _Unset,
    dynamic previewData = _Unset,
    dynamic remoteId = _Unset,
    dynamic repliedMessage = _Unset,
    dynamic roomId,
    dynamic showStatus = _Unset,
    dynamic status = _Unset,
    String? text,
    dynamic updatedAt = _Unset,
  }) =>
      _TextMessageModel(
        isOwner: isOwner ?? this.isOwner,
        receivedTime: receivedTime ?? this.receivedTime,
        author: author ?? this.author,
        createdAt: createdAt == _Unset ? this.createdAt : createdAt as int?,
        id: id ?? this.id,
        metadata: metadata == _Unset
            ? this.metadata
            : metadata as Map<String, dynamic>?,
        previewData: previewData == _Unset
            ? this.previewData
            : previewData as PreviewDataModel?,
        remoteId: remoteId == _Unset ? this.remoteId : remoteId as String?,
        repliedMessage: repliedMessage == _Unset
            ? this.repliedMessage
            : repliedMessage as MessageModel?,
        roomId: roomId == _Unset ? this.roomId : roomId as String?,
        showStatus:
            showStatus == _Unset ? this.showStatus : showStatus as bool?,
        status: status == _Unset ? this.status : status as Status?,
        text: text ?? this.text,
        updatedAt: updatedAt == _Unset ? this.updatedAt : updatedAt as int?,
      );
}

class _Unset {}
