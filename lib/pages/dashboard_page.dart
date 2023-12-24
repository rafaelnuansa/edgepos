// import 'package:edgepos/app_color.dart';
import 'package:edgepos/pages/custom_loading_screen.dart';
import 'package:edgepos/services/dashboard_api.dart';
import 'package:edgepos/widget/sales_overview_card.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  DashboardPageState createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  final DashboardApi _dashboardApi = DashboardApi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _dashboardApi.getAllData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CustomLoadingScreen(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final Map<String, dynamic> data = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildSalesOverview(data),
                  const SizedBox(height: 16.0),
                  buildTabs(data),
                ],
              ),
            );
          }
        },
      ),
    );
  }
  
Widget buildSalesOverview(Map<String, dynamic> data) {
  int crossAxisCount;

  // Set jumlah kolom berdasarkan lebar layar
  if (MediaQuery.of(context).size.width > 600 &&
      MediaQuery.of(context).size.width <= 900) {
    crossAxisCount = 3; // Tiga kolom untuk tablet
  } else if (MediaQuery.of(context).size.width > 900) {
    crossAxisCount = 4; // Empat kolom untuk desktop
  } else {
    crossAxisCount = 2; // Dua kolom untuk hp
  }

  final List<Map<String, String>> salesData = [
    {'title': 'Today Sales', 'key': 'todaySales'},
    {'title': 'Monthly Sale', 'key': 'monthlySale'},
    {'title': 'Total Sale', 'key': 'totalSale'},
    {'title': 'Total Return', 'key': 'totalReturn'},
    {'title': 'Today Profit', 'key': 'todayProfit'},
    {'title': 'Monthly Profit', 'key': 'monthlyProfit'},
    {'title': 'Total Profit', 'key': 'totalProfit'},
  ];

  return Container(
    padding: const EdgeInsets.all(16.0),
 
    child: GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
            childAspectRatio: 1.3, // Adjust as needed
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: salesData.length,
      itemBuilder: (context, index) {
        return SalesOverviewCard(
          title: salesData[index]['title']!,
          value: data['basicData'][salesData[index]['key']!],
        );
      },
    ),
  );
}

  Widget buildTabs(Map<String, dynamic> data) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 240,
      child: DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Sales & Profit Chart'),
                Tab(text: 'Last 7 Days Profit'),
              ],
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: TabBarView(
                children: [
                  // Sales & Profit Chart Tab
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sales & Profit Overview',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text('This Year'),
                          const SizedBox(height: 16.0),
                          AspectRatio(
                            aspectRatio: 1,
                            child: BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.spaceAround,
                                barTouchData: BarTouchData(
                                  touchTooltipData: BarTouchTooltipData(
                                    tooltipBgColor: Colors.blueGrey,
                                  ),
                                  touchCallback: (barTouchResponse, _) {
                                    // Handle touch events jika diperlukan
                                  },
                                  handleBuiltInTouches: true,
                                ),
                                titlesData: FlTitlesData(
                                  leftTitles: SideTitles(
                                    showTitles: false,
                                  ),
                                  topTitles: SideTitles(
                                    showTitles: false,
                                  ),
                                  bottomTitles: SideTitles(
                                    showTitles: true,
                                    getTitles: (value) {
                                      final months = [
                                        "Jan",
                                        "Feb",
                                        "Mar",
                                        "Apr",
                                        "May",
                                        "Jun",
                                        "Jul",
                                        "Aug",
                                        "Sep",
                                        "Oct",
                                        "Nov",
                                        "Dec"
                                      ];
                                      if (value >= 0 && value < months.length) {
                                        return months[value.toInt()];
                                      }
                                      return '';
                                    },
                                  ),
                                ),
                                borderData: FlBorderData(
                                  show: true,
                                  border: Border.all(
                                    color: const Color(0xff37434d),
                                    width: 1,
                                  ),
                                ),
                                barGroups: List.generate(
                                  data['barChartData']['sales'].length,
                                  (index) {
                                    return BarChartGroupData(
                                      x: index,
                                      barRods: [
                                        BarChartRodData(
                                          y: double.parse(data['barChartData']
                                              ['sales'][index]),
                                          colors: [
                                            const Color.fromARGB(
                                                255, 117, 76, 175)
                                          ],
                                          width: 10,
                                        ),
                                        BarChartRodData(
                                          y: double.parse(data['barChartData']
                                              ['profit'][index]),
                                          colors: [Colors.red],
                                          width: 10,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Last 7 Days Profit Tab
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Last 7 Days Profit',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text('This Week'),
                          const SizedBox(height: 16.0),
                          AspectRatio(
                            aspectRatio: 1,
                            child: LineChart(
                              LineChartData(
                                titlesData: FlTitlesData(
                                  rightTitles: SideTitles(
                                    showTitles: false,
                                  ),
                                  topTitles: SideTitles(
                                    showTitles: false,
                                  ),
                                  bottomTitles: SideTitles(
                                    showTitles: true,
                                    margin: 10,
                                    interval: 1,
                                    getTitles: (value) {
                                      final days =
                                          data["lineChartData"]["days"];
                                      if (value < days.length) {
                                        return days[value.toInt()];
                                      }
                                      return '';
                                    },
                                  ),
                                ),
                                borderData: FlBorderData(
                                  show: true,
                                  border: Border.all(
                                    color: const Color(0xff37434d),
                                    width: 1,
                                  ),
                                ),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: List.generate(
                                      data["lineChartData"]["profit"].length,
                                      (index) => FlSpot(
                                        index.toDouble(),
                                        double.parse(
                                          data["lineChartData"]["profit"]
                                              [index],
                                        ),
                                      ),
                                    ),
                                    isCurved: true,
                                    colors: [Colors.blue],
                                    dotData: FlDotData(show: false),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      colors: [Colors.blue.withOpacity(0.3)],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
