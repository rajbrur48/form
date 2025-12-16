import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import '../../providers/form_provider.dart';
import '../../services/pdf_generator_service.dart';

class ReviewStep extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(formProvider);

    return Column(
      children: [
        Text("Review & Generate PDF", style: Theme.of(context).textTheme.headlineSmall),
        SizedBox(height: 20),
        Expanded(
          child: PdfPreview(
            build: (format) => PdfGeneratorService().generatePdf(form),
            allowPrinting: true,
            allowSharing: true,
          ),
        ),
      ],
    );
  }
}
