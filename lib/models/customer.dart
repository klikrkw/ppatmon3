class Customer {
  final String code;
  final String name;
  final String city;

  const Customer({required this.code, required this.name, required this.city});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(code: json['code'], name: json['name'], city: json['city']);
  }
}
