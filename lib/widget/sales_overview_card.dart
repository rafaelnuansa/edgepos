import 'package:edgepos/app_color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SalesOverviewCard extends StatelessWidget {
  final String title;
  final String value;

  const SalesOverviewCard({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColor.primaryColor, Colors.blue.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: const EdgeInsets.all(16.0),
    child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
              
                Expanded(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis, 
                    maxLines: 2,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              formatCurrency(value),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
    );
  }

  String formatCurrency(String value) {
    final currencyFormat = NumberFormat.currency(
      locale: 'ms_BN',
      symbol: 'BND',
    );
    return currencyFormat.format(double.parse(value));
  }
}
