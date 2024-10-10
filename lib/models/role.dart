class Role {
  String? id;
  String? name;
  String? type;
  String? key;
  String? status;
  String? showOnEmpPortal;
  String? created;

  Role(
      {this.id,
      this.name,
      this.type,
      this.key,
      this.status,
      this.showOnEmpPortal,
      this.created});

  Role.def() {
    id = '';
    name = '';
    type = '';
    key = '';
    status = '';
    showOnEmpPortal = '';
    created = '';
  }

  factory Role.convertFromJson(dynamic json) {
    final role = Role.def();
    role.id = json['id'];
    role.name = json['name'];
    role.type = json['type'];
    role.key = json['key'];
    role.status = json['status'];
    role.showOnEmpPortal = json['show_on_emp_portal'];
    role.created = json['created'];

    return role;
  }
}
