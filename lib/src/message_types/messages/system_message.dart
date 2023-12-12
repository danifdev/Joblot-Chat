import 'package:chat_ui/chat_ui.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import '../message.dart';

part 'system_message.g.dart';

/// A class that represents a system message (anything around chat management). Use [metadata] to store anything
/// you want.
@JsonSerializable()
@immutable
abstract class SystemMessageModel extends MessageModel {
  /// Creates a custom message.
  const SystemMessageModel._({
    super.author = const UserModel(id: 'system', isBase64UrlOfAvatar: false),
    super.createdAt,
    required super.id,
    super.metadata,
    super.remoteId,
    super.repliedMessage,
    super.roomId,
    super.showStatus,
    super.receivedTime,
    super.status,
    required this.text,
    MessageType? type,
    super.updatedAt,
  }) : super(type: type ?? MessageType.system);

  const factory SystemMessageModel({
    UserModel author,
    int? createdAt,
    required String id,
    Map<String, dynamic>? metadata,
    MessageReceivedTime? receivedTime,
    String? remoteId,
    MessageModel? repliedMessage,
    String? roomId,
    bool? showStatus,
    Status? status,
    required String text,
    MessageType? type,
    int? updatedAt,
  }) = _SystemMessageModel;

  /// Creates a custom message from a map (decoded JSON).
  factory SystemMessageModel.fromJson(Map<String, dynamic> json) =>
      _$SystemMessageModelFromJson(json);

  /// System message content (could be text or translation key).
  final String text;

  /// Equatable props.
  @override
  List<Object?> get props => [
        author,
        createdAt,
        id,
        metadata,
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
    MessageReceivedTime? receivedTime,
    Map<String, dynamic>? metadata,
    String? remoteId,
    MessageModel? repliedMessage,
    String? roomId,
    bool? showStatus,
    Status? status,
    String? text,
    int? updatedAt,
  });

  /// Converts a custom message to the map representation,
  /// encodable to JSON.
  @override
  Map<String, dynamic> toJson() => _$SystemMessageModelToJson(this);
}

/// A utility class to enable better copyWith.
class _SystemMessageModel extends SystemMessageModel {
  const _SystemMessageModel({
    super.author,
    super.createdAt,
    required super.id,
    super.metadata,
    super.remoteId,
    super.repliedMessage,
    super.roomId,
    super.showStatus,
    super.receivedTime,
    super.status,
    required super.text,
    super.type,
    super.updatedAt,
  }) : super._();

  @override
  MessageModel copyWith({
    bool? isOwner,
    UserModel? author,
    MessageReceivedTime? receivedTime,
    dynamic createdAt = _Unset,
    String? id,
    dynamic metadata = _Unset,
    dynamic remoteId = _Unset,
    dynamic repliedMessage = _Unset,
    dynamic roomId,
    dynamic showStatus = _Unset,
    dynamic status = _Unset,
    String? text,
    dynamic updatedAt = _Unset,
  }) =>
      _SystemMessageModel(
        receivedTime: receivedTime ?? this.receivedTime,
        author: author ?? this.author,
        createdAt: createdAt == _Unset ? this.createdAt : createdAt as int?,
        id: id ?? this.id,
        metadata: metadata == _Unset
            ? this.metadata
            : metadata as Map<String, dynamic>?,
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
