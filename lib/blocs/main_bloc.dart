import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:location/location.dart';
import 'main_event.dart';
import 'main_state.dart';

class MainBloc<T> extends Bloc<MainEvent, MainState> {
  MainBloc() : super(MainState.initState());

  MainState get initialState => MainState.initState();

  @override
  Stream<MainState> mapEventToState(MainEvent event) async* {
    if (event is MainPosLoadingEvent) {
      yield MainState.loading();
      FirebaseDatabase database = FirebaseDatabase.instance;
      database.databaseURL =
          'https://delivery-84b83-default-rtdb.europe-west1.firebasedatabase.app';
      DatabaseReference pos = database.ref("users/${event.user?.uid}");

      //send pos
      if (event.sendPos == true) {
        Location location = new Location();
        LocationData _locationData;

        _locationData = await location.getLocation();
        await pos.set(
            {"lat": _locationData.latitude, "long": _locationData.longitude});
      }

      //GetPos

      var ev = await pos.once();

      yield MainState.posLoaded(jsonDecode(jsonEncode(ev.snapshot.value)));
    }
  }
}
