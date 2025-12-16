
class ApplicationForm {
  // --- Personal Information (Page 1) ---
  String accountType; // Savings, Current, etc.
  String currency; // BDT, USD, etc.
  String operationMode; // Singly, Jointly
  String initialDeposit; // Figures

  String applicantNameBangla;
  String applicantNameEnglish;
  String fatherName;
  String motherName;
  String spouseName;
  String dob; // DD/MM/YYYY
  String gender;
  String nationality;
  String occupation;
  String monthlyIncome;
  String tin;

  // --- Identity Documents ---
  String nidNumber;
  String passportNumber;
  String birthRegNumber;

  // --- Addresses (Page 2) ---
  Address presentAddress;
  Address permanentAddress;
  String mobileNumber;
  String email;

  // --- Introducer (Page 3) ---
  String introducerName;
  String introducerAccountNo;
  String introducerBranch;

  // --- Nominee (Page 4) ---
  List<Nominee> nominees;

  // --- Transaction Profile (Page 5) ---
  TransactionProfile transactionProfile;

  // --- Services (New Page 5b) ---
  bool isUSCitizen;
  String tinForeign;
  String residencyAddress;
  bool requestChequeBook;
  bool requestSmsBanking;
  bool requestInternetBanking;

  // --- Images (Paths) ---
  String? applicantPhotoPath;
  String? applicantSignaturePath;
  String? nidFrontPath;
  String? nidBackPath;

  // --- Beneficial Owner (Page 8) ---
  String beneficialOwnerName;
  String beneficialOwnerRelation;
  String beneficialOwnerDob;
  String beneficialOwnerNid;

  // --- Terms & Risk (Page 6-11) ---
  int riskScore;
  String riskRating; // High/Low
  String riskGradingComments;
  bool hasAgreedToTerms;
  String agreementDate;

  ApplicationForm({
    this.accountType = 'Savings',
    this.currency = 'BDT',
    this.operationMode = 'Singly',
    this.initialDeposit = '',
    this.applicantNameBangla = '',
    this.applicantNameEnglish = '',
    this.fatherName = '',
    this.motherName = '',
    this.spouseName = '',
    this.dob = '',
    this.gender = '',
    this.nationality = 'Bangladeshi',
    this.occupation = '',
    this.monthlyIncome = '',
    this.tin = '',
    this.nidNumber = '',
    this.passportNumber = '',
    this.birthRegNumber = '',
    required this.presentAddress,
    required this.permanentAddress,
    this.mobileNumber = '',
    this.email = '',
    this.introducerName = '',
    this.introducerAccountNo = '',
    this.introducerBranch = '',
    this.nominees = const [],
    required this.transactionProfile,
    this.isUSCitizen = false,
    this.tinForeign = '',
    this.residencyAddress = '',
    this.requestChequeBook = false,
    this.requestSmsBanking = false,
    this.requestInternetBanking = false,
    this.applicantPhotoPath,
    this.applicantSignaturePath,
    this.nidFrontPath,
    this.nidBackPath,
    this.beneficialOwnerName = '',
    this.beneficialOwnerRelation = '',
    this.beneficialOwnerDob = '',
    this.beneficialOwnerNid = '',
    this.riskScore = 0,
    this.riskRating = 'Low',
    this.riskGradingComments = '',
    this.hasAgreedToTerms = false,
    this.agreementDate = '',
  });

  factory ApplicationForm.empty() {
    return ApplicationForm(
      presentAddress: Address.empty(),
      permanentAddress: Address.empty(),
      transactionProfile: TransactionProfile.empty(),
      nominees: [Nominee.empty()],
    );
  }

