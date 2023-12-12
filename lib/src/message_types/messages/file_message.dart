import 'package:chat_ui/chat_ui.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import '../message.dart';
part 'file_message.g.dart';

/// A class that represents file message.
@JsonSerializable()
@immutable
abstract class FileMessageModel extends MessageModel {
  /// Creates a file message.
  const FileMessageModel._({
    required super.author,
    super.createdAt,
    required super.id,
    this.isLoading,
    super.metadata,
    this.mimeType,
    required this.name,
    super.remoteId,
    super.repliedMessage,
    super.roomId,
    super.showStatus,
    required this.size,
    super.status,
    super.receivedTime,
    MessageType? type,
    super.updatedAt,
    required this.uri,
  }) : super(type: type ?? MessageType.file);

  const factory FileMessageModel({
    required UserModel author,
    int? createdAt,
    required String id,
    bool? isLoading,
    Map<String, dynamic>? metadata,
    String? mimeType,
    required String name,
    MessageReceivedTime? receivedTime,
    String? remoteId,
    MessageModel? repliedMessage,
    String? roomId,
    bool? showStatus,
    required num size,
    Status? status,
    MessageType? type,
    int? updatedAt,
    required String uri,
  }) = _FileMessageModel;

  /// Creates a file message from a map (decoded JSON).
  factory FileMessageModel.fromJson(Map<String, dynamic> json) =>
      _$FileMessageModelFromJson(json);

  /// Creates a full file message from a partial one.
  factory FileMessageModel.fromPartial({
    required UserModel author,
    int? createdAt,
    required String id,
    bool? isLoading,
    MessageReceivedTime? receivedTime,
    required PartialFile partialFile,
    String? remoteId,
    String? roomId,
    bool? showStatus,
    Status? status,
    int? updatedAt,
  }) =>
      _FileMessageModel(
        author: author,
        createdAt: createdAt,
        id: id,
        isLoading: isLoading,
        metadata: partialFile.metadata,
        mimeType: partialFile.mimeType,
        name: partialFile.name,
        remoteId: remoteId,
        repliedMessage: partialFile.repliedMessage,
        roomId: roomId,
        showStatus: showStatus,
        size: partialFile.size,
        status: status,
        type: MessageType.file,
        updatedAt: updatedAt,
        uri: partialFile.uri,
      );

  /// Specify whether the message content is currently being loaded.
  final bool? isLoading;

  /// Media type.
  final String? mimeType;

  /// The name of the file.
  final String name;

  /// Size of the file in bytes.
  final num size;

  /// The file source (either a remote URL or a local resource).
  final String uri;

  /// Equatable props.
  @override
  List<Object?> get props => [
        author,
        createdAt,
        id,
        isLoading,
        metadata,
        mimeType,
        name,
        remoteId,
        repliedMessage,
        roomId,
        showStatus,
        size,
        status,
        updatedAt,
        uri,
      ];

  @override
  MessageModel copyWith({
    bool? isOwner,
    UserModel? author,
    MessageReceivedTime? receivedTime,
    int? createdAt,
    String? id,
    bool? isLoading,
    Map<String, dynamic>? metadata,
    String? mimeType,
    String? name,
    String? remoteId,
    MessageModel? repliedMessage,
    String? roomId,
    bool? showStatus,
    num? size,
    Status? status,
    int? updatedAt,
    String? uri,
  });

  /// Converts a file message to the map representation, encodable to JSON.
  @override
  Map<String, dynamic> toJson() => _$FileMessageModelToJson(this);
}

/// A utility class to enable better copyWith.
class _FileMessageModel extends FileMessageModel {
  const _FileMessageModel({
    required super.author,
    super.createdAt,
    required super.id,
    super.isLoading,
    super.metadata,
    super.mimeType,
    required super.name,
    super.remoteId,
    super.repliedMessage,
    super.roomId,
    super.showStatus,
    required super.size,
    super.status,
    super.type,
    super.receivedTime,
    super.updatedAt,
    required super.uri,
  }) : super._();

  @override
  MessageModel copyWith({
    bool? isOwner,
    UserModel? author,
    dynamic createdAt = _Unset,
    MessageReceivedTime? receivedTime,
    dynamic height = _Unset,
    String? id,
    dynamic isLoading = _Unset,
    dynamic metadata = _Unset,
    dynamic mimeType = _Unset,
    String? name,
    dynamic remoteId = _Unset,
    dynamic repliedMessage = _Unset,
    dynamic roomId,
    dynamic showStatus = _Unset,
    num? size,
    dynamic status = _Unset,
    dynamic updatedAt = _Unset,
    String? uri,
    dynamic width = _Unset,
  }) =>
      _FileMessageModel(
        receivedTime: receivedTime ?? this.receivedTime,
        author: author ?? this.author,
        createdAt: createdAt == _Unset ? this.createdAt : createdAt as int?,
        id: id ?? this.id,
        isLoading: isLoading == _Unset ? this.isLoading : isLoading as bool?,
        metadata: metadata == _Unset
            ? this.metadata
            : metadata as Map<String, dynamic>?,
        mimeType: mimeType == _Unset ? this.mimeType : mimeType as String?,
        name: name ?? this.name,
        remoteId: remoteId == _Unset ? this.remoteId : remoteId as String?,
        repliedMessage: repliedMessage == _Unset
            ? this.repliedMessage
            : repliedMessage as MessageModel?,
        roomId: roomId == _Unset ? this.roomId : roomId as String?,
        showStatus:
            showStatus == _Unset ? this.showStatus : showStatus as bool?,
        size: size ?? this.size,
        status: status == _Unset ? this.status : status as Status?,
        updatedAt: updatedAt == _Unset ? this.updatedAt : updatedAt as int?,
        uri: uri ?? this.uri,
      );
}

class _Unset {}
