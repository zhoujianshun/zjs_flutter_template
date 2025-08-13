# Flutter项目常用命令

.PHONY: help get clean build-runner gen-l10n test format analyze run-debug run-release

# 默认命令 - 显示帮助
help:
	@echo "Flutter项目常用命令:"
	@echo "  get           - 获取依赖包"
	@echo "  clean         - 清理项目"
	@echo "  build-runner  - 运行代码生成"
	@echo "  gen-l10n      - 生成国际化文件"
	@echo "  test          - 运行所有测试"
	@echo "  format        - 格式化代码"
	@echo "  analyze       - 分析代码"
	@echo "  run-debug     - 运行Debug版本"
	@echo "  run-release   - 运行Release版本"
	@echo "  build-apk     - 构建APK"
	@echo "  build-ios     - 构建iOS"

# 获取依赖包
get:
	flutter pub get

# 清理项目
clean:
	flutter clean
	flutter pub get

# 运行代码生成
build-runner:
	flutter packages pub run build_runner build --delete-conflicting-outputs

# 监听代码变化并生成
watch:
	flutter packages pub run build_runner watch --delete-conflicting-outputs

# 生成国际化文件
gen-l10n:
	flutter gen-l10n

# 运行所有测试
test:
	flutter test

# 运行单元测试
test-unit:
	flutter test test/unit/

# 运行Widget测试
test-widget:
	flutter test test/widget/

# 运行集成测试
test-integration:
	flutter test integration_test/

# 格式化代码
format:
	dart format lib/ test/

# 分析代码
analyze:
	flutter analyze

# 运行Debug版本
run-debug:
	flutter run --debug

# 运行Release版本
run-release:
	flutter run --release

# 构建APK
build-apk:
	flutter build apk

# 构建APK Bundle
build-appbundle:
	flutter build appbundle

# 构建iOS
build-ios:
	flutter build ios

# 完整开发流程
dev-setup: clean build-runner gen-l10n

# 发布前检查
pre-release: format analyze test

# 快速启动开发环境
dev: get gen-l10n run-debug
