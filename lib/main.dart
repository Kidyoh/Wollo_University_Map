import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ictmap/location_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
TextEditingController _searchController = TextEditingController();

 
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(11.04977171552871, 39.74731966254842),
    zoom: 14.4746,
  );
  static const Marker _StudentsLounge = Marker(
  markerId: MarkerId('_kGooglePlex'),
  infoWindow: InfoWindow(title: 'Students Lounge'),
  icon: BitmapDescriptor.defaultMarker,
  position: LatLng(11.04977171552871, 39.74731966254842),
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(11.04977171552871, 39.74731966254842),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);


    static final Marker _ictbuil = Marker(
   markerId:  const MarkerId('_ictbuil'),
    infoWindow:  const InfoWindow(title: 'ICT Lab'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    position:  const LatLng(11.049030785590219, 39.749451935955015),
  );


  static final Polyline _kPolyline = Polyline(
    polylineId: PolylineId('_kPolyline'),
    points: [
      LatLng(11.04977171552871, 39.74731966254842),
      LatLng(11.049030785590219, 39.749451935955015),

    ],
    width: 5,
  );

  static final Polygon _kPolygon = Polygon(
    polygonId: PolygonId('_kPolygon'),
     points: [
      LatLng(11.04977171552871, 39.74731966254842),
      LatLng(11.049030785590219, 39.749451935955015),
      LatLng(11.04916853091057, 39.75011858360427),
      LatLng(11.049553591349452, 39.74950616088342),

    ],
    strokeWidth: 5,
    fillColor: Colors.transparent,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Wollo University Maps')),),
      body: Column(
        children: [
          Row(children: [
            Expanded(child: TextFormField(
              controller: _searchController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(hintText: 'Search where you wanna go'),
              onChanged: (value) {
                print(value);
              },
            )),
            IconButton(onPressed: (){
              LocationService().getPlace(_searchController.text);
            }, icon: Icon(Icons.search),),

          ],),
          Expanded(
            child: GoogleMap(
              mapType: MapType.hybrid,
              markers: {_StudentsLounge, _ictbuil},
              // polylines: {
              //   _kPolyline,
              // },
              // polygons: {
              //   _kPolygon,
              // },
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
        ],
      ),
      // bottomNavigationBar: BottomNavigationBar(items: [
      //   BottomNavigationBarItem(icon: Icon(Icons.where_to_vote))
      // ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('Where do you wanna go?'),
        icon: const Icon(Icons.where_to_vote),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