  ApplicationForm copyWith({
    String? accountType,
    String? currency,
    String? operationMode,
    String? initialDeposit,
    String? applicantNameBangla,
    String? applicantNameEnglish,
    String? fatherName,
    String? motherName,
    String? spouseName,
    String? dob,
    String? gender,
    String? nationality,
    String? occupation,
    String? monthlyIncome,
    String? tin,
    String? nidNumber,
    String? passportNumber,
    String? birthRegNumber,
    Address? presentAddress,
    Address? permanentAddress,
    String? mobileNumber,
    String? email,
    String? introducerName,
    String? introducerAccountNo,
    String? introducerBranch,
    List<Nominee>? nominees,
    TransactionProfile? transactionProfile,
    bool? isUSCitizen,
    String? tinForeign,
    String? residencyAddress,
    bool? requestChequeBook,
    bool? requestSmsBanking,
    bool? requestInternetBanking,
    String? applicantPhotoPath,
    String? applicantSignaturePath,
    String? nidFrontPath,
    String? nidBackPath,
    String? beneficialOwnerName,
    String? beneficialOwnerRelation,
    String? beneficialOwnerDob,
    String? beneficialOwnerNid,
    int? riskScore,
    String? riskRating,
    String? riskGradingComments,
    bool? hasAgreedToTerms,
    String? agreementDate,
  }) {
    return ApplicationForm(
      accountType: accountType ?? this.accountType,
      currency: currency ?? this.currency,
      operationMode: operationMode ?? this.operationMode,
      initialDeposit: initialDeposit ?? this.initialDeposit,
      applicantNameBangla: applicantNameBangla ?? this.applicantNameBangla,
      applicantNameEnglish: applicantNameEnglish ?? this.applicantNameEnglish,
      fatherName: fatherName ?? this.fatherName,
      motherName: motherName ?? this.motherName,
      spouseName: spouseName ?? this.spouseName,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      nationality: nationality ?? this.nationality,
      occupation: occupation ?? this.occupation,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      tin: tin ?? this.tin,
      nidNumber: nidNumber ?? this.nidNumber,
      passportNumber: passportNumber ?? this.passportNumber,
      birthRegNumber: birthRegNumber ?? this.birthRegNumber,
      presentAddress: presentAddress ?? this.presentAddress,
      permanentAddress: permanentAddress ?? this.permanentAddress,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      email: email ?? this.email,
      introducerName: introducerName ?? this.introducerName,
      introducerAccountNo: introducerAccountNo ?? this.introducerAccountNo,
      introducerBranch: introducerBranch ?? this.introducerBranch,
      nominees: nominees ?? this.nominees,
      transactionProfile: transactionProfile ?? this.transactionProfile,
      isUSCitizen: isUSCitizen ?? this.isUSCitizen,
      tinForeign: tinForeign ?? this.tinForeign,
      residencyAddress: residencyAddress ?? this.residencyAddress,
      requestChequeBook: requestChequeBook ?? this.requestChequeBook,
      requestSmsBanking: requestSmsBanking ?? this.requestSmsBanking,
      requestInternetBanking: requestInternetBanking ?? this.requestInternetBanking,
      applicantPhotoPath: applicantPhotoPath ?? this.applicantPhotoPath,
      applicantSignaturePath: applicantSignaturePath ?? this.applicantSignaturePath,
      nidFrontPath: nidFrontPath ?? this.nidFrontPath,
      nidBackPath: nidBackPath ?? this.nidBackPath,
      beneficialOwnerName: beneficialOwnerName ?? this.beneficialOwnerName,
      beneficialOwnerRelation: beneficialOwnerRelation ?? this.beneficialOwnerRelation,
      beneficialOwnerDob: beneficialOwnerDob ?? this.beneficialOwnerDob,
      beneficialOwnerNid: beneficialOwnerNid ?? this.beneficialOwnerNid,
      riskScore: riskScore ?? this.riskScore,
      riskRating: riskRating ?? this.riskRating,
      riskGradingComments: riskGradingComments ?? this.riskGradingComments,
      hasAgreedToTerms: hasAgreedToTerms ?? this.hasAgreedToTerms,
      agreementDate: agreementDate ?? this.agreementDate,
    );
  }

  Map<String, dynamic> toJson() => {
    'accountType': accountType,
    'currency': currency,
    'operationMode': operationMode,
    'initialDeposit': initialDeposit,
    'applicantNameBangla': applicantNameBangla,
    'applicantNameEnglish': applicantNameEnglish,
    'fatherName': fatherName,
    'motherName': motherName,
    'spouseName': spouseName,
    'dob': dob,
    'gender': gender,
    'nationality': nationality,
    'occupation': occupation,
    'monthlyIncome': monthlyIncome,
    'tin': tin,
    'nidNumber': nidNumber,
    'passportNumber': passportNumber,
    'birthRegNumber': birthRegNumber,
    'presentAddress': presentAddress.toJson(),
    'permanentAddress': permanentAddress.toJson(),
    'mobileNumber': mobileNumber,
    'email': email,
    'introducerName': introducerName,
    'introducerAccountNo': introducerAccountNo,
    'introducerBranch': introducerBranch,
    'nominees': nominees.map((x) => x.toJson()).toList(),
    'transactionProfile': transactionProfile.toJson(),
    'isUSCitizen': isUSCitizen,
    'tinForeign': tinForeign,
    'residencyAddress': residencyAddress,
    'requestChequeBook': requestChequeBook,
    'requestSmsBanking': requestSmsBanking,
    'requestInternetBanking': requestInternetBanking,
    'applicantPhotoPath': applicantPhotoPath,
    'applicantSignaturePath': applicantSignaturePath,
    'nidFrontPath': nidFrontPath,
    'nidBackPath': nidBackPath,
    'beneficialOwnerName': beneficialOwnerName,
    'beneficialOwnerRelation': beneficialOwnerRelation,
    'beneficialOwnerDob': beneficialOwnerDob,
    'beneficialOwnerNid': beneficialOwnerNid,
    'riskScore': riskScore,
    'riskRating': riskRating,
    'riskGradingComments': riskGradingComments,
    'hasAgreedToTerms': hasAgreedToTerms,
    'agreementDate': agreementDate,
  };

  factory ApplicationForm.fromJson(Map<String, dynamic> json) => ApplicationForm(
    accountType: json['accountType'] ?? 'Savings',
    currency: json['currency'] ?? 'BDT',
    operationMode: json['operationMode'] ?? 'Singly',
    initialDeposit: json['initialDeposit'] ?? '',
    applicantNameBangla: json['applicantNameBangla'] ?? '',
    applicantNameEnglish: json['applicantNameEnglish'] ?? '',
    fatherName: json['fatherName'] ?? '',
    motherName: json['motherName'] ?? '',
    spouseName: json['spouseName'] ?? '',
    dob: json['dob'] ?? '',
    gender: json['gender'] ?? '',
    nationality: json['nationality'] ?? '',
    occupation: json['occupation'] ?? '',
    monthlyIncome: json['monthlyIncome'] ?? '',
    tin: json['tin'] ?? '',
    nidNumber: json['nidNumber'] ?? '',
    passportNumber: json['passportNumber'] ?? '',
    birthRegNumber: json['birthRegNumber'] ?? '',
    presentAddress: json['presentAddress'] != null ? Address.fromJson(json['presentAddress']) : Address.empty(),
    permanentAddress: json['permanentAddress'] != null ? Address.fromJson(json['permanentAddress']) : Address.empty(),
    mobileNumber: json['mobileNumber'] ?? '',
    email: json['email'] ?? '',
    introducerName: json['introducerName'] ?? '',
    introducerAccountNo: json['introducerAccountNo'] ?? '',
    introducerBranch: json['introducerBranch'] ?? '',
    nominees: json['nominees'] != null
        ? List<Nominee>.from(json['nominees'].map((x) => Nominee.fromJson(x)))
        : [Nominee.empty()],
    transactionProfile: json['transactionProfile'] != null
        ? TransactionProfile.fromJson(json['transactionProfile'])
        : TransactionProfile.empty(),
    isUSCitizen: json['isUSCitizen'] ?? false,
    tinForeign: json['tinForeign'] ?? '',
    residencyAddress: json['residencyAddress'] ?? '',
    requestChequeBook: json['requestChequeBook'] ?? false,
    requestSmsBanking: json['requestSmsBanking'] ?? false,
    requestInternetBanking: json['requestInternetBanking'] ?? false,
    applicantPhotoPath: json['applicantPhotoPath'],
    applicantSignaturePath: json['applicantSignaturePath'],
    nidFrontPath: json['nidFrontPath'],
    nidBackPath: json['nidBackPath'],
    beneficialOwnerName: json['beneficialOwnerName'] ?? '',
    beneficialOwnerRelation: json['beneficialOwnerRelation'] ?? '',
    beneficialOwnerDob: json['beneficialOwnerDob'] ?? '',
    beneficialOwnerNid: json['beneficialOwnerNid'] ?? '',
    riskScore: json['riskScore'] ?? 0,
    riskRating: json['riskRating'] ?? 'Low',
    riskGradingComments: json['riskGradingComments'] ?? '',
    hasAgreedToTerms: json['hasAgreedToTerms'] ?? false,
    agreementDate: json['agreementDate'] ?? '',
  );
}

class Address {
  String flatNo;
  String roadNo;
  String village;
  String postOffice;
  String postCode;
  String policeStation;
  String district;
  String division; // Added division

  Address({
    this.flatNo = '',
    this.roadNo = '',
    this.village = '',
    this.postOffice = '',
    this.postCode = '',
    this.policeStation = '',
    this.district = '',
    this.division = '',
  });

  factory Address.empty() => Address();

  Address copyWith({
    String? flatNo,
    String? roadNo,
    String? village,
    String? postOffice,
    String? postCode,
    String? policeStation,
    String? district,
    String? division,
  }) {
    return Address(
      flatNo: flatNo ?? this.flatNo,
      roadNo: roadNo ?? this.roadNo,
      village: village ?? this.village,
      postOffice: postOffice ?? this.postOffice,
      postCode: postCode ?? this.postCode,
      policeStation: policeStation ?? this.policeStation,
      district: district ?? this.district,
      division: division ?? this.division,
    );
  }

  String get fullAddress => [flatNo, roadNo, village, postOffice, policeStation, district].where((s) => s.isNotEmpty).join(', ');

  Map<String, dynamic> toJson() => {
    'flatNo': flatNo,
    'roadNo': roadNo,
    'village': village,
    'postOffice': postOffice,
    'postCode': postCode,
    'policeStation': policeStation,
    'district': district,
    'division': division,
  };

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    flatNo: json['flatNo'] ?? '',
    roadNo: json['roadNo'] ?? '',
    village: json['village'] ?? '',
    postOffice: json['postOffice'] ?? '',
    postCode: json['postCode'] ?? '',
    policeStation: json['policeStation'] ?? '',
    district: json['district'] ?? '',
    division: json['division'] ?? '',
  );
}

class Nominee {
  String name;
  String relation;
  String dob;
  String percentage;
  String nidNumber;
  String photoPath;
  String signaturePath;

  Nominee({
    this.name = '',
    this.relation = '',
    this.dob = '',
    this.percentage = '100',
    this.nidNumber = '',
    this.photoPath = '',
    this.signaturePath = '',
  });

  factory Nominee.empty() => Nominee();

  Map<String, dynamic> toJson() => {
    'name': name,
    'relation': relation,
    'dob': dob,
    'percentage': percentage,
    'nidNumber': nidNumber,
    'photoPath': photoPath,
    'signaturePath': signaturePath,
  };

  factory Nominee.fromJson(Map<String, dynamic> json) => Nominee(
    name: json['name'] ?? '',
    relation: json['relation'] ?? '',
    dob: json['dob'] ?? '',
    percentage: json['percentage'] ?? '100',
    nidNumber: json['nidNumber'] ?? '',
    photoPath: json['photoPath'] ?? '',
    signaturePath: json['signaturePath'] ?? '',
  );
}

class TransactionProfile {
  String sourceOfFund;
  String monthlyIncome;
  String cashDepositNum;
  String cashDepositAmt;
  String transferDepositNum;
  String transferDepositAmt;
  String foreignRemittanceNum;
  String foreignRemittanceAmt;
  String exportProceedsNum;
  String exportProceedsAmt;
  String cashWithdrawalNum;
  String cashWithdrawalAmt;
  String transferWithdrawalNum;
  String transferWithdrawalAmt;

  TransactionProfile({
    this.sourceOfFund = '',
    this.monthlyIncome = '',
    this.cashDepositNum = '',
    this.cashDepositAmt = '',
    this.transferDepositNum = '',
    this.transferDepositAmt = '',
    this.foreignRemittanceNum = '',
    this.foreignRemittanceAmt = '',
    this.exportProceedsNum = '',
    this.exportProceedsAmt = '',
    this.cashWithdrawalNum = '',
    this.cashWithdrawalAmt = '',
    this.transferWithdrawalNum = '',
    this.transferWithdrawalAmt = '',
  });

  factory TransactionProfile.empty() => TransactionProfile();

  TransactionProfile copyWith({
    String? sourceOfFund,
    String? monthlyIncome,
    String? cashDepositNum,
    String? cashDepositAmt,
    String? transferDepositNum,
    String? transferDepositAmt,
    String? foreignRemittanceNum,
    String? foreignRemittanceAmt,
    String? exportProceedsNum,
    String? exportProceedsAmt,
    String? cashWithdrawalNum,
    String? cashWithdrawalAmt,
    String? transferWithdrawalNum,
    String? transferWithdrawalAmt,
  }) {
    return TransactionProfile(
      sourceOfFund: sourceOfFund ?? this.sourceOfFund,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      cashDepositNum: cashDepositNum ?? this.cashDepositNum,
      cashDepositAmt: cashDepositAmt ?? this.cashDepositAmt,
      transferDepositNum: transferDepositNum ?? this.transferDepositNum,
      transferDepositAmt: transferDepositAmt ?? this.transferDepositAmt,
      foreignRemittanceNum: foreignRemittanceNum ?? this.foreignRemittanceNum,
      foreignRemittanceAmt: foreignRemittanceAmt ?? this.foreignRemittanceAmt,
      exportProceedsNum: exportProceedsNum ?? this.exportProceedsNum,
      exportProceedsAmt: exportProceedsAmt ?? this.exportProceedsAmt,
      cashWithdrawalNum: cashWithdrawalNum ?? this.cashWithdrawalNum,
      cashWithdrawalAmt: cashWithdrawalAmt ?? this.cashWithdrawalAmt,
      transferWithdrawalNum: transferWithdrawalNum ?? this.transferWithdrawalNum,
      transferWithdrawalAmt: transferWithdrawalAmt ?? this.transferWithdrawalAmt,
    );
  }

  Map<String, dynamic> toJson() => {
    'sourceOfFund': sourceOfFund,
    'monthlyIncome': monthlyIncome,
    'cashDepositNum': cashDepositNum,
    'cashDepositAmt': cashDepositAmt,
    'transferDepositNum': transferDepositNum,
    'transferDepositAmt': transferDepositAmt,
    'foreignRemittanceNum': foreignRemittanceNum,
    'foreignRemittanceAmt': foreignRemittanceAmt,
    'exportProceedsNum': exportProceedsNum,
    'exportProceedsAmt': exportProceedsAmt,
    'cashWithdrawalNum': cashWithdrawalNum,
    'cashWithdrawalAmt': cashWithdrawalAmt,
    'transferWithdrawalNum': transferWithdrawalNum,
    'transferWithdrawalAmt': transferWithdrawalAmt,
  };

  factory TransactionProfile.fromJson(Map<String, dynamic> json) => TransactionProfile(
    sourceOfFund: json['sourceOfFund'] ?? '',
    monthlyIncome: json['monthlyIncome'] ?? '',
    cashDepositNum: json['cashDepositNum'] ?? '',
    cashDepositAmt: json['cashDepositAmt'] ?? '',
    transferDepositNum: json['transferDepositNum'] ?? '',
    transferDepositAmt: json['transferDepositAmt'] ?? '',
    foreignRemittanceNum: json['foreignRemittanceNum'] ?? '',
    foreignRemittanceAmt: json['foreignRemittanceAmt'] ?? '',
    exportProceedsNum: json['exportProceedsNum'] ?? '',
    exportProceedsAmt: json['exportProceedsAmt'] ?? '',
    cashWithdrawalNum: json['cashWithdrawalNum'] ?? '',
    cashWithdrawalAmt: json['cashWithdrawalAmt'] ?? '',
    transferWithdrawalNum: json['transferWithdrawalNum'] ?? '',
    transferWithdrawalAmt: json['transferWithdrawalAmt'] ?? '',
  );
}
