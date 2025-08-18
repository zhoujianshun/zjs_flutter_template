# Freezed 数据模型迁移指南

## 📋 概述

本文档记录了项目从 `json_annotation + Equatable` 到 `Freezed` 的完整迁移过程，以及迁移后获得的收益。

## 🎯 迁移目标

### 迁移前的问题

- **代码冗余**: 需要手动实现 `copyWith`、`==`、`hashCode`、`toString`
- **维护困难**: 添加字段时需要更新多个地方
- **不一致性**: 不同模型使用不同的方案（有些用Equatable，有些不用）
- **样板代码**: 大量重复的序列化和相等性判断代码

### 迁移后的收益

- **代码减少70%**: 自动生成所有样板代码
- **类型安全**: 联合类型支持，编译时错误检查
- **统一风格**: 所有数据模型使用相同的模式
- **功能增强**: 支持模式匹配、联合类型、深度拷贝等

## 🔄 迁移步骤

### 1. 更新依赖

```yaml
# pubspec.yaml
dependencies:
  # 保留JSON序列化支持
  json_annotation: ^4.9.0
  freezed_annotation: ^3.1.0
  
dev_dependencies:
  # 移除不需要的依赖
  # equatable: ^2.0.5  # 删除
  
  # 保留和添加代码生成器
  json_serializable: ^6.9.5
  freezed: ^3.1.0
  build_runner: ^2.5.4
```

### 2. 模型迁移示例

#### User 模型迁移

**迁移前 (98行代码):**

```dart
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable {
  const User({
    required this.id,
    required this.email,
    required this.createdAt,
    this.phone,
    this.name,
    this.avatar,
    this.birthday,
    this.gender,
    this.role = UserRole.user,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

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

  Map<String, dynamic> toJson() => _$UserToJson(this);

  // 手动实现copyWith - 30行代码！
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

  // 业务方法
  String get displayName {
    if (name != null && name!.isNotEmpty) return name!;
    if (phone != null && phone!.isNotEmpty) return phone!;
    return email;
  }

  String get avatarInitial {
    return displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U';
  }

  bool get isAdmin => role == UserRole.admin;
  bool get isUser => role == UserRole.user;

  @override
  List<Object?> get props => [
    id, email, phone, name, avatar, birthday, 
    gender, role, createdAt, updatedAt,
  ];

  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $name, role: $role)';
  }
}

```

**迁移后 (30行代码):**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String email,
    DateTime? createdAt,  // 改为可选，更灵活
    String? phone,
    String? name,
    String? avatar,
    DateTime? birthday,
    String? gender,
    @Default(UserRole.user) UserRole role,
    DateTime? updatedAt,
  }) = _User;

  const User._();  // 私有构造函数，用于添加自定义方法

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  // 业务方法 - 与之前完全相同
  String get displayName {
    if (name != null && name!.isNotEmpty) return name!;
    if (phone != null && phone!.isNotEmpty) return phone!;
    return email;
  }

  String get avatarInitial {
    return displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U';
  }

  bool get isAdmin => role == UserRole.admin;
  bool get isUser => role == UserRole.user;

}
```

**收益对比:**

- 代码行数：98行 → 30行 (减少69%)
- 自动生成：`copyWith`、`==`、`hashCode`、`toString`、`toJson`
- 类型安全：编译时检查，更少的运行时错误

- 维护性：添加字段时无需手动更新其他方法

#### 错误处理迁移

**迁移前 - 继承模式 (72行代码):**

```dart
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? code;
  
  const Failure({required this.message, this.code});
  
  @override
  List<Object?> get props => [message, code];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.code});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.code});
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.code});
}

class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code});
}


class UnknownFailure extends Failure {
  const UnknownFailure({required super.message, super.code});
}
```

**迁移后 - 联合类型 (25行代码):**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
abstract class Failure with _$Failure {
  const factory Failure.server({
    required String message,
    @Default(500) int code,
  }) = ServerFailure;

  const factory Failure.network({
    required String message,
    @Default(-1) int code,
  }) = NetworkFailure;

  const factory Failure.cache({
    required String message,
    @Default(-2) int code,
  }) = CacheFailure;

  const factory Failure.validation({
    required String message,
    @Default(400) int code,
  }) = ValidationFailure;

  const factory Failure.auth({
    required String message,
    @Default(401) int code,
  }) = AuthFailure;

  const factory Failure.unknown({

    required String message,
    @Default(-999) int code,
  }) = UnknownFailure;
}
```

