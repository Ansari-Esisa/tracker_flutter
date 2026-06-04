class Driver {
  final int? id;
  final String name;
  final String phone;
  final String email;
  final String? uid; // Firebase UID

  Driver({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.uid,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'uid': uid,
    };
  }

  factory Driver.fromMap(Map<String, dynamic> map) {
    return Driver(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
      uid: map['uid'],
    );
  }
}
