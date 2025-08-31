import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  /// 📌 إرجاع الموقع الحالي أو `null` إذا مرفوض/مغلق
  static Future<Position?> getCurrentLocation() async {
    try {
      // 1. طلب الإذن
      var status = await Permission.locationWhenInUse.request();

      if (!status.isGranted) {
        // المستخدم رفض → نفتح له إعدادات التطبيق
        openAppSettings();
        return null;
      }

      // 2. تحقق من تفعيل خدمة الموقع
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return null;
      }

      // 3. جلب الإحداثيات
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best, // أدق حاجة
      );
    } catch (e) {
      // في حالة خطأ (مثلاً GPS موقف ولا Exception أخرى)
      print("❌ Location Error: $e");
      return null;
    }
  }
}
