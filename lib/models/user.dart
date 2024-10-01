class UserModel {
  final String id;
  final String first_name;
  final String last_name;
  final String roll;
  late final bool payment;
  //final double pac_price;

  UserModel({
    required this.id,
    required this.first_name,
    required this.last_name,
    required this.roll,
    required this.payment,
  });

  factory UserModel.fromMap(String id, Map<String, dynamic> data) {
    return UserModel(
      id: id,
      first_name: data['firstName'] ?? '',
      last_name: data['lastName'] ?? '',
      roll: data['role'] ?? '',
      payment: data['payment'] ?? false,
    );
  }
}
