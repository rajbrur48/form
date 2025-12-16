import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/form_provider.dart';
import '../../models/application_form.dart';
import '../components/form_components.dart';
import '../../utils/bangla_amount_converter.dart';

class TransactionProfileStep extends ConsumerWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const TransactionProfileStep(
      {Key? key, required this.onNext, required this.onBack})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(formProvider);
    final notifier = ref.read(formProvider.notifier);
    final tp = form.transactionProfile;

    void _updateTp(TransactionProfile newTp) {
      notifier.updateField(form.copyWith(transactionProfile: newTp));
    }

    // Helper to sum deposits
    double get _totalDeposit {
      double cash = double.tryParse(tp.cashDepositAmt) ?? 0;
      double transfer = double.tryParse(tp.transferDepositAmt) ?? 0;
      double foreign = double.tryParse(tp.foreignRemittanceAmt) ?? 0;
      double export = double.tryParse(tp.exportProceedsAmt) ?? 0;
      return cash + transfer + foreign + export;
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionCard(
            title: "আয় ও উৎস",
            child: Column(
              children: [
                TextFormField(
                  initialValue: tp.sourceOfFund,
                  decoration: InputDecoration(labelText: "আয়ের উৎস"),
                  textInputAction: TextInputAction.next,
                  onChanged: (v) => _updateTp(tp.copyWith(sourceOfFund: v)),
                ),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: tp.monthlyIncome,
                  decoration: InputDecoration(labelText: "মাসিক আয় (আনুমানিক)"),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  onChanged: (v) => _updateTp(tp.copyWith(monthlyIncome: v)),
                ),
                if (tp.monthlyIncome.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 4),
                    child: Text(
                      BanglaAmountConverter.convert(double.tryParse(tp.monthlyIncome) ?? 0),
                      style: TextStyle(color: Colors.green.shade700, fontStyle: FontStyle.italic),
                    ),
                  ),
              ],
            ),
          ),
          SectionCard(
            title: "প্রত্যাশিত লেনদেন (মাসিক)",
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: tp.cashDepositNum,
                    decoration: InputDecoration(labelText: "সংখ্যা"),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onChanged: (v) => _updateTp(tp.copyWith(cashDepositNum: v)),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        initialValue: tp.cashDepositAmt,
                        decoration: InputDecoration(labelText: "পরিমাণ (টাকা)"),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        onChanged: (v) => _updateTp(tp.copyWith(cashDepositAmt: v)),
                      ),
                      if (tp.cashDepositAmt.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 4),
                          child: Text(
                            BanglaAmountConverter.convert(double.tryParse(tp.cashDepositAmt) ?? 0),
                            style: TextStyle(color: Colors.green.shade700, fontStyle: FontStyle.italic, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (_totalDeposit > 0)
             Padding(
               padding: const EdgeInsets.symmetric(vertical: 8.0),
               child: SectionCard(
                 title: "মোট মাসিক জমা (সর্বমোট)",
                 child: Text(
                   "${_totalDeposit.toStringAsFixed(0)} টাকা\n(কথায়: ${BanglaAmountConverter.convert(_totalDeposit)})",
                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                 ),
               ),
             ),

          SectionCard(
            title: "প্রাথমিক জমা",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: form.initialDeposit,
                  decoration: InputDecoration(labelText: "জমার পরিমাণ (টাকা)"),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  onChanged: (v) => notifier.updateField(form.copyWith(initialDeposit: v)),
                ),
                if (form.initialDeposit.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 4),
                    child: Text(
                      BanglaAmountConverter.convert(double.tryParse(form.initialDeposit) ?? 0),
                      style: TextStyle(color: Colors.green.shade700, fontStyle: FontStyle.italic),
                    ),
                  ),
              ],
            ),
          ),

          StepNavigationButtons(
            onBack: onBack,
            onNext: onNext,
          ),
        ],
      ),
    );
  }
}
