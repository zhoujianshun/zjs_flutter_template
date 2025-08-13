import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// 用户数据模型
@JsonSerializable()
class User extends Equatable {
  final String id;
  final String email;
  final String? phone;
  final String? name;
  final String? avatar;
  final DateTime? birthday;
  final String? gender;
  final UserRole role;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.email,
    this.phone,
    this.name,
    this.avatar,
    this.birthday,
    this.gender,
    this.role = UserRole.user,
    required this.createdAt,
    this.updatedAt,
  });

  /// 从JSON创建User对象
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// 转换为JSON
  Map<String, dynamic> toJson() => _$UserToJson(this);

  /// 复制并修改部分属性
  User copyWith({
    String? id,
    String? email,
    String? phone,
    String? name,
    String? avatar,
    DateTime? birthday,
    String? gender,
    UserRole? role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

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

  @override
  List<Object?> get props => [
        id,
        email,
        phone,
        name,
        avatar,
        birthday,
        gender,
        role,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $name, role: $role)';
  }
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
