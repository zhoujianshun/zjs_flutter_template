# 依赖更新指南

## 📋 当前状态

项目当前有28个依赖包可以更新到更新版本，其中包括一些关键的安全和功能更新。

## 🔧 推荐的依赖更新

### 高优先级更新（建议立即更新）

```yaml
dependencies:
  # 路由导航 - 重要功能更新和bug修复
  go_router: ^16.2.0  # 从 12.1.3 更新，包含重要的路由处理改进
  
  # 依赖注入 - 性能优化
  get_it: ^8.2.0  # 从 7.7.0 更新，包含性能改进
  
  # 网络和设备信息 - 安全更新
  connectivity_plus: ^6.1.5  # 从 5.0.2 更新
  device_info_plus: ^11.5.0  # 从 9.1.2 更新
  package_info_plus: ^8.3.1  # 从 4.2.0 更新

dev_dependencies:
  # 代码质量工具 - 重要更新
  very_good_analysis: ^9.0.0  # 从 5.1.0 更新，包含新的代码检查规则
  flutter_lints: ^6.0.0      # 从 3.0.2 更新
  build_runner: ^2.7.0       # 从 2.5.4 更新
  
  # 代码生成工具
  freezed: ^3.2.0            # 从 3.1.0 更新
  json_serializable: ^6.10.0 # 从 6.9.5 更新
```

### 中优先级更新

```yaml
dependencies:
  # 动画和UI
  lottie: ^3.3.1  # 从 2.7.0 更新，支持更多动画格式

dev_dependencies:
  # 测试工具
  bloc_test: ^10.0.0  # 从 9.1.7 更新
  mockito: ^5.5.0     # 从 5.4.6 更新
  custom_lint: ^0.8.0 # 从 0.7.6 更新
```

### 需要移除的废弃依赖

```yaml
# 移除已废弃的包
# js包已被废弃，检查是否被其他包传递依赖
```

## 📝 更新步骤

### 1. 备份当前配置

```bash
# 备份当前的pubspec.lock
cp pubspec.lock pubspec.lock.backup
```

### 2. 更新pubspec.yaml

手动更新上述依赖版本到pubspec.yaml文件中。

### 3. 清理和重新安装

```bash
# 清理项目
flutter clean

# 获取最新依赖
flutter pub get

# 检查依赖冲突
flutter pub deps
```

### 4. 重新生成代码

```bash
# 清理生成的代码
dart run build_runner clean

# 重新生成所有代码
dart run build_runner build --delete-conflicting-outputs
```

### 5. 运行测试

```bash
# 运行所有测试确保更新后功能正常
flutter test

# 运行集成测试
flutter test integration_test/
```

### 6. 检查兼容性

```bash
# 检查代码分析
flutter analyze

# 检查格式
dart format --set-exit-if-changed lib/ test/
```

## ⚠️ 更新注意事项

### GoRouter 16.x 重大变更

- 路由配置API可能有变化
- 需要检查路由守卫的实现
- 验证嵌套路由的工作是否正常

### GetIt 8.x 变更

- 性能优化，向后兼容
- 新增了一些便捷方法
- 错误处理有所改进

### Very Good Analysis 9.x

- 新增了更多代码检查规则
- 可能会发现之前未检测到的问题
- 建议逐步修复新的警告

## 🔍 验证清单

更新完成后，请验证以下功能：

- [ ] 应用正常启动
- [ ] 路由导航正常工作
- [ ] 用户登录/注册功能正常
- [ ] 主题切换功能正常
- [ ] 语言切换功能正常
- [ ] 网络请求正常工作
- [ ] 本地存储功能正常
- [ ] 所有测试通过
- [ ] 代码分析无错误

## 📊 更新效益

### 性能提升

- 路由导航性能改进
- 依赖注入效率提升
- 构建速度优化

### 安全性

- 修复已知的安全漏洞
- 更好的网络连接处理
- 改进的错误处理

### 开发体验

- 更好的代码检查规则
- 改进的开发工具
- 更快的热重载

## 🚀 自动化更新脚本

可以创建一个脚本来自动化更新过程：

```bash
#!/bin/bash
# scripts/update_dependencies.sh

echo "🔄 开始更新依赖..."

# 1. 备份
cp pubspec.lock pubspec.lock.backup
echo "✅ 备份完成"

# 2. 清理
flutter clean
echo "✅ 清理完成"

# 3. 更新依赖
flutter pub upgrade --major-versions
echo "✅ 依赖更新完成"

# 4. 重新生成代码
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
echo "✅ 代码生成完成"

# 5. 运行测试
flutter test
echo "✅ 测试完成"

# 6. 代码分析
flutter analyze
echo "✅ 代码分析完成"

echo "🎉 依赖更新完成！"
```

## 📞 支持

如果在更新过程中遇到问题：

1. 检查Flutter和Dart SDK版本是否满足要求
2. 查看依赖包的CHANGELOG了解重大变更
3. 在项目Issues中搜索相关问题
4. 必要时可以回滚到备份的pubspec.lock

---

*最后更新：2024年12月*
