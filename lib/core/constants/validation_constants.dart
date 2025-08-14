/// 验证相关常量定义
class ValidationConstants {
  // 私有构造函数，防止实例化
  ValidationConstants._();
  
  // ==================== 正则表达式 ====================
  
  /// 邮箱验证正则
  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  
  /// 手机号验证正则（中国大陆）
  static final RegExp phoneRegex = RegExp(r'^1[3-9]\d{9}$');
  
  /// 密码强度验证正则（至少8位，包含大小写字母和数字）
  static final RegExp strongPasswordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$');
  
  /// 用户名验证正则（字母、数字、下划线，3-20位）
  static final RegExp usernameRegex = RegExp(r'^[a-zA-Z0-9_]{3,20}$');
  
  /// 身份证号验证正则（18位）
  static final RegExp idCardRegex = RegExp(r'^\d{17}[\dXx]$');
  
  /// URL验证正则
  static final RegExp urlRegex = RegExp(
    r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
  );
  
  /// 数字验证正则（整数）
  static final RegExp integerRegex = RegExp(r'^-?\d+$');
  
  /// 小数验证正则（保留2位小数）
  static final RegExp decimalRegex = RegExp(r'^\d+(\.\d{1,2})?$');
  
  /// 中文字符验证正则
  static final RegExp chineseRegex = RegExp(r'^[\u4e00-\u9fa5]+$');
  
  /// 英文字符验证正则
  static final RegExp englishRegex = RegExp(r'^[a-zA-Z]+$');
  
  /// 字母数字组合验证正则
  static final RegExp alphanumericRegex = RegExp(r'^[a-zA-Z0-9]+$');
  
  // ==================== 长度限制 ====================
  
  /// 用户名长度限制
  static const int usernameMinLength = 3;
  static const int usernameMaxLength = 20;
  
  /// 密码长度限制
  static const int passwordMinLength = 8;
  static const int passwordMaxLength = 128;
  
  /// 昵称长度限制
  static const int nicknameMinLength = 1;
  static const int nicknameMaxLength = 30;
  
  /// 邮箱长度限制
  static const int emailMaxLength = 254;
  
  /// 手机号长度限制
  static const int phoneLength = 11;
  
  /// 验证码长度限制
  static const int verificationCodeLength = 6;
  
  /// 评论内容长度限制
  static const int commentMinLength = 1;
  static const int commentMaxLength = 1000;
  
  /// 文章标题长度限制
  static const int titleMinLength = 1;
  static const int titleMaxLength = 100;
  
  /// 文章内容长度限制
  static const int contentMinLength = 10;
  static const int contentMaxLength = 50000;
  
  /// 个人简介长度限制
  static const int bioMaxLength = 500;
  
  // ==================== 数值限制 ====================
  
  /// 年龄限制
  static const int minAge = 1;
  static const int maxAge = 150;
  
  /// 金额限制（分）
  static const int minAmount = 1; // 0.01元
  static const int maxAmount = 999999999; // 9999999.99元
  
  /// 评分限制
  static const double minRating = 0.0;
  static const double maxRating = 5.0;
  
  /// 文件大小限制（字节）
  static const int maxImageSize = 10 * 1024 * 1024; // 10MB
  static const int maxVideoSize = 100 * 1024 * 1024; // 100MB
  static const int maxDocumentSize = 50 * 1024 * 1024; // 50MB
  
  // ==================== 格式验证 ====================
  
  /// 支持的图片格式
  static const List<String> supportedImageFormats = [
    'jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'
  ];
  
  /// 支持的视频格式
  static const List<String> supportedVideoFormats = [
    'mp4', 'avi', 'mov', 'wmv', 'flv', 'mkv'
  ];
  
  /// 支持的文档格式
  static const List<String> supportedDocumentFormats = [
    'pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'txt'
  ];
  
  // ==================== 验证方法 ====================
  
  /// 验证邮箱格式
  static bool isValidEmail(String? email) {
    if (email == null || email.isEmpty) return false;
    return emailRegex.hasMatch(email) && email.length <= emailMaxLength;
  }
  
  /// 验证手机号格式
  static bool isValidPhone(String? phone) {
    if (phone == null || phone.isEmpty) return false;
    return phoneRegex.hasMatch(phone);
  }
  
  /// 验证密码强度
  static bool isStrongPassword(String? password) {
    if (password == null || password.isEmpty) return false;
    return password.length >= passwordMinLength &&
           password.length <= passwordMaxLength &&
           strongPasswordRegex.hasMatch(password);
  }
  
  /// 验证用户名格式
  static bool isValidUsername(String? username) {
    if (username == null || username.isEmpty) return false;
    return usernameRegex.hasMatch(username);
  }
  
  /// 验证身份证号
  static bool isValidIdCard(String? idCard) {
    if (idCard == null || idCard.isEmpty) return false;
    return idCardRegex.hasMatch(idCard);
  }
  
  /// 验证URL格式
  static bool isValidUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    return urlRegex.hasMatch(url);
  }
  
  /// 验证年龄范围
  static bool isValidAge(int? age) {
    if (age == null) return false;
    return age >= minAge && age <= maxAge;
  }
  
  /// 验证金额范围
  static bool isValidAmount(int? amount) {
    if (amount == null) return false;
    return amount >= minAmount && amount <= maxAmount;
  }
  
  /// 验证评分范围
  static bool isValidRating(double? rating) {
    if (rating == null) return false;
    return rating >= minRating && rating <= maxRating;
  }
  
  /// 验证文件大小
  static bool isValidFileSize(int? fileSize, String fileType) {
    if (fileSize == null) return false;
    
    switch (fileType.toLowerCase()) {
      case 'image':
        return fileSize <= maxImageSize;
      case 'video':
        return fileSize <= maxVideoSize;
      case 'document':
        return fileSize <= maxDocumentSize;
      default:
        return fileSize <= maxDocumentSize;
    }
  }
  
  /// 验证文件格式
  static bool isValidFileFormat(String? fileName, String fileType) {
    if (fileName == null || fileName.isEmpty) return false;
    
    final extension = fileName.split('.').last.toLowerCase();
    
    switch (fileType.toLowerCase()) {
      case 'image':
        return supportedImageFormats.contains(extension);
      case 'video':
        return supportedVideoFormats.contains(extension);
      case 'document':
        return supportedDocumentFormats.contains(extension);
      default:
        return false;
    }
  }
  
  /// 验证字符串长度
  static bool isValidLength(String? text, int minLength, int maxLength) {
    if (text == null) return minLength == 0;
    return text.length >= minLength && text.length <= maxLength;
  }
  
  /// 验证是否为空或空白字符串
  static bool isNotEmpty(String? text) {
    return text != null && text.trim().isNotEmpty;
  }
  
  /// 验证是否包含特殊字符
  static bool containsSpecialCharacters(String? text) {
    if (text == null || text.isEmpty) return false;
    return RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(text);
  }
  
  /// 验证是否为纯中文
  static bool isChineseOnly(String? text) {
    if (text == null || text.isEmpty) return false;
    return chineseRegex.hasMatch(text);
  }
  
  /// 验证是否为纯英文
  static bool isEnglishOnly(String? text) {
    if (text == null || text.isEmpty) return false;
    return englishRegex.hasMatch(text);
  }
  
  /// 验证是否为字母数字组合
  static bool isAlphanumeric(String? text) {
    if (text == null || text.isEmpty) return false;
    return alphanumericRegex.hasMatch(text);
  }
}
