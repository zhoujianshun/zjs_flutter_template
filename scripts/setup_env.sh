#!/bin/bash

# 环境配置文件设置脚本
# Environment Configuration Setup Script

echo "🚀 Sky ElderCare Family - 环境配置设置"
echo "======================================"

# 检查是否存在配置模板
if [ ! -f "config/env.example" ]; then
    echo "❌ 错误：找不到配置模板文件 config/env.example"
    exit 1
fi

# 创建开发环境配置
echo "📝 创建开发环境配置文件..."
if [ ! -f ".env.dev" ]; then
    cp config/env.example .env.dev
    
    # 自定义开发环境配置
    sed -i.bak 's/APP_NAME=Sky ElderCare Family/APP_NAME=Sky ElderCare Family (DEV)/' .env.dev
    sed -i.bak 's|API_BASE_URL=https://api.example.com|API_BASE_URL=https://dev-api.example.com|' .env.dev
    sed -i.bak 's/DEBUG=false/DEBUG=true/' .env.dev
    sed -i.bak 's/ENABLE_DEBUG_TOOLS=false/ENABLE_DEBUG_TOOLS=true/' .env.dev
    sed -i.bak 's/ENABLE_DEBUG_BANNER=false/ENABLE_DEBUG_BANNER=true/' .env.dev
    sed -i.bak 's/ENABLE_ANALYTICS=true/ENABLE_ANALYTICS=false/' .env.dev
    sed -i.bak 's/ENABLE_CRASH_REPORTING=true/ENABLE_CRASH_REPORTING=false/' .env.dev
    sed -i.bak 's/ENABLE_EXPERIMENTAL_FEATURES=false/ENABLE_EXPERIMENTAL_FEATURES=true/' .env.dev
    sed -i.bak 's/ENABLE_BETA_FEATURES=false/ENABLE_BETA_FEATURES=true/' .env.dev
    sed -i.bak 's/LOG_LEVEL=info/LOG_LEVEL=debug/' .env.dev
    sed -i.bak 's/ENABLE_FILE_LOGGING=false/ENABLE_FILE_LOGGING=true/' .env.dev
    sed -i.bak 's/ENABLE_REMOTE_LOGGING=true/ENABLE_REMOTE_LOGGING=false/' .env.dev
    sed -i.bak 's/ENABLE_SSL_PINNING=true/ENABLE_SSL_PINNING=false/' .env.dev
    sed -i.bak 's/ENABLE_CERTIFICATE_TRANSPARENCY=true/ENABLE_CERTIFICATE_TRANSPARENCY=false/' .env.dev
    sed -i.bak 's/ENVIRONMENT=production/ENVIRONMENT=development/' .env.dev
    
    # 清理备份文件
    rm -f .env.dev.bak
    
    echo "✅ 已创建 .env.dev"
else
    echo "⚠️  .env.dev 已存在，跳过创建"
fi

# 创建预发布环境配置
echo "📝 创建预发布环境配置文件..."
if [ ! -f ".env.staging" ]; then
    cp config/env.example .env.staging
    
    # 自定义预发布环境配置
    sed -i.bak 's/APP_NAME=Sky ElderCare Family/APP_NAME=Sky ElderCare Family (STAGING)/' .env.staging
    sed -i.bak 's|API_BASE_URL=https://api.example.com|API_BASE_URL=https://staging-api.example.com|' .env.staging
    sed -i.bak 's/ENABLE_DEBUG_TOOLS=false/ENABLE_DEBUG_TOOLS=true/' .env.staging
    sed -i.bak 's/ENABLE_EXPERIMENTAL_FEATURES=false/ENABLE_EXPERIMENTAL_FEATURES=false/' .env.staging
    sed -i.bak 's/ENVIRONMENT=production/ENVIRONMENT=staging/' .env.staging
    
    # 清理备份文件
    rm -f .env.staging.bak
    
    echo "✅ 已创建 .env.staging"
else
    echo "⚠️  .env.staging 已存在，跳过创建"
fi

# 创建生产环境配置
echo "📝 创建生产环境配置文件..."
if [ ! -f ".env.prod" ]; then
    cp config/env.example .env.prod
    echo "✅ 已创建 .env.prod"
else
    echo "⚠️  .env.prod 已存在，跳过创建"
fi

echo ""
echo "🎉 环境配置文件创建完成！"
echo ""
echo "⚠️  重要提醒："
echo "1. 请根据实际需求修改各环境的配置值"
echo "2. 生产环境的密钥和API Key必须使用真实有效的值"
echo "3. 不要将包含敏感信息的 .env 文件提交到版本控制"
echo ""
echo "📚 详细配置说明请查看：config/README.md"
echo ""
echo "🚀 现在可以运行项目了："
echo "   flutter run --dart-define=ENV=dev"
