# Sky Eldercare Family - Flutter模版项目

一个功能完整的Flutter应用模版，集成了现代Flutter开发的最佳实践和常用功能。

## 📱 项目特色

### 🏗️ 现代化架构

- ✅ **GetIt + Injectable** 依赖注入 - 高性能、类型安全的DI容器
- ✅ **Riverpod** 状态管理 - 专注UI状态，类型安全
- ✅ **Freezed** 数据模型 - 不可变数据类，联合类型支持
- ✅ **Dartz** 函数式编程 - Either类型处理错误

### 🚀 开发体验

- ✅ **GoRouter** 路由导航 - 官方推荐的声明式路由
- ✅ **Dio** 网络请求 - 功能丰富的HTTP客户端
- ✅ **代码生成** - 自动生成样板代码，提升开发效率
- ✅ **完整测试** - 单元测试、Widget测试、集成测试

### 🎨 用户体验

- ✅ **Material 3** 设计系统 - Google最新设计语言
- ✅ **主题切换** - 支持浅色/深色/跟随系统
- ✅ **国际化支持** - 多语言本地化
- ✅ **响应式设计** - 适配不同屏幕尺寸

## 🏗️ 项目架构

### 分层架构

```text
┌─────────────────────────────────────┐
│            UI Layer                 │  ← Riverpod (状态管理)
├─────────────────────────────────────┤
│         Business Layer             │  ← GetIt (依赖注入)
├─────────────────────────────────────┤
│           Data Layer               │  ← Freezed (数据模型)
└─────────────────────────────────────┘
```

### 目录结构

```text
lib/
├── di/                      # 🔧 依赖注入配置
│   ├── service_locator.dart # GetIt 容器配置
│   ├── service_locator.config.dart # GetIt 生成文件

│   └── providers.dart       # Riverpod Providers
├── core/                    # 🏗️ 核心基础设施
│   ├── constants/          # 应用常量
│   ├── errors/             # Freezed 错误类型和异常处理
│   ├── extensions/         # Dartz 扩展方法
│   ├── network/            # 网络配置和拦截器
│   ├── storage/            # 存储服务 (Injectable)
│   └── utils/              # 工具类和验证器
├── features/               # 🎯 功能模块
│   ├── pages/              # UI 页面
│   │   ├── app_shell.dart  # 应用外壳（底部导航）
│   │   ├── auth/           # 认证页面
│   │   │   └── login_page.dart
│   │   ├── home/           # 首页模块
│   │   │   └── home_page.dart
│   │   ├── onboarding/     # 引导页模块
│   │   │   └── onboarding_page.dart
│   │   ├── pages/          # 其他页面
│   │   │   └── profile_page.dart
│   │   └── settings/       # 设置页面
│   │       ├── language_settings_page.dart
│   │       └── theme_settings_page.dart
│   └── providers/          # Riverpod 状态管理
│       └── auth.dart       # 认证状态管理
├── shared/                 # 🔄 共享组件
│   ├── apis/               # API 接口定义
│   ├── models/             # Freezed 数据模型
│   ├── services/           # 业务服务 (Injectable)
│   └── widgets/            # 通用UI组件
├── config/                 # ⚙️ 配置文件
│   ├── routes/             # GoRouter 路由配置
│   ├── themes/             # Material 3 主题
│   ├── env/                # 环境配置
│   └── language/           # 语言配置
├── examples/               # 📚 代码示例
│   ├── auth_examples.dart  # 认证示例
│   ├── dartz_examples.dart # Dartz 函数式编程示例
│   ├── get_it_usage_examples.dart # GetIt 使用示例
│   └── riverpod_examples.dart # Riverpod 示例
├── l10n/                   # 🌍 国际化文件
├── generated/              # 🤖 自动生成的文件
└── main.dart               # 🚀 应用入口
```

### 技术栈

| 层级 | 技术选型 | 用途 |
|------|----------|------|
| **UI层** | Riverpod | UI状态管理、响应式更新 |
| **业务层** | GetIt + Injectable | 依赖注入、服务定位 |
| **数据层** | Freezed | 不可变数据模型、联合类型 |
| **网络层** | Dio | HTTP请求、拦截器 |
| **存储层** | Hive + SharedPreferences | 本地数据存储 |
| **路由层** | GoRouter | 声明式路由导航 |

## 🚀 快速开始

### 环境要求

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0

### 安装依赖

```bash
flutter pub get
```

### 生成代码

项目使用多个代码生成器，需要运行以下命令：

```bash
# 生成所有代码 (推荐)
dart run build_runner build --delete-conflicting-outputs

# 监听文件变化并自动生成 (开发时使用)
dart run build_runner watch --delete-conflicting-outputs

# 清理生成的文件
dart run build_runner clean
```

**生成的文件类型：**

- `*.freezed.dart` - Freezed 数据模型
- `*.g.dart` - JSON 序列化代码
- `service_locator.config.dart` - GetIt 依赖注册
- `*.riverpod.dart` - Riverpod 代码生成

### 生成国际化文件

```bash
flutter gen-l10n
```

### 运行应用

```bash
flutter run
```

## 🧪 测试

### 运行单元测试

```bash
flutter test test/unit/
```

### 运行Widget测试

```bash
flutter test test/widget/
```

### 运行集成测试

```bash
flutter test integration_test/
```

### 运行所有测试

```bash
flutter test
```

## 📦 核心依赖

### 状态管理

- `flutter_riverpod` - 状态管理
- `riverpod_annotation` - 代码生成注解
- `riverpod_generator` - Riverpod 代码生成器
- `riverpod_lint` - Riverpod 代码检查

### 依赖注入

- `get_it` - 服务定位器
- `injectable` - 依赖注入注解
- `injectable_generator` - 依赖注入代码生成器

### 路由导航

- `go_router` - 声明式路由

### 网络请求

- `dio` - HTTP客户端
- `pretty_dio_logger` - 网络日志

### 本地存储

- `shared_preferences` - 简单键值存储
- `hive` & `hive_flutter` - NoSQL数据库
- `flutter_secure_storage` - 安全存储

### 数据模型

- `freezed` - 不可变数据类生成
- `freezed_annotation` - Freezed 注解
- `json_annotation` - JSON 序列化注解
- `json_serializable` - JSON 序列化代码生成

### UI组件和工具

- `cached_network_image` - 网络图片缓存
- `shimmer` - 骨架屏效果
- `lottie` - 动画支持
- `flutter_screenutil` - 屏幕适配

### 工具库

- `dartz` - 函数式编程
- `connectivity_plus` - 网络状态监听
- `package_info_plus` - 应用信息
- `device_info_plus` - 设备信息

### 日志和监控

- `logger` - 基础日志记录
- `talker_flutter` - 高级日志和错误监控

### 开发工具

- `build_runner` - 代码生成器运行器
- `very_good_analysis` - 代码分析规则
- `custom_lint` - 自定义代码检查

## 🔧 开发配置

### 代码规范

项目使用 `very_good_analysis` 进行静态代码分析，配置文件：`analysis_options.yaml`

### 代码格式化

```bash
dart format lib/ test/
```

### 代码生成

```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## 📱 功能模块

### 1. 认证模块 (Auth)

- 用户登录/注册
- 密码验证
- 会话管理
- 自动登录

### 2. 首页模块 (Home)

- 底部导航
- 主页内容
- 数据展示

### 3. 个人中心 (Profile)

- 用户信息管理
- 主题设置
- 语言切换
- 退出登录

## 🎨 主题系统

项目支持三种主题模式：

- **跟随系统** - 自动跟随系统深浅模式
- **浅色主题** - Material 3 浅色主题
- **深色主题** - Material 3 深色主题

主题配置文件：`lib/config/themes/app_theme.dart`

## 🌐 国际化

支持中文和英文两种语言：

- 中文 (zh_CN) - 默认语言
- 英文 (en)

国际化文件位于：`lib/l10n/`

## 🔒 安全配置

### 存储安全

- 敏感数据使用 `flutter_secure_storage` 加密存储
- 用户token安全保存
- 自动清理过期数据

### 网络安全

- HTTPS请求
- 请求拦截器
- 错误统一处理
<!-- - 自动token刷新 -->

## 📊 性能优化

### 图片缓存

- 使用 `cached_network_image` 缓存网络图片
- 内存和磁盘双重缓存

### 状态优化

- Riverpod提供最小重建
- 状态缓存和持久化
- 异步状态管理

### UI优化

- Shimmer骨架屏提升用户体验
- 合理的页面动画
- 响应式设计

## 📚 文档指南

### 核心概念文档

- [Dartz 使用指南](docs/DARTZ_GUIDE.md) - 函数式错误处理完整指南
- [Dartz 最佳实践](docs/DARTZ_BEST_PRACTICES.md) - 设计原则和开发规范
- [Dartz + Riverpod 集成](docs/DARTZ_RIVERPOD_INTEGRATION.md) - 状态管理与错误处理集成
- [Riverpod 使用指南](docs/RIVERPOD_GUIDE.md) - 状态管理最佳实践
- [主题切换指南](docs/THEME_SWITCHING_GUIDE.md) - 主题系统使用说明
- [开发指南](docs/DEVELOPMENT_GUIDE.md) - 项目开发规范
- [ScreenUtil 指南](docs/SCREENUTIL_GUIDE.md) - 屏幕适配使用说明
- [自定义主题指南](docs/CUSTOM_THEME_GUIDE.md) - 主题定制指南

### 架构文档

- [GetIt vs Riverpod 对比分析](docs/GET_IT_VS_RIVERPOD_COMPARISON.md) - 依赖注入方案对比
- [GetIt 实现总结](docs/GET_IT_IMPLEMENTATION_SUMMARY.md) - GetIt 集成实现详解
- [GetIt 使用指南](docs/GET_IT_USAGE_GUIDE.md) - GetIt 使用最佳实践
- [Freezed 迁移指南](docs/FREEZED_MIGRATION_GUIDE.md) - 从 Equatable 到 Freezed 的完整迁移指南
- [架构改进文档](lib/docs/ARCHITECTURE_IMPROVEMENT.md) - 项目架构改进说明
- [认证使用指南](lib/docs/AUTH_USAGE_GUIDE.md) - 认证系统使用说明

### 代码示例

- [Dartz 实用示例](lib/examples/dartz_examples.dart) - 完整的代码示例和用法演示
- [Riverpod 示例](lib/examples/riverpod_examples.dart) - 状态管理示例
- [认证示例](lib/examples/auth_examples.dart) - 认证功能使用示例
- [GetIt 使用示例](lib/examples/get_it_usage_examples.dart) - 依赖注入使用示例
- [响应式设计示例](lib/examples/responsive_examples.dart) - 屏幕适配示例
- [主题使用示例](lib/examples/theme_usage_examples.dart) - 主题切换示例
- [深色模式示例](lib/examples/dark_mode_examples.dart) - 深色模式实现示例

## 🛠️ 开发指南

### 添加新功能模块

1. 在 `lib/features/` 下创建新的功能目录
2. 按照以下结构组织代码：

```text
feature_name/
├── data/
│   ├── models/
│   ├── repositories/
│   └── data_sources/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── use_cases/
└── presentation/
    ├── pages/
    ├── widgets/
    └── providers/
