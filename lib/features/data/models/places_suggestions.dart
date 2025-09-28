class PlacesSuggestions {
  final String place;
  final String placeId;
  final String address;
  final String placeName;
  final String country;

  PlacesSuggestions({
    required this.place,
    required this.placeId,
    required this.address,
    required this.placeName,
    required this.country,
  });

  factory PlacesSuggestions.fromJson(Map<String, dynamic> json) {
    return PlacesSuggestions(
      place: json['place'],
      placeId: json['placeId'] ?? '',
      address: json['text']['text'] ?? '',
      placeName: json['structuredFormat']['mainText']['text'] ?? '',
      country: json['structuredFormat']['secondaryText']?['text']??''
      // country: json['structuredFormat']['secondaryText'] != null
      //     ? json['structuredFormat']['secondaryText']['text']
      //     : '',
    );
  }
}
