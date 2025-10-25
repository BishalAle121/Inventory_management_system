class ProjectModel {
  final int vendorId;
  final String projectName;

  ProjectModel({required this.vendorId, required this.projectName});

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      vendorId: json['vendor_id'] ?? json['Vendor ID'] ?? 0,
      projectName: json['project_name'] ?? json['Project Name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'vendor_id': vendorId, 'project_name': projectName};
  }
}
