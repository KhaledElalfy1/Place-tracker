sealed class MapsStates {}

final class MapsStateInitial extends MapsStates {}


final class ChangeMapView extends MapsStates {}
final class AddDestinationPolygon extends MapsStates {}

final class ClearSuggestedPlaces extends MapsStates {}
