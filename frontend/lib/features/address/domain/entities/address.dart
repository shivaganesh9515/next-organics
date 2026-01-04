class AddressEntity {
  final String id;
  final String label; // "Home", "Work"
  final String addressLine;
  final String city;
  final String zipCode;
  final bool isDefault;

  const AddressEntity({
    required this.id,
    required this.label,
    required this.addressLine,
    required this.city,
    required this.zipCode,
    this.isDefault = false,
  });
}
