import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';

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

      DatabaseReference pos = database.ref("users/pos");
      // await pos.set({"long": 31, "lat": 22});
      var event = await pos.once();
      // await pos.remove();
      yield MainState.posLoaded(jsonDecode(jsonEncode(event.snapshot.value)));
    }
  }
}
