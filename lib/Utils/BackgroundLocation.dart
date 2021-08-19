import 'package:background_location/background_location.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: camel_case_types
class bgServices {
  void checkPermission() {
    BackgroundLocation.checkPermissions().then((status) {
      startBackgroundService();
    });
  }

  void startBackgroundService() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var d = prefs.getString('node');
    BackgroundLocation.getPermissions(
      onGranted: () {
        BackgroundLocation.setAndroidNotification(
          title: "Location Service Started",
          message: "Ride Share App Is Getting Your Location",
          icon: "@mipmap/ic_launcher",
        ); // Start location service here or do something else
      d== '' ? startBackgroundService() :
        BackgroundLocation.startLocationService();
        BackgroundLocation.getLocationUpdates((location) {
          print(location.longitude);
          addDbNode(d,location.latitude.toString(),location.longitude.toString());
        });
      },

      onDenied: () {
        // Show a message asking the user to reconsider or do something else
      },
    );
  }

  void stopService(){
    BackgroundLocation.stopLocationService();
  }
  void addDbNode(var name,var lt,var ln){
    final databaseReference = FirebaseDatabase.instance.reference();
    databaseReference.child(name).set({'lat': lt,
      'lng':ln});
  }
}