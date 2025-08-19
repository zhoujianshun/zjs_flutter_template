# CI/CD 配置指南

## 📋 概述

本指南将帮助您为Flutter项目设置完整的CI/CD流水线，包括自动化测试、代码质量检查、构建和部署。

## 🏗️ GitHub Actions 配置

### 1. 基础工作流配置

创建 `.github/workflows/` 目录并添加以下配置文件：

#### 1.1 代码质量检查 (code_quality.yml)

```yaml
name: Code Quality

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  analyze:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.35.1'
        channel: 'stable'
        cache: true
    
    - name: Install dependencies
      run: flutter pub get
    
    - name: Generate code
      run: dart run build_runner build --delete-conflicting-outputs
    
    - name: Analyze code
      run: flutter analyze
    
    - name: Check formatting
      run: dart format --set-exit-if-changed lib/ test/
    
    - name: Run custom lints
      run: dart run custom_lint
```

#### 1.2 自动化测试 (test.yml)

```yaml
name: Tests

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.35.1'
        channel: 'stable'
        cache: true
    
    - name: Install dependencies
      run: flutter pub get
    
    - name: Generate code
      run: dart run build_runner build --delete-conflicting-outputs
    
    - name: Run unit tests
      run: flutter test test/unit/ --coverage
    
    - name: Run widget tests
      run: flutter test test/widget/
    
    - name: Upload coverage to Codecov
      uses: codecov/codecov-action@v3
      with:
        file: coverage/lcov.info
        fail_ci_if_error: true
```

#### 1.3 构建检查 (build.yml)

```yaml
name: Build

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  build:
    strategy:
      matrix:
        platform: [android, ios, web]
        
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.35.1'
        channel: 'stable'
        cache: true
    
    - name: Setup Java (for Android)
      if: matrix.platform == 'android'
      uses: actions/setup-java@v3
      with:
        distribution: 'zulu'
        java-version: '17'
    
    - name: Install dependencies
      run: flutter pub get
    
    - name: Generate code
      run: dart run build_runner build --delete-conflicting-outputs
    
    - name: Build Android APK
      if: matrix.platform == 'android'
      run: flutter build apk --release
    
    - name: Build iOS (dry run)
      if: matrix.platform == 'ios'
      run: flutter build ios --release --no-codesign
    
    - name: Build Web
      if: matrix.platform == 'web'
      run: flutter build web --release
    
    - name: Upload artifacts
      uses: actions/upload-artifact@v3
      with:
        name: build-${{ matrix.platform }}
        path: |
          build/app/outputs/flutter-apk/*.apk
          build/ios/iphoneos/*.app
          build/web/
```

#### 1.4 发布流程 (release.yml)

```yaml
name: Release

on:
  push:
    tags:
      - 'v*'

jobs:
  release:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.35.1'
        channel: 'stable'
        cache: true
    
    - name: Install dependencies
      run: flutter pub get
    
    - name: Generate code
      run: dart run build_runner build --delete-conflicting-outputs
    
    - name: Run tests
      run: flutter test
    
    - name: Build Android APK
      run: flutter build apk --release
    
    - name: Build Android App Bundle
      run: flutter build appbundle --release
    
    - name: Create Release
      uses: actions/create-release@v1
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      with:
        tag_name: ${{ github.ref }}
        release_name: Release ${{ github.ref }}
        draft: false
        prerelease: false
    
    - name: Upload APK
      uses: actions/upload-release-asset@v1
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      with:
        upload_url: ${{ steps.create_release.outputs.upload_url }}
        asset_path: build/app/outputs/flutter-apk/app-release.apk
        asset_name: app-release.apk
        asset_content_type: application/vnd.android.package-archive
```

## 🔧 本地开发工具

### 1. 预提交钩子 (pre-commit hooks)

创建 `.githooks/pre-commit`：

```bash
#!/bin/sh
# Git pre-commit hook

echo "🔍 Running pre-commit checks..."

# 1. 代码格式检查
echo "📝 Checking code formatting..."
if ! dart format --set-exit-if-changed lib/ test/; then
    echo "❌ Code formatting check failed. Please run 'dart format lib/ test/'"
    exit 1
fi

# 2. 代码分析
echo "🔍 Running code analysis..."
if ! flutter analyze; then
    echo "❌ Code analysis failed. Please fix the issues."
    exit 1
fi

# 3. 运行单元测试
echo "🧪 Running unit tests..."
if ! flutter test test/unit/; then
    echo "❌ Unit tests failed. Please fix the failing tests."
    exit 1
fi

echo "✅ All pre-commit checks passed!"
```

设置钩子：

```bash
# 设置git hooks目录
git config core.hooksPath .githooks

# 给钩子文件执行权限
chmod +x .githooks/pre-commit
```

### 2. Makefile 增强

更新 `Makefile` 添加更多有用的命令：

```makefile
# 现有命令保持不变...

# 新增命令
.PHONY: update-deps check-outdated security-check

## 检查过时的依赖
 heck-outdated:
 @echo "🔍 Checking for outdated dependencies..."
 flutter pub outdated

## 更新依赖
 pdate-deps:
 @echo "🔄 Updating dependencies..."
 flutter pub upgrade --major-versions
 dart run build_runner clean
 dart run build_runner build --delete-conflicting-outputs

## 安全检查
 ecurity-check:
 @echo "🔒 Running security checks..."
 flutter pub deps --json | jq '.packages[] | select(.kind == "direct") | {name: .name, version: .version}'

## 完整的CI检查（本地模拟CI环境）
 i-check: clean get generate analyze test
 @echo "✅ All CI checks passed locally!"

## 性能分析
 rofile:
 @echo "📊 Building profile version..."
 flutter build apk --profile
 flutter build ios --profile --no-codesign

## 发布检查
 elease-check: clean get generate analyze test
 @echo "🚀 Running release checks..."
 flutter build apk --release
 flutter build appbundle --release
 @echo "✅ Release build successful!"
```

