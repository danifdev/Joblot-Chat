import 'package:chat_ui/chat_ui.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// All possible message types.
enum MessageType {
  audio,
  custom,
  file,
  image,
  system,
  text,
  unsupported,
  video
}

/// All possible statuses message can have.
enum Status { delivered, error, seen, sending, sent }

/// An abstract class that contains all variables and methods
/// every message will have.
@immutable
abstract class MessageModel extends Equatable {
  const MessageModel({
    required this.author,
    this.createdAt,
    required this.id,
    this.metadata,
    this.remoteId,
    this.repliedMessage,
    this.roomId,
    this.showStatus,
    this.status,
    this.receivedTime,
    required this.type,
    this.updatedAt,
    this.isOwner = false,
  });

  /// Creates a particular message from a map (decoded JSON).
  /// Type is determined by the `type` field.
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    final type = MessageType.values.firstWhere(
      (e) => e.name == json['type'],
      orElse: () => MessageType.unsupported,
    );

    switch (type) {
      case MessageType.audio:
        return AudioMessage.fromJson(json);
      case MessageType.custom:
        return CustomMessage.fromJson(json);
      case MessageType.file:
        return FileMessageModel.fromJson(json);
      case MessageType.image:
        return ImageMessageModel.fromJson(json);
      case MessageType.system:
        return SystemMessageModel.fromJson(json);
      case MessageType.text:
        return TextMessageModel.fromJson(json);
      case MessageType.unsupported:
        return UnsupportedMessage.fromJson(json);
      case MessageType.video:
        return VideoMessage.fromJson(json);
    }
  }

  /// User who sent this message.
  final UserModel author;

  /// Created message timestamp, in ms.
  final int? createdAt;

  /// Unique ID of the message.
  final String id;

  /// Additional custom metadata or attributes related to the message.
  final Map<String, dynamic>? metadata;

  /// Unique ID of the message received from the backend.
  final String? remoteId;

  /// Message that is being replied to with the current message.
  final MessageModel? repliedMessage;

  /// ID of the room where this message is sent.
  final String? roomId;

  /// Show status or not.
  final bool? showStatus;

  /// Message [Status].
  final Status? status;

  /// [MessageType].
  final MessageType type;

  /// Updated message timestamp, in ms.
  final int? updatedAt;

  ///
  final MessageReceivedTime? receivedTime;

  final bool? isOwner;

  /// Creates a copy of the message with an updated data.
  MessageModel copyWith({
    UserModel? author,
    int? createdAt,
    String? id,
    Map<String, dynamic>? metadata,
    String? remoteId,
    MessageModel? repliedMessage,
    String? roomId,
    bool? showStatus,
    Status? status,
    int? updatedAt,
    bool? isOwner,
    MessageReceivedTime? receivedTime,
  });

  /// Converts a particular message to the map representation, serializable to JSON.
  Map<String, dynamic> toJson();
}
