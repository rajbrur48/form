import '../models/application_form.dart';

class RiskCalculator {
  // Occupation Scores
  static const Map<String, int> _occupationScores = {
    'Housewife': 4,
    'Service': 0,
    'Business': 5,
    'Student': 0,
    'Unemployed': 5,
    'Others': 3,
  };

  // Product Type Scores
  static const Map<String, int> _productScores = {
    'Current': 5,
    'Savings': 0,
    'FDR': 0,
    'DPS': 0,
  };

  static int calculateRiskScore(ApplicationForm form) {
    int score = 0;

    // 1. Product Type Risk
    score += _productScores[form.accountType] ?? 0;

    // 2. Occupation Risk
    // Normalize occupation string or handle variations
    String occ = form.occupation;
    // Simple matching, could be more robust
    if (occ.contains('Housewife') || occ.contains('গৃহিণী')) {
      score += 4;
    } else if (occ.contains('Business') || occ.contains('ব্যবসা')) {
      score += 5;
    } else if (occ.contains('Service') || occ.contains('চাকুরি')) {
      score += 0;
    } else if (occ.contains('Student') || occ.contains('ছাত্র')) {
      score += 0;
    } else {
      score += 3; // Default for others
    }

    // 3. Geographic Risk (Default 0 for now)
    score += 0;

    // 4. Transaction Profile Risk (Monthly Income / Transaction Volume)
    // Assuming simple threshold: > 100,000 BDT = Higher Risk
    double monthlyIncome = double.tryParse(form.transactionProfile.monthlyIncome) ?? 0;
    if (monthlyIncome > 100000) {
      score += 5;
    }

    return score;
  }

  static String getRiskRating(int score) {
    if (score >= 15) {
      return 'High';
    } else {
      return 'Low'; // As per 7.png, < 15 is Low
    }
  }
}
