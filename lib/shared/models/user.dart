import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// 用户数据模型
@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String email,
    DateTime? createdAt,
    String? phone,
    String? name,
    String? avatar,
    DateTime? birthday,
    String? gender,
    @Default(UserRole.user) UserRole role,
    DateTime? updatedAt,
  }) = _User;

  const User._();

  /// 从JSON创建User对象
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// 获取显示名称
  String get displayName {
    if (name != null && name!.isNotEmpty) return name!;
    if (phone != null && phone!.isNotEmpty) return phone!;
    return email;
  }

  /// 获取头像首字母
  String get avatarInitial {
    return displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U';
  }

  /// 是否为管理员
  bool get isAdmin => role == UserRole.admin;

  /// 是否为普通用户
  bool get isUser => role == UserRole.user;
}

/// 用户角色枚举
enum UserRole {
  @JsonValue('admin')
  admin,

  @JsonValue('user')
  user,

  @JsonValue('guest')
  guest,
}

/// 用户角色扩展
extension UserRoleExtension on UserRole {
  /// 角色显示名称
  String get displayName {
    switch (this) {
      case UserRole.admin:
        return '管理员';
      case UserRole.user:
        return '普通用户';
      case UserRole.guest:
        return '访客';
    }
  }

  /// 角色权重（用于权限判断）
  int get weight {
    switch (this) {
      case UserRole.admin:
        return 100;
      case UserRole.user:
        return 10;
      case UserRole.guest:
        return 1;
    }
  }
}
