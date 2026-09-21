class MilestoneApp6Address {
  final String label;
  final String name;
  final String phone;
  final String address;
  final String city;
  final String pincode;

  const MilestoneApp6Address({
    required this.label,
    required this.name,
    required this.phone,
    required this.address,
    required this.city,
    required this.pincode,
  });

  String get fullAddress {
    final parts = <String>[];

    if (address.trim().isNotEmpty) {
      parts.add(address.trim());
    }

    if (city.trim().isNotEmpty) {
      parts.add(city.trim());
    }

    if (pincode.trim().isNotEmpty) {
      parts.add(pincode.trim());
    }

    return parts.join(', ');
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'name': name,
      'phone': phone,
      'address': address,
      'city': city,
      'pincode': pincode,
    };
  }

  factory MilestoneApp6Address.fromJson(
      Map<String, dynamic> json,
      ) {
    return MilestoneApp6Address(
      label: json['label']?.toString() ?? 'Home',
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      pincode: json['pincode']?.toString() ?? '',
    );
  }

  MilestoneApp6Address copyWith({
    String? label,
    String? name,
    String? phone,
    String? address,
    String? city,
    String? pincode,
  }) {
    return MilestoneApp6Address(
      label: label ?? this.label,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      pincode: pincode ?? this.pincode,
    );
  }
}

class MilestoneApp6NearbyLocation {
  final String name;
  final String address;
  final String distance;

  const MilestoneApp6NearbyLocation({
    required this.name,
    required this.address,
    required this.distance,
  });
}