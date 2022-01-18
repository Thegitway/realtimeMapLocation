abstract class MainEvent {}

class MainPosLoadingEvent extends MainEvent {
  bool sendPos;
  MainPosLoadingEvent(this.sendPos);
}
