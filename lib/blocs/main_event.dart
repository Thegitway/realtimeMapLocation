import 'package:firebase_auth/firebase_auth.dart';

abstract class MainEvent {}

class MainPosLoadingEvent extends MainEvent {
  bool sendPos;
  User? user;
  MainPosLoadingEvent(this.sendPos, this.user);
}
