class ModelCustomers {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String usertype;
  final String password;

  ModelCustomers({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.usertype,
    required this.password,
  });

  factory ModelCustomers.fromJson(Map<String, dynamic> json) {
    return ModelCustomers(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      usertype: json['usertype'],
      password: json['password'],
    );
  }
}