```

### 添加新的API接口

1. 在对应的服务类中添加方法
2. 使用统一的错误处理
3. 添加相应的单元测试

### 添加新的UI组件

1. 在 `lib/shared/widgets/` 创建组件
2. 编写Widget测试
3. 在Storybook中展示（如果需要）

## ✨ 功能特性

### 核心功能

- 🔐 **用户认证系统** - 登录/注册、会话管理、自动登录
- 🏠 **首页模块** - 底部导航、主页内容、数据展示
- 👤 **个人中心** - 用户信息管理、设置页面
- ⚙️ **设置模块** - 主题切换、语言设置
- 🚀 **引导页** - 应用首次启动引导

### 技术特性

- 📊 **状态管理** - Riverpod 响应式状态管理
- 🔧 **依赖注入** - GetIt + Injectable 高性能DI
- 📱 **屏幕适配** - flutter_screenutil 多尺寸适配
- 🌐 **国际化** - 中英文双语支持
- 🎨 **主题系统** - Material 3 浅色/深色主题
- 📝 **日志监控** - Talker 高级日志和错误追踪
- 🧪 **完整测试** - 单元/Widget/集成测试覆盖

## 🐛 故障排除

### 常见问题

1. **依赖冲突**

   ```bash
   flutter clean
   flutter pub get
   ```

2. **代码生成失败**

   ```bash
   dart run build_runner clean
   dart run build_runner build --delete-conflicting-outputs
   ```

3. **Freezed 生成错误**

   ```bash
   # 检查模型类是否为 abstract class
   # 确保使用了正确的注解
   @freezed
   abstract class MyModel with _$MyModel {
     const factory MyModel({...}) = _MyModel;
   }
   ```

4. **GetIt 注册失败**

   ```bash
   # 检查服务是否有 @singleton 或 @injectable 注解
   # 重新生成依赖注册代码
   dart run build_runner build --delete-conflicting-outputs
   ```

5. **Riverpod 状态未更新**

   ```bash
   # 检查 Provider 是否正确定义
   # 确保使用了正确的 ref.watch 或 ref.read
   # 重新生成 Riverpod 代码
   dart run build_runner build --delete-conflicting-outputs
   ```

### 调试技巧

- 使用 `Talker` 记录和监控应用日志
- 使用 `AppLogger` 记录关键信息  
- 检查网络请求日志（Dio + PrettyDioLogger）
- 使用Flutter Inspector调试UI
- 利用Riverpod DevTools监控状态变化

## 📄 许可证

MIT License

## 🤝 贡献指南

1. Fork 项目
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开 Pull Request

## 📞 支持

如果您在使用过程中遇到问题，请：

1. 查看 [FAQ](docs/FAQ.md)
2. 搜索已有的 [Issues](https://github.com/your-repo/issues)
3. 创建新的 Issue

## 🎯 待办事项

- [ ] 添加推送通知支持
- [ ] 集成分析统计
- [ ] 添加更多UI组件库
- [ ] 支持更多语言（日语、韩语等）
- [ ] 添加CI/CD配置
- [ ] 集成Sentry错误监控
- [ ] 添加性能监控
- [ ] 支持Web端适配

---

## Happy Coding! 🎉