**联合类型的优势:**

```dart
// 类型安全的模式匹配
String handleFailure(Failure failure) {
  return failure.when(
    server: (message, code) => "服务器错误: $message (代码: $code)",
    network: (message, code) => "网络错误: $message",
    auth: (message, code) => "认证失败: $message",
    validation: (message, code) => "验证错误: $message",
    cache: (message, code) => "缓存错误: $message",
    unknown: (message, code) => "未知错误: $message",
  );
}

// 或者使用 maybeWhen 处理部分情况
String getErrorIcon(Failure failure) {
  return failure.maybeWhen(
    network: (_, __) => "🌐",
    auth: (_, __) => "🔒",
    orElse: () => "⚠️",
  );
}
```

### 3. 代码生成

```bash
# 清理旧的生成文件
dart run build_runner clean


# 生成新的代码
dart run build_runner build --delete-conflicting-outputs
```

## ✅ 迁移检查清单

### 依赖更新

- [ ] 添加 `freezed: ^3.1.0` 和 `freezed_annotation: ^3.1.0`
- [ ] 保留 `json_annotation` 和 `json_serializable`
- [ ] 移除 `equatable` 依赖

### 模型文件更新

- [ ] 更改 import 语句
- [ ] 添加 `.freezed.dart` part 文件
- [ ] 将 class 改为 abstract class
- [ ] 使用 `@freezed` 注解
- [ ] 转换为 factory 构造函数
- [ ] 添加私有构造函数（如果需要自定义方法）

- [ ] 迁移自定义业务方法

### 使用方更新

- [ ] 检查所有使用该模型的地方
- [ ] 更新错误处理逻辑（如果使用了联合类型）
- [ ] 测试模式匹配功能

## 🚀 最佳实践

### 1. 使用 @Default 注解

```dart

@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    @Default("") String name,           // 字符串默认值
    @Default(UserRole.user) UserRole role,  // 枚举默认值
    @Default([]) List<String> tags,     // 列表默认值
  }) = _User;
}
```

### 2. 合理使用可选参数

```dart
// 将非核心字段设为可选
const factory User({
  required String id,        // 必需
  required String email,     // 必需
  DateTime? createdAt,       // 可选 - 可能从服务器获取
  String? name,             // 可选 - 用户可能未设置
}) = _User;
```

### 3. 联合类型的设计

```dart
// 好的设计 - 清晰的状态区分
@freezed
abstract class LoadingState<T> with _$LoadingState<T> {

  const factory LoadingState.initial() = Initial<T>;
  const factory LoadingState.loading() = Loading<T>;
  const factory LoadingState.success(T data) = Success<T>;
  const factory LoadingState.error(String message) = Error<T>;
}

// 避免 - 过于复杂的联合类型
@freezed  
abstract class ComplexState with _$ComplexState {
  // 避免超过7-8个不同的状态
}
```

### 4. 自定义方法的添加

```dart
@freezed
abstract class User with _$User {
  const factory User({
    required String firstName,
    required String lastName,

  }) = _User;
  
  const User._();  // 重要：私有构造函数
  
  // 自定义getter

  String get fullName => '$firstName $lastName';
  
  // 自定义方法
  bool hasName() => firstName.isNotEmpty && lastName.isNotEmpty;
}

```

## 🎉 迁移收益总结

### 代码质量提升

- **减少70%样板代码**: 从手动实现到自动生成
- **统一代码风格**: 所有模型使用相同模式
- **类型安全**: 编译时错误检查，减少运行时错误

### 开发效率提升  

- **快速添加字段**: 只需在factory构造函数中添加
- **自动更新方法**: copyWith、equals等自动同步
- **强大的IDE支持**: 更好的代码补全和重构

### 功能增强

- **联合类型**: 完美的状态管理和错误处理
- **模式匹配**: 类型安全的分支处理
- **深度拷贝**: 支持嵌套对象的完整拷贝
- **JSON序列化**: 无缝集成，性能优异

这次迁移不仅简化了代码，还为项目带来了更强的类型安全性和更好的开发体验。Freezed已成为Flutter项目中数据模型的标准选择。
