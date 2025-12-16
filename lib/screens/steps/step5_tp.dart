import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/form_provider.dart';
import '../../models/application_form.dart';

class TransactionProfileStep extends ConsumerWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const TransactionProfileStep({Key? key, required this.onNext, required this.onBack}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(formProvider);
    final notifier = ref.read(formProvider.notifier);
    final tp = form.transactionProfile;

    void _updateTp(TransactionProfile newTp) {
        notifier.updateField(form.copyWith(transactionProfile: newTp));
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("ট্রানজেকশন প্রোফাইল (টিপি)", style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: 10),

          TextFormField(
            initialValue: tp.sourceOfFund,
            decoration: InputDecoration(labelText: "আয়ের উৎস"),
            onChanged: (v) => _updateTp(TransactionProfile(
                sourceOfFund: v, monthlyIncome: tp.monthlyIncome,
                cashDepositNum: tp.cashDepositNum, cashDepositAmt: tp.cashDepositAmt
            )),
          ),
          SizedBox(height: 10),
          TextFormField(
            initialValue: tp.monthlyIncome,
            decoration: InputDecoration(labelText: "মাসিক আয় (আনুমানিক)"),
            onChanged: (v) => _updateTp(TransactionProfile(
                sourceOfFund: tp.sourceOfFund, monthlyIncome: v,
                cashDepositNum: tp.cashDepositNum, cashDepositAmt: tp.cashDepositAmt
            )),
          ),
           SizedBox(height: 20),
           Text("প্রত্যাশিত লেনদেন (মাসিক)", style: Theme.of(context).textTheme.titleMedium),
           SizedBox(height: 10),
           Row(
               children: [
                   Expanded(child: TextFormField(
                        initialValue: tp.cashDepositNum,
                        decoration: InputDecoration(labelText: "নগদ জমা (সংখ্যা)"),
                        onChanged: (v) => _updateTp(TransactionProfile(
                            sourceOfFund: tp.sourceOfFund, monthlyIncome: tp.monthlyIncome,
                            cashDepositNum: v, cashDepositAmt: tp.cashDepositAmt
                        )),
                   )),
                   SizedBox(width: 10),
                   Expanded(child: TextFormField(
                        initialValue: tp.cashDepositAmt,
                        decoration: InputDecoration(labelText: "নগদ জমা (পরিমাণ)"),
                        onChanged: (v) => _updateTp(TransactionProfile(
                            sourceOfFund: tp.sourceOfFund, monthlyIncome: tp.monthlyIncome,
                            cashDepositNum: tp.cashDepositNum, cashDepositAmt: v
                        )),
                   )),
               ],
           ),

          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                OutlinedButton(onPressed: onBack, child: Text("পেছনে")),
                ElevatedButton(onPressed: onNext, child: Text("পরবর্তী")),
            ],
          )
        ],
      ),
    );
  }
}
