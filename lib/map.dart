import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class myMap{
  static void openMaps(double latitude, double longitude) async {
    var check = await MapLauncher.isMapAvailable(MapType.google);
    final availableMaps = await MapLauncher.installedMaps;


    //best case scenario, we get google maps.
    if (check != null && check == true) {
    await MapLauncher.showMarker(
    mapType: MapType.google,
    coords: Coords(latitude,longitude),
    title:" test Map",
    description: "Map to home",
    );
    }
    else if(check != null && check != true && availableMaps.length >= 1){
      //any map app other can google maps,
      await availableMaps.first.showMarker(
        coords: Coords(latitude, longitude),
        title: "Map to Home",
      );
    }
    else if(check != null && check != true && availableMaps.length < 1){
      //worst case scenario, no map app installed.
      String url = "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
      launch(url);
    }
    }
}
