/// 分析服务接口
///
/// 定义了用户行为分析服务的标准接口，方便后续接入不同的分析平台
abstract class IAnalyticsService {
  /// 初始化分析服务
  Future<void> initialize();

  /// 记录自定义事件
  ///
  /// [eventName] 事件名称
  /// [parameters] 事件参数
  Future<void> trackEvent(String eventName, {Map<String, dynamic>? parameters});

  /// 记录页面访问
  ///
  /// [screenName] 页面名称
  /// [screenClass] 页面类名
  Future<void> trackPageView(String screenName, {String? screenClass});

  /// 设置用户属性
  ///
  /// [userId] 用户ID
  /// [properties] 用户属性
  Future<void> setUserProperties({
    String? userId,
    Map<String, dynamic>? properties,
  });

  /// 记录用户登录事件
  ///
  /// [method] 登录方式
  Future<void> trackLogin({String? method});

  /// 记录用户注册事件
  ///
  /// [method] 注册方式
  Future<void> trackSignUp({String? method});

  /// 记录搜索事件
  ///
  /// [searchTerm] 搜索关键词
  /// [category] 搜索分类
  Future<void> trackSearch(String searchTerm, {String? category});

  /// 记录分享事件
  ///
  /// [contentType] 内容类型
  /// [itemId] 项目ID
  /// [method] 分享方式
  Future<void> trackShare({
    required String contentType,
    required String itemId,
    required String method,
  });

  /// 记录应用生命周期事件
  ///
  /// [event] 生命周期事件
  Future<void> trackAppLifecycle(String event);

  /// 检查分析服务是否已初始化
  bool get isInitialized;

  /// 获取分析服务名称
  String get serviceName;
}

/// 预定义的事件名称常量
class AnalyticsEvents {
  static const String login = 'login';
  static const String logout = 'logout';
  static const String signUp = 'sign_up';
  static const String search = 'search';
  static const String share = 'share';
  static const String pageView = 'page_view';
  static const String buttonClick = 'button_click';
  static const String formSubmit = 'form_submit';
  static const String purchase = 'purchase';
  static const String appStart = 'app_start';
  static const String appForeground = 'app_foreground';
  static const String appBackground = 'app_background';
  static const String appCrash = 'app_crash';
  static const String error = 'error';
}

/// 预定义的用户属性常量
class UserProperties {
  static const String userId = 'user_id';
  static const String email = 'email';
  static const String username = 'username';
  static const String plan = 'plan';
  static const String signUpDate = 'sign_up_date';
  static const String lastLoginDate = 'last_login_date';
  static const String userType = 'user_type';
  static const String language = 'language';
  static const String country = 'country';
  static const String deviceType = 'device_type';
}
