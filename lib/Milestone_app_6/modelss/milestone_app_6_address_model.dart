class MilestoneApp6Address {
  final int id;
  final String label;
  final String address;
  final String city;
  final String state;
  final String pincode;
  final double? latitude;
  final double? longitude;

  const MilestoneApp6Address({
    required this.id,
    required this.label,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    this.latitude,
    this.longitude,
  });

  factory MilestoneApp6Address.fromJson(
      Map<String, dynamic> json,
      ) {
    final rawId =
        json['id'] ??
            json['address_id'] ??
            json['customer_address_id'];

    return MilestoneApp6Address(
      id: int.tryParse(
        rawId?.toString() ?? '',
      ) ??
          0,

      label:
      json['label']?.toString() ??
          json['type']?.toString() ??
          json['address_type']
              ?.toString() ??
          'Home',

      address:
      json['address']?.toString() ??
          json['address_line']
              ?.toString() ??
          json['address_details']
              ?.toString() ??
          '',

      city:
      json['city']?.toString() ??
          '',

      state:
      json['state']?.toString() ??
          '',

      pincode:
      json['pincode']?.toString() ??
          json['postal_code']
              ?.toString() ??
          '',

      latitude:
      _toDouble(
        json['latitude'] ??
            json['lat'],
      ),

      longitude:
      _toDouble(
        json['longitude'] ??
            json['lng'],
      ),
    );
  }

  static double? _toDouble(
      dynamic value,
      ) {
    if (value == null) {
      return null;
    }

    return double.tryParse(
      value.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'address': address,
      'city': city,
      'state': state,
      'pincode': pincode,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  String get fullAddress {
    final parts = <String>[
      address,
      city,
      state,
      pincode,
    ].where(
          (value) =>
      value.trim().isNotEmpty,
    ).toList();

    return parts.join(', ');
  }
}