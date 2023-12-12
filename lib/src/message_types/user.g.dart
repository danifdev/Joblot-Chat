// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      createdAt: json['createdAt'] as int?,
      firstName: json['firstName'] as String?,
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String?,
      lastName: json['lastName'] as String?,
      lastSeen: json['lastSeen'] as int?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      role: $enumDecodeNullable(_$RoleEnumMap, json['role']),
      updatedAt: json['updatedAt'] as int?,
      isBase64UrlOfAvatar: json['isBase64UrlOfAvatar'] as bool,
      bytes: json['bytes'],
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'createdAt': instance.createdAt,
      'firstName': instance.firstName,
      'id': instance.id,
      'imageUrl': instance.imageUrl,
      'lastName': instance.lastName,
      'lastSeen': instance.lastSeen,
      'metadata': instance.metadata,
      'role': _$RoleEnumMap[instance.role],
      'updatedAt': instance.updatedAt,
      'isBase64UrlOfAvatar': instance.isBase64UrlOfAvatar,
      'bytes': instance.bytes,
    };

const _$RoleEnumMap = {
  Role.admin: 'admin',
  Role.agent: 'agent',
  Role.moderator: 'moderator',
  Role.user: 'user',
};
