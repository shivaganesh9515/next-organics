import '../../domain/entities/address.dart';

class MockAddressDataSource {
  static const _delay = Duration(milliseconds: 500);

  Future<List<AddressEntity>> getAddresses() async {
    await Future.delayed(_delay);
    return _mockAddresses;
  }

  static final List<AddressEntity> _mockAddresses = [
    const AddressEntity(
      id: 'addr_1',
      label: 'Home',
      addressLine: 'Flat 401, Green Heights, Tech Park Road',
      city: 'Bangalore',
      zipCode: '560100',
      isDefault: true,
    ),
    const AddressEntity(
      id: 'addr_2',
      label: 'Work',
      addressLine: 'Office 12, Cyber City, Hitech City',
      city: 'Hyderabad',
      zipCode: '500081',
      isDefault: false,
    ),
  ];
}
