class ApiStringConstants {
  static const String baseUrl = 'https://ali.ba-tech.tech/api';
  static const String baseStorageUrl = 'http://ali.ba-tech.tech/storage/';
   static const String addPaidServiceUrl = '/servings/add-paid';
  static const String addVoluntaryServiceUrl = '/servings/add-voluntary';
  static const String addBarterServiceUrl = '/servings/add-barter';
  static const String getPaymentUnitsUrl = '/payment-units';
  static const String getCategoriesUrl = '/categories/search';
  static const String getCategoriesAllUrl = '/categories';
  static const String getServingTypesUrl = '/serving-types';
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
  static const String chatsUrl = '/chats';
  static String updateGroupUrl(int chatId) => '/chats/$chatId';
  static String messagesUrl(int chatId) => '/chats/$chatId/messages';
  static String markAsReadUrl(int chatId) => '/chats/$chatId/read';
  static String markAsReceivedUrl(int chatId) => '/chats/$chatId/received';
  static String membersUrl(int chatId) => '/chats/$chatId/members';
  static String removeMemberUrl(int chatId, int userId) => '/chats/$chatId/members/$userId';
  static String leaveGroupUrl(int chatId) => '/chats/$chatId/leave';
  static String typingUrl(int chatId) => '/chats/$chatId/typing';
  static String stopTypingUrl(int chatId) => '/chats/$chatId/stop-typing';
  static const String complaintsUrl = '/complaints';
  static const String myComplaintsUrl = '/my-complaints';
  static String userProfileUrl(int userId) => '/users/$userId';
  static const String updateProfileUrl = '/profile';

  static const String wsHost = 'ali.ba-tech.tech';
  static const String wsKey = 'app-key';
  static const int wsPort = 443;
  static const String wsAuthEndpoint = '/broadcasting/auth';
}

