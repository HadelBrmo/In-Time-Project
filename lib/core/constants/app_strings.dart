class ApiStringConstants {
  static const String baseUrl = 'http://ali.ba-tech.tech/api';
   static const String addPaidServiceUrl = '/servings/add-paid';
  static const String getPaymentUnitsUrl = '/payment-units';
  static const String getCategoriesUrl = '/categories';
  static const String loginUrl = '/auth/login';
  static const String sendOtpUrl = '/auth/send-otp';
  static const String registerCustomerUrl = '/auth/register-customer';
  static const String searchServingsUrl = '/servings/search';
  static const String getMyRequestsUrl = '/servings/requests/my';
  static const String createRequestUrl = '/servings/requests';
  static const String getServingDetailsUrl = '/servings/';
  static const String walletsUrl = '/wallets';
  static const String deleteRequestUrl = '/servings/requests/';
  static const String getReceivedRequestsUrl = '/servings/requests/received';
  static String acceptRequestUrl(int id) => '/servings/requests/$id/accept';
  static String rejectRequestUrl(int id) => '/servings/requests/$id/reject';
  static const String getMyServingsUrl = '/servings/my';
  static String updateAvailabilityUrl(int serviceId) => '/servings/$serviceId/availability-slots';
}

