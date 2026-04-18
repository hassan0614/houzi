import 'dart:convert';

import 'package:houzi_package/models/places_related/places.dart';

const String AddressComponentsKey = "address_components";
const String FormattedAddressKey = "formatted_address";
const String GeometryKey = "geometry";
const String PlaceIdKey = "place_id";
const String PlusCodeKey = "plus_code";
const String TypesKey = "types";

const String LongNameKey = "long_name";
const String ShortNameKey = "short_name";

const String LocationKey = "location";
const String LocationTypeKey = "location_type";
const String ViewportKey = "viewport";
const String BoundsKey = "bounds";

const String NortheastKey = "northeast";
const String SouthwestKey = "southwest";

const String LatKey = "lat";
const String LngKey = "lng";

const String CompoundCodeKey = "compound_code";
const String GlobeCodeKey = "global_code";


class PlacesApiParser {
  
  static List<PlaceAddress> parseAddressFromJson(String jsonString) {
    return List<PlaceAddress>.from(json.decode(jsonString).map((x) => parsePlaceAddressJson(x)));
  }

  static PlaceAddress parsePlaceAddressJson(Map<String, dynamic> json) {
    return PlaceAddress(
    addressComponents: List<AddressComponent>.from(json[AddressComponentsKey].map((x) => parseAddressComponentJson(x))),
    formattedAddress: json[FormattedAddressKey],
    geometry: parseGeometryJson(json[GeometryKey]),
    placeId: json[PlaceIdKey],
    plusCode: json[PlusCodeKey] == null ? null : parsePlusCodeJson(json[PlusCodeKey]),
    types: List<String>.from(json[TypesKey].map((x) => x)),
  );
  }

  static Map<String, dynamic> convertPlaceAddressToJson(PlaceAddress item) => {
    AddressComponentsKey : List<dynamic>.from(item.addressComponents!.map((x) => convertAddressComponentToJson(x))),
    FormattedAddressKey : item.formattedAddress,
    GeometryKey : convertGeometryToJson(item.geometry!),
    PlaceIdKey : item.placeId,
    PlusCodeKey : item.plusCode == null ? null : convertPlusCodeToJson(item.plusCode!),
    TypesKey : List<dynamic>.from(item.types!.map((x) => x)),
  };

  static AddressComponent parseAddressComponentJson(Map<String, dynamic> json) => AddressComponent(
    longName: json[LongNameKey],
    shortName: json[ShortNameKey],
    types: List<String>.from(json[TypesKey].map((x) => x)),
  );

  static Map<String, dynamic> convertAddressComponentToJson(AddressComponent item) => {
    LongNameKey : item.longName,
    ShortNameKey : item.shortName,
    TypesKey : List<dynamic>.from(item.types!.map((x) => x)),
  };

  static Geometry parseGeometryJson(Map<String, dynamic> json) => Geometry(
    location: parseLocationJson(json[LocationKey]),
    locationType: json[LocationTypeKey],
    viewport: parseViewportJson(json[ViewportKey]),
    bounds: json[BoundsKey] == null ? null : parseViewportJson(json[BoundsKey]),
  );

  static Map<String, dynamic> convertGeometryToJson(Geometry item) => {
    LocationKey: convertLocationToJson(item.location!),
    LocationTypeKey : item.locationType,
    ViewportKey : convertViewportToJson(item.viewport!),
    BoundsKey : item.bounds == null ? null : convertViewportToJson(item.bounds!),
  };

  static Viewport parseViewportJson(Map<String, dynamic> json) => Viewport(
    northeast: parseLocationJson(json[NortheastKey]),
    southwest: parseLocationJson(json[SouthwestKey]),
  );

  static Map<String, dynamic> convertViewportToJson(Viewport item) => {
    NortheastKey : convertLocationToJson(item.northeast!),
    SouthwestKey : convertLocationToJson(item.southwest!),
  };

  static Location parseLocationJson(Map<String, dynamic> json) => Location(
    lat: json[LatKey].toDouble(),
    lng: json[LngKey].toDouble(),
  );

  static Map<String, dynamic> convertLocationToJson(Location item) => {
    LatKey : item.lat,
    LngKey : item.lng,
  };

  static PlusCode parsePlusCodeJson(Map<String, dynamic> json) => PlusCode(
    compoundCode: json[CompoundCodeKey],
    globalCode: json[GlobeCodeKey],
  );

  static Map<String, dynamic> convertPlusCodeToJson(PlusCode item) => {
    CompoundCodeKey : item.compoundCode,
    GlobeCodeKey : item.globalCode,
  };
}