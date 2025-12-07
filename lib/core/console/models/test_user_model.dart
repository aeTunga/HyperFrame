import '../../network/base_model.dart';

/// Test User Model for JSONPlaceholder API
///
/// Used exclusively for HyperConsole network testing.
/// This model represents a user from jsonplaceholder.typicode.com.
class TestUserModel extends BaseModel {
  final int id;
  final String name;
  final String username;
  final String email;
  final Address? address;
  final String? phone;
  final String? website;
  final Company? company;

  const TestUserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.address,
    this.phone,
    this.website,
    this.company,
  });

  factory TestUserModel.fromJson(Map<String, dynamic> json) {
    return TestUserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      address: json['address'] != null
          ? Address.fromJson(json['address'] as Map<String, dynamic>)
          : null,
      phone: json['phone'] as String?,
      website: json['website'] as String?,
      company: json['company'] != null
          ? Company.fromJson(json['company'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      if (address != null) 'address': address!.toJson(),
      if (phone != null) 'phone': phone,
      if (website != null) 'website': website,
      if (company != null) 'company': company!.toJson(),
    };
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email)';
  }
}

/// Address nested model
class Address {
  final String street;
  final String suite;
  final String city;
  final String zipcode;
  final Geo? geo;

  const Address({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
    this.geo,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'] as String,
      suite: json['suite'] as String,
      city: json['city'] as String,
      zipcode: json['zipcode'] as String,
      geo: json['geo'] != null
          ? Geo.fromJson(json['geo'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'suite': suite,
      'city': city,
      'zipcode': zipcode,
      if (geo != null) 'geo': geo!.toJson(),
    };
  }
}

/// Geo coordinates nested model
class Geo {
  final String lat;
  final String lng;

  const Geo({required this.lat, required this.lng});

  factory Geo.fromJson(Map<String, dynamic> json) {
    return Geo(lat: json['lat'] as String, lng: json['lng'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'lat': lat, 'lng': lng};
  }
}

/// Company nested model
class Company {
  final String name;
  final String catchPhrase;
  final String bs;

  const Company({
    required this.name,
    required this.catchPhrase,
    required this.bs,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      name: json['name'] as String,
      catchPhrase: json['catchPhrase'] as String,
      bs: json['bs'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'catchPhrase': catchPhrase, 'bs': bs};
  }
}
