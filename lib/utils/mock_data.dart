import '../models/application_form.dart';

class MockData {
  static ApplicationForm getCompleteMockForm() {
    return ApplicationForm(
      accountType: 'Savings',
      currency: 'BDT',
      operationMode: 'Singly',

      // Personal
      applicantNameBangla: 'আব্দুর রহিম',
      applicantNameEnglish: 'ABDUR RAHIM',
      fatherName: 'করিম উদ্দিন',
      motherName: 'রহিমা বেগম',
      spouseName: 'না',
      dob: '15/05/1985',
      gender: 'Male',
      nationality: 'Bangladeshi',
      occupation: 'Service',
      monthlyIncome: '50,000',
      nidNumber: '1985269458712',

      // Address
      presentAddress: Address(
        flatNo: 'A-4',
        roadNo: 'Rd-12',
        village: 'Dhanmondi',
        postOffice: 'Dhaka GPO',
        postCode: '1209',
        policeStation: 'Dhanmondi',
        district: 'Dhaka',
      ),
      permanentAddress: Address(
        flatNo: 'H-20',
        roadNo: 'Vill-Rupnagar',
        village: 'Rupnagar',
        postOffice: 'Rupnagar',
        postCode: '3500',
        policeStation: 'Comilla Sadar',
        district: 'Comilla',
      ),

      // Professional / Introducer
      introducerName: 'Hasibur Rahman',
      introducerAccountNo: '2050111222',
      introducerBranch: 'Motijheel',

      // Nominee
      nominees: [
        Nominee(
          name: 'ফাতেমা খাতুন',
          relation: 'Wife',
          dob: '01/01/1990',
          percentage: '100%',
          nidNumber: '1990269458000',
          photoPath: '', // Will remain empty or placeholder
        )
      ],

      // Transaction Profile
      transactionProfile: TransactionProfile(
        sourceOfFund: 'Salary',
        monthlyIncome: '50,000',
        cashDepositNum: '2',
        cashDepositAmt: '20,000',
      ),

      // Beneficial Owner
      beneficialOwnerName: 'Self',
      beneficialOwnerRelation: 'N/A',
      beneficialOwnerDob: 'N/A',
      beneficialOwnerNid: 'N/A',
    );
  }
}