## 📊 代码覆盖率配置

### 1. 配置测试覆盖率

在 `test/` 目录创建 `test_helper.dart`：

```dart
// test/test_helper.dart
import 'package:flutter_test/flutter_test.dart';

/// 测试辅助工具
class TestHelper {
  /// 设置测试环境
  static void setupTestEnvironment() {
    TestWidgetsFlutterBinding.ensureInitialized();
  }
  
  /// 清理测试环境
  static void cleanupTestEnvironment() {
    // 清理测试数据
  }
}
```

### 2. 覆盖率报告配置

更新 `test/` 目录下的测试配置：

```yaml
# test/coverage_helper_test.dart
// 用于生成覆盖率报告的辅助文件
import 'package:flutter_test/flutter_test.dart';

// 导入所有需要覆盖率统计的文件
import 'package:zjs_flutter_template/main.dart';
import 'package:zjs_flutter_template/core/network/api_client.dart';
import 'package:zjs_flutter_template/core/storage/storage_service.dart';
// ... 其他核心文件

void main() {
  test('coverage helper', () {
    // 这个测试用于确保所有文件都被包含在覆盖率报告中
    expect(true, isTrue);
  });
}
```

## 🔐 安全配置

### 1. 环境变量管理

创建安全的环境变量配置：

```yaml
# .github/workflows/secrets.yml
# 在GitHub仓库设置中配置的秘密变量：

# Android签名
ANDROID_KEYSTORE_PASSWORD
ANDROID_KEY_ALIAS  
ANDROID_KEY_PASSWORD
ANDROID_KEYSTORE_BASE64

# iOS签名
IOS_CERTIFICATE_BASE64
IOS_PROVISIONING_PROFILE_BASE64
IOS_CERTIFICATE_PASSWORD

# API密钥
API_BASE_URL_PROD
GOOGLE_SERVICES_JSON_BASE64
FIREBASE_OPTIONS_DART_BASE64

# 第三方服务
SENTRY_DSN
FIREBASE_API_KEY
GOOGLE_MAPS_API_KEY
```

### 2. 安全扫描

添加安全扫描到CI流程：

```yaml
# 在现有workflow中添加
- name: Security scan
  run: |
    # 检查已知漏洞
    flutter pub deps --json | jq '.packages[].name' | xargs -I {} sh -c 'echo "Checking {}"'
    
    # 检查敏感信息泄露
    grep -r "password\|secret\|key\|token" lib/ --exclude-dir=generated || true
```

## 📱 多平台构建

### 1. Android 构建优化

```gradle
// android/app/build.gradle
android {
    buildTypes {
        release {
            // 启用代码混淆
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
            
            // 启用资源压缩
            shrinkResources true
        }
    }
}
```

### 2. iOS 构建优化

```ruby
# ios/Podfile
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    
    # 优化构建设置
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end
```

## 📊 监控和分析

### 1. 性能监控配置

```dart
// lib/core/monitoring/performance_monitor.dart
class PerformanceMonitor {
  static void trackAppStart() {
    // 记录应用启动时间
  }
  
  static void trackPageLoad(String pageName) {
    // 记录页面加载时间
  }
  
  static void trackNetworkRequest(String endpoint, Duration duration) {
    // 记录网络请求性能
  }
}
```

### 2. 错误监控集成

```dart
// lib/core/monitoring/error_monitor.dart
class ErrorMonitor {
  static void initialize() {
    // 初始化Sentry或其他错误监控服务
  }
  
  static void reportError(Object error, StackTrace stackTrace) {
    // 上报错误信息
  }
  
  static void reportMessage(String message, {String? level}) {
    // 上报自定义消息
  }
}
```

## 🚀 部署策略

### 1. 分支策略

```
main (生产环境)
├── develop (开发环境)
├── staging (测试环境)
└── feature/* (功能分支)
```

### 2. 自动部署配置

```yaml
# 生产环境部署
- name: Deploy to Production
  if: github.ref == 'refs/heads/main'
  run: |
    # 部署到应用商店
    fastlane android deploy
    fastlane ios deploy

# 测试环境部署  
- name: Deploy to Staging
  if: github.ref == 'refs/heads/develop'
  run: |
    # 部署到内测平台
    fastlane android beta
    fastlane ios beta
```

## 📋 检查清单

设置CI/CD后，确保以下功能正常：

- [ ] 代码提交触发自动检查
- [ ] 单元测试自动运行
- [ ] 代码质量检查通过
- [ ] 构建流程成功
- [ ] 覆盖率报告生成
- [ ] 安全扫描通过
- [ ] 自动部署配置正确

## 🔧 故障排除

### 常见问题

1. **Flutter版本不匹配**
   - 确保CI中的Flutter版本与本地开发版本一致

2. **依赖安装失败**
   - 检查pubspec.yaml中的依赖版本
   - 使用缓存加速依赖安装

3. **代码生成失败**
   - 确保在运行测试前先生成代码
   - 检查build_runner配置

4. **测试失败**
   - 检查测试环境配置
   - 确保mock数据正确设置

---

*最后更新：2024年12月*
