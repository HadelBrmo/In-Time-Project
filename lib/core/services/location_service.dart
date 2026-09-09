import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService {
  static Future<String> getAddressFromCoords(LatLng position) async {
    try {
      final url = Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}&accept-language=ar'
      );

      final response = await http.get(url, headers: {
        'User-Agent': 'inTime/1.0 '
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['display_name'] ?? "عنوان غير معروف";
      } else {
        return "فشل جلب العنوان";
      }
    } catch (e) {
      return "خطأ في الاتصال بالخريطة";
    }
  }
}