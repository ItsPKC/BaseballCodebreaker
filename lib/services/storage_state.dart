// import 'package:device_info/device_info.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class MyDeviceStorage{
//   Future<Permission> get sdkBasedStoragePermission async{
//     DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//     AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//     myDeviceVersion = androidInfo.version.sdkInt;
//     var tempPermissionType = (myDeviceVersion > 29)
//         ? Permission.manageExternalStorage
//         : Permission.storage;
//
//     return tempPermissionType;
//   }
// }
//
//
// print('VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV$myDeviceVersion');
// DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
// AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
// myDeviceVersion = androidInfo.version.sdkInt;
// sdkBasedStoragePermission = (myDeviceVersion > 29)
// ? Permission.manageExternalStorage
//     : Permission.storage;
// if (myDeviceVersion <= 29) {
// // Android 10 = API 29 , i.e upto android 10.
// // Environment.getExternalStorageDirectory()
// baseLocation = '/storage/emulated/0';
// baseEmulatedLocation = '/storage/emulated/999';
// } else {
// baseLocation = '/storage/emulated/0/Android/media/com.whatsapp';
// baseEmulatedLocation = '/storage/emulated/999/Android/media/com.whatsapp';
// }
// print('VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV$myDeviceVersion');