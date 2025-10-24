class ApiConstants {
  static const String baseUrl = 'http://192.168.10.163:5000';
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
}