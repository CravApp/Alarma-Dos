class ContactModel {
  final String id;
  final String name;
  final String phone;
  final String? avatarInitials;
  final bool isActive;

  ContactModel({
    required this.id,
    required this.name,
    required this.phone,
    this.avatarInitials,
    this.isActive = true,
  });
}
