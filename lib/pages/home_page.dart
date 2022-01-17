import 'dart:async';

import 'package:delivery/blocs/main_bloc.dart';
import 'package:delivery/blocs/main_event.dart';
import 'package:delivery/blocs/main_state.dart';

import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng pos = LatLng(33.5732507291, -7.64164329480);
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(33.57325072915211, -7.641643294803729),
    zoom: 14.4746,
  );

  final MainBloc _bloc = MainBloc();

  @override
  void initState() {
    _bloc.add(MainPosLoadingEvent());

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainBloc, MainState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state.state == States.posLoaded) {
          print("${state.pos}");
          setState(() {
            pos = LatLng(double.parse(state.pos?["lat"].toString() ?? "33"),
                double.parse(state.pos?["long"].toString() ?? "-7.3"));
          });
          Timer(Duration(seconds: 5), () {
            _bloc.add(MainPosLoadingEvent());
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: Text(widget.title),
          ),
          body: GoogleMap(
            markers: {
              Marker(
                icon: BitmapDescriptor.defaultMarker,
                markerId: MarkerId('place_name'),
                position: pos,
                infoWindow: InfoWindow(
                  title: 'title',
                  snippet: 'address',
                ),
              )
            },
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),

          // This trailing comma makes auto-formatting nicer for build methods.
        );
      },
    );
  }
}
