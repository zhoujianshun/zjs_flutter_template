/// 通用验证器工具类
class Validators {
  Validators._();
  
  /// 验证邮箱格式
  static bool isEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    return emailRegex.hasMatch(email);
  }
  
  /// 验证手机号格式（中国大陆）
  static bool isPhoneNumber(String phone) {
    final phoneRegex = RegExp(r'^1[3-9]\d{9}$');
    return phoneRegex.hasMatch(phone);
  }
  
  /// 验证密码强度
  /// 至少8位，包含大小写字母和数字
  static bool isStrongPassword(String password) {
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$',
    );
    return passwordRegex.hasMatch(password);
  }
  
  /// 验证身份证号格式（18位）
  static bool isIdCard(String idCard) {
    final idCardRegex = RegExp(
      r'^[1-9]\d{5}(18|19|([23]\d))\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$',
    );
    return idCardRegex.hasMatch(idCard);
  }
  
  /// 验证URL格式
  static bool isUrl(String url) {
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    return urlRegex.hasMatch(url);
  }
  
  /// 验证用户名格式
  /// 4-20位，只能包含字母、数字、下划线
  static bool isUsername(String username) {
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]{4,20}$');
    return usernameRegex.hasMatch(username);
  }
  
  /// 验证数字格式
  static bool isNumeric(String str) {
    return double.tryParse(str) != null;
  }
  
  /// 验证整数格式
  static bool isInteger(String str) {
    return int.tryParse(str) != null;
  }
  
  /// 验证字符串长度
  static bool isLengthValid(String str, int minLength, [int? maxLength]) {
    if (str.length < minLength) return false;
    if (maxLength != null && str.length > maxLength) return false;
    return true;
  }
  
  /// 验证中文字符
  static bool isChinese(String str) {
    final chineseRegex = RegExp(r'^[\u4e00-\u9fa5]+$');
    return chineseRegex.hasMatch(str);
  }
  
  /// 验证银行卡号格式
  static bool isBankCard(String cardNumber) {
    final bankCardRegex = RegExp(r'^\d{16,19}$');
    return bankCardRegex.hasMatch(cardNumber);
  }
  
  /// 验证车牌号格式
  static bool isLicensePlate(String plate) {
    final plateRegex = RegExp(
      r'^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领][A-Z][A-Z0-9]{4}[A-Z0-9挂学警港澳]$',
    );
    return plateRegex.hasMatch(plate);
  }
}
