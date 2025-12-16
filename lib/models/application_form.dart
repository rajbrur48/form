
class ApplicationForm {
  // --- Personal Information (Page 1) ---
  String accountType; // Savings, Current, etc.
  String currency; // BDT, USD, etc.
  String operationMode; // Singly, Jointly

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

  // --- Office Use / Risk Grading (Page 6-9) ---
  // Updated types for better handling
  int riskScore;
  String riskRating; // High/Low
  String riskGradingComments;

  ApplicationForm({
    this.accountType = 'Savings',
    this.currency = 'BDT',
    this.operationMode = 'Singly',
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
  });

  // Factory for empty form
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
  }) {
    return ApplicationForm(
      accountType: accountType ?? this.accountType,
      currency: currency ?? this.currency,
      operationMode: operationMode ?? this.operationMode,
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
    );
  }
}

class Address {
  String flatNo;
  String roadNo;
  String village; // or Area
  String postOffice;
  String postCode;
  String policeStation; // Thana
  String district;

  Address({
    this.flatNo = '',
    this.roadNo = '',
    this.village = '',
    this.postOffice = '',
    this.postCode = '',
    this.policeStation = '',
    this.district = '',
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
  }) {
    return Address(
      flatNo: flatNo ?? this.flatNo,
      roadNo: roadNo ?? this.roadNo,
      village: village ?? this.village,
      postOffice: postOffice ?? this.postOffice,
      postCode: postCode ?? this.postCode,
      policeStation: policeStation ?? this.policeStation,
      district: district ?? this.district,
    );
  }

  String get fullAddress => [flatNo, roadNo, village, postOffice, policeStation, district].where((s) => s.isNotEmpty).join(', ');
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
}

class TransactionProfile {
  String sourceOfFund;
  String monthlyIncome;

  // Deposits (Number of Trans, Total Amount)
  String cashDepositNum;
  String cashDepositAmt;
  String transferDepositNum;
  String transferDepositAmt;
  String foreignRemittanceNum;
  String foreignRemittanceAmt;
  String exportProceedsNum;
  String exportProceedsAmt;

  // Withdrawals
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
}
