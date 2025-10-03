class Studio {
  final int studioID;
  final String abbreviation;
  final String name;
  final String address;
  final String city;
  final String postCode;
  final String region;
  final String? phone;
  final DateTime? presaleDate;
  final DateTime? openingDate;
  final DateTime? closedDate;
  final int migrateToID;
  final String? taxRegistration;
  final bool active;
  final bool headOffice;
  final bool trainingSite;
  final bool presale;
  final String? compaccname;
  final String? compaccno;
  final String? compbankname;
  final DateTime createDate;
  final String createBy;

  Studio({
    required this.studioID,
    required this.abbreviation,
    required this.name,
    required this.address,
    required this.city,
    required this.postCode,
    required this.region,
    required this.phone,
    this.presaleDate,
    this.openingDate,
    this.closedDate,
    required this.migrateToID,
    this.taxRegistration,
    required this.active,
    required this.headOffice,
    required this.trainingSite,
    required this.presale,
    this.compaccname,
    this.compaccno,
    this.compbankname,
    required this.createDate,
    required this.createBy,
  });

  factory Studio.fromJson(Map<String, dynamic> json) {
    return Studio(
      studioID: json['studioID'] ?? 0,
      abbreviation: json['abbreviation'] ?? 'N/A',
      name: json['name'] ?? 'Unknown Studio',
      address: json['address'] ?? 'Unknown Address',
      city: json['city'] ?? 'Unknown City',
      postCode: json['postCode'] ?? '00000',
      region: json['region'] ?? '0',
      phone: json['phone'],
      presaleDate: json['presaleDate'] != null
          ? DateTime.parse(json['presaleDate'])
          : null,
      openingDate: json['openingDate'] != null
          ? DateTime.parse(json['openingDate'])
          : null,
      closedDate: json['closedDate'] != null
          ? DateTime.parse(json['closedDate'])
          : null,
      migrateToID: json['migrateToID'] ?? 0,
      taxRegistration: json['taxRegistration'],
      active: json['active'] ?? true,
      headOffice: json['headOffice'] ?? false,
      trainingSite: json['trainingSite'] ?? false,
      presale: json['presale'] ?? false,
      compaccname: json['compaccname'],
      compaccno: json['compaccno'],
      compbankname: json['compbankname'],
      createDate: json['createDate'] != null
          ? DateTime.parse(json['createDate'])
          : DateTime.now(),
      createBy: json['createBy'] ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studioID': studioID,
      'abbreviation': abbreviation,
      'name': name,
      'address': address,
      'city': city,
      'postCode': postCode,
      'region': region,
      'phone': phone,
      'presaleDate': presaleDate?.toIso8601String(),
      'openingDate': openingDate?.toIso8601String(),
      'closedDate': closedDate?.toIso8601String(),
      'migrateToID': migrateToID,
      'taxRegistration': taxRegistration,
      'active': active,
      'headOffice': headOffice,
      'trainingSite': trainingSite,
      'presale': presale,
      'compaccname': compaccname,
      'compaccno': compaccno,
      'compbankname': compbankname,
      'createDate': createDate.toIso8601String(),
      'createBy': createBy,
    };
  }
}
