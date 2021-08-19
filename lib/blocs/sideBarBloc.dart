import 'package:bloc/bloc.dart';
import 'package:ride_share/Screens/findRide.dart';
import 'package:ride_share/Screens/myRide.dart';
import 'package:ride_share/Screens/notifications.dart';
import 'package:ride_share/Screens/settings.dart';
import '../Screens/homePage.dart';
import '../Screens/offerRide.dart';
import 'package:shared_preferences/shared_preferences.dart';
enum NavigationEvents {
  HomePageClickedEvent,
  FindRidesClickEvent,
  OfferRideClickEvent,
  MyRideClickEvent,
  NotificationsClickEvent,
  SettingClickEvent,
  SignoutClickEvent,
}

abstract class NavigationStates {}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  @override
  NavigationStates get initialState => HomePage();

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.HomePageClickedEvent:
        yield HomePage();
        break;
      case NavigationEvents.FindRidesClickEvent:
        yield FindRide();
        break;
      case NavigationEvents.OfferRideClickEvent:
        yield OfferRide();
        break;
      case NavigationEvents.MyRideClickEvent:
        yield MyRides();
        break;
      case NavigationEvents.NotificationsClickEvent:
        yield Notifications();
        break;
      case NavigationEvents.SettingClickEvent:
        yield Settings();
        break;
      case NavigationEvents.SignoutClickEvent:
        yield HomePage();
        break;
    }
  }


}
