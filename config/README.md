# 配置文件说明

## 环境配置文件 (.env)

由于系统安全限制，无法直接创建 `.env` 文件。请按照以下步骤手动创建：

### 1. 创建环境配置文件

在项目根目录下创建以下文件：

```bash
# 开发环境
.env.dev

# 预发布环境  
.env.staging

# 生产环境
.env.prod
```

### 2. 复制配置模板

将 `config/env.example` 文件的内容复制到对应的环境文件中。

### 3. 环境特定配置

#### 开发环境 (.env.dev)
```bash
APP_NAME=Sky ElderCare Family (DEV)
API_BASE_URL=https://dev-api.example.com
DEBUG=true
ENABLE_DEBUG_TOOLS=true
ENABLE_ANALYTICS=false
LOG_LEVEL=debug
ENABLE_SSL_PINNING=false
```

#### 预发布环境 (.env.staging)
```bash
APP_NAME=Sky ElderCare Family (STAGING)
API_BASE_URL=https://staging-api.example.com
DEBUG=false
ENABLE_DEBUG_TOOLS=true
ENABLE_ANALYTICS=true
LOG_LEVEL=info
ENABLE_SSL_PINNING=true
```

#### 生产环境 (.env.prod)
```bash
APP_NAME=Sky ElderCare Family
API_BASE_URL=https://api.example.com
DEBUG=false
ENABLE_DEBUG_TOOLS=false
ENABLE_ANALYTICS=true
LOG_LEVEL=warning
ENABLE_SSL_PINNING=true
```

### 4. 安全注意事项

⚠️ **重要提醒**：
- 不要将包含敏感信息的 `.env` 文件提交到版本控制系统
- 在 `.gitignore` 中添加 `.env*` 规则
- 生产环境的密钥和API Key必须使用真实有效的值
- JWT_SECRET 和 ENCRYPTION_KEY 必须足够复杂且唯一

### 5. 配置验证

应用启动时会自动验证配置：
- 开发环境：警告级别验证
- 生产环境：严格验证，配置不当会启动失败

### 6. 使用方式

```dart
// 在 main.dart 中初始化
await ConfigManager.initialize(
  environment: Environment.development, // 根据构建环境选择
);

// 访问配置
final apiUrl = ConfigManager.apiBaseUrl;
final isDebug = ConfigManager.isDebug;
```

## 配置项说明

### 应用基础信息
- `APP_NAME`: 应用显示名称
- `APP_VERSION`: 应用版本号
- `BUILD_NUMBER`: 构建号
- `PACKAGE_NAME`: 包名

### 网络配置
- `API_BASE_URL`: API服务器地址
- `CONNECT_TIMEOUT`: 连接超时时间(毫秒)
- `RECEIVE_TIMEOUT`: 接收超时时间(毫秒)
- `SEND_TIMEOUT`: 发送超时时间(毫秒)
- `MAX_RETRIES`: 最大重试次数
- `RETRY_DELAY`: 重试延迟时间(毫秒)

### 功能开关
- `DEBUG`: 是否启用调试模式
- `ENABLE_DEBUG_TOOLS`: 是否启用调试工具
- `ENABLE_ANALYTICS`: 是否启用数据分析
- `ENABLE_CRASH_REPORTING`: 是否启用崩溃报告
- `ENABLE_BIOMETRIC`: 是否启用生物识别
- `ENABLE_PUSH_NOTIFICATIONS`: 是否启用推送通知

### 安全配置
- `JWT_SECRET`: JWT签名密钥(至少32位)
- `JWT_EXPIRY`: JWT过期时间(秒)
- `ENCRYPTION_KEY`: 数据加密密钥(32位)
- `ENCRYPTION_IV`: 加密初始向量(16位)
- `ENABLE_SSL_PINNING`: 是否启用SSL证书锁定

### 第三方服务
- `GOOGLE_MAPS_API_KEY`: Google地图API密钥
- `FIREBASE_API_KEY`: Firebase API密钥
- `ONESIGNAL_APP_ID`: OneSignal应用ID

## 故障排除

### 配置加载失败
如果配置文件加载失败，应用会使用默认配置并输出警告日志。

### 配置验证失败
生产环境下配置验证失败会导致应用启动失败，请检查必需的配置项。

### 环境变量优先级
1. 环境文件 (.env.*)
2. 系统环境变量
3. 默认配置值
