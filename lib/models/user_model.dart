class User {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String? mobile;
  final String? profileImage;
  final String? status;
  final List<String>? permissions;
  final DateTime? createdAt;

  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.mobile,
    this.profileImage,
    this.status,
    this.permissions,
    this.createdAt,
  });

  // Computed property for full name
  String get name => '$firstName $lastName'.trim();

  User copyWith({
    int? id,
    String? email,
    String? firstName,
    String? lastName,
    String? mobile,
    String? profileImage,
    String? status,
    List<String>? permissions,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      mobile: mobile ?? this.mobile,
      profileImage: profileImage ?? this.profileImage,
      status: status ?? this.status,
      permissions: permissions ?? this.permissions,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'mobile': mobile,
      'profile_image': profileImage,
      'status': status,
      'permissions': permissions,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      email: json['email'] as String,
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      mobile: json['mobile'] as String?,
      profileImage: json['profile_image'] as String?,
      status: json['status'] as String?,
      permissions: json['permissions'] != null 
          ? List<String>.from(json['permissions'] as List)
          : null,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.email == email &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.mobile == mobile &&
        other.profileImage == profileImage &&
        other.status == status &&
        other.permissions == permissions &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        mobile.hashCode ^
        profileImage.hashCode ^
        status.hashCode ^
        permissions.hashCode ^
        createdAt.hashCode;
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $name, mobile: $mobile, status: $status)';
  }
}