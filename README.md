# Sky Eldercare Family - Flutter模版项目

一个功能完整的Flutter应用模版，集成了现代Flutter开发的最佳实践和常用功能。

## 📱 项目特色

- ✅ **Riverpod** 状态管理 - 类型安全、强大的状态管理解决方案
- ✅ **GoRouter** 路由导航 - 官方推荐的声明式路由系统
- ✅ **Dio** 网络请求 - 功能丰富的HTTP客户端，支持拦截器
- ✅ **Hive** 本地存储 - 高性能NoSQL数据库
- ✅ **Material 3** 设计系统 - Google最新设计语言
- ✅ **国际化支持** - 多语言本地化
- ✅ **完整测试覆盖** - 单元测试、Widget测试、集成测试
- ✅ **代码规范** - 静态分析和格式化配置
- ✅ **主题切换** - 支持浅色/深色/跟随系统主题

## 🏗️ 项目架构

```
lib/
├── core/                    # 核心基础设施
│   ├── constants/          # 应用常量
│   ├── errors/             # 错误处理
│   ├── network/            # 网络配置
│   ├── storage/            # 存储服务
│   └── utils/              # 工具类
├── features/               # 功能模块
│   ├── auth/              # 认证模块
│   ├── home/              # 首页模块
│   └── profile/           # 个人中心模块
├── shared/                # 共享组件
│   ├── widgets/           # 通用UI组件
│   ├── models/            # 数据模型
│   └── services/          # 共享服务
├── config/                # 配置文件
│   ├── routes/            # 路由配置
│   ├── themes/            # 主题配置
│   └── env/               # 环境配置
├── l10n/                  # 国际化文件
└── main.dart              # 应用入口
```

## 🚀 快速开始

### 环境要求

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0

### 安装依赖

```bash
flutter pub get
```

### 生成代码

```bash
flutter packages pub run build_runner build
```

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

### 路由导航
- `go_router` - 声明式路由

### 网络请求
- `dio` - HTTP客户端
- `pretty_dio_logger` - 网络日志

### 本地存储
- `shared_preferences` - 简单键值存储
- `hive` & `hive_flutter` - NoSQL数据库
- `flutter_secure_storage` - 安全存储

### UI组件
- `cached_network_image` - 网络图片缓存
- `shimmer` - 骨架屏效果
- `lottie` - 动画支持

### 工具库
- `equatable` - 对象比较
- `dartz` - 函数式编程
- `connectivity_plus` - 网络状态监听
- `logger` - 日志记录

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
- 自动token刷新

## 📊 性能优化

### 图片缓存
- 使用 `cached_network_image` 缓存网络图片
- 内存和磁盘双重缓存

### 状态管理
- Riverpod提供最小重建
- 状态缓存和持久化
- 异步状态管理

### UI优化
- Shimmer骨架屏提升用户体验
- 合理的页面动画
- 响应式设计

## 🛠️ 开发指南

### 添加新功能模块

1. 在 `lib/features/` 下创建新的功能目录
2. 按照以下结构组织代码：

```
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

## 🐛 故障排除

### 常见问题

1. **依赖冲突**
   ```bash
   flutter clean
   flutter pub get
   ```

2. **代码生成失败**
   ```bash
   flutter packages pub run build_runner clean
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

3. **国际化文件未更新**
   ```bash
   flutter gen-l10n
   ```

### 调试技巧

- 使用 `AppLogger` 记录关键信息
- 检查网络请求日志
- 使用Flutter Inspector调试UI

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
- [ ] 添加更多UI组件
- [ ] 支持更多语言
- [ ] 添加CI/CD配置

---

**Happy Coding! 🎉**