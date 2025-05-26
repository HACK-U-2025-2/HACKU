import 'package:device_info_plus/device_info_plus.dart';
import 'package:frontend/repositories/user_id_repository/user_id_repository.dart';

class DeviceUserIdRepository implements UserIdRepository {
  @override
  Future<String> getUserId() async {
    final deviceInfo = await DeviceInfoPlugin().deviceInfo;
    final userId = switch (deviceInfo) {
      final AndroidDeviceInfo androidInfo => androidInfo.id,
      final IosDeviceInfo iosInfo => iosInfo.identifierForVendor,
      final WebBrowserInfo webInfo => webInfo.userAgent,
      _ => null,
    };

    if (userId == null) {
      throw Exception('User ID is null');
    }

    return userId;
  }
}
