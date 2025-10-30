class ApiConstants {
  static const String baseUrl = 'http://192.168.1.5:5000';
  // static const String baseUrl = 'http://10.0.2.2:5000';
  static const String login = '/api/Auth/login';
  static const String register = '/api/Auth/register';
  static const String refreshToken = '/api/Auth/refresh-token';
  static const String authorisedMe = '/api/Auth/AuthorisedMe';
  static const String logout = '/api/Auth/logout';
  static const String changePassword = '/api/Auth/ChangePassword';
  static const String cart = '/cart';
  static const String orders = '/orders';
  static const String sendOtp = '/api/ForgetPassword/SendOtp';
  static const String verifyOtp = "/api/ForgetPassword/OTPVerification";
  static const String resetPassword = "/api/ForgetPassword/ResetPassword";

  static const Duration timeoutDuration = Duration(seconds: 60);
  static const Duration tokenRefreshThreshold = Duration(minutes: 5);

  static const String installation_api =
      'https://script.google.com/macros/s/AKfycbwf1Kb9YlxPxDcgS9xO41qN87GoNODabli_3O7D4N3b0hGb9F6Bm08Nmc9f-R_5FGG2/exec';
  static const String stockIn_api = '/api/StockInOut';
  static const String stockOut_api = '/api/StockInOut';
  static const String inhouse_api = '/api/InventoryHistory';
  static const String vendor_and_project_api =
      'https://script.google.com/macros/s/AKfycbyYovYWTRB6MkZD3--oMPt0k6luRnxUrCg-WqP7kg5jRMHI1Pi37vOW6UvJ-3xgDa_R/exec';
}
