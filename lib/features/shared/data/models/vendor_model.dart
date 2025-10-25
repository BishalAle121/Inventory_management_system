class VendorModel {
  final int slno;
  final String vendorName;

  VendorModel({required this.slno, required this.vendorName});

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      slno: json['slno'] ?? json['Slno'] ?? 0,
      vendorName: json['vendor_name'] ?? json['Vendor Name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'slno': slno, 'vendor_name': vendorName};
  }
}
