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
    return '$address, $city - $pincode';
  }
}