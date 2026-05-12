import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  List products = [];
  String selectedFilter = "هذا الشهر";
  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  List<int> get barData {
    final List<int> data = [0, 0, 0, 0];

    for (var p in products) {
      final d = getDaysLeft(p['expirationDate'] ?? "");

      if (d >= 0 && d <= 7)
        data[0]++;
      else if (d > 7 && d <= 14)
        data[1]++;
      else if (d > 14 && d <= 21)
        data[2]++;
      else if (d > 21 && d <= 30)
        data[3]++;
    }

    return data;
  }

  Future<void> loadProducts() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('products')
        .get();

    setState(() {
      products = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  int getDaysLeft(String date) {
    try {
      final expiry = DateTime.parse(date);
      return expiry.difference(DateTime.now()).inDays;
    } catch (e) {
      return 999;
    }
  }

  int get expiredCount =>
      products.where((p) => getDaysLeft(p['expirationDate'] ?? "") < 0).length;

  int get closeCount => products.where((p) {
    final d = getDaysLeft(p['expirationDate'] ?? "");
    return d >= 0 && d <= 7;
  }).length;

  int get safeCount =>
      products.where((p) => getDaysLeft(p['expirationDate'] ?? "") > 7).length;
  Map<String, int> get categoryData {
    final map = {
      "ألبان": 0,
      "معلبات": 0,
      "مشروبات": 0,
      "وجبات": 0,
      "حلويات": 0,
      "أدوية": 0,
    };

    for (var p in products) {
      final cat = p['category'] ?? "";
      if (map.containsKey(cat)) {
        map[cat] = map[cat]! + 1;
      }
    }

    return map;
  }

  Widget build(BuildContext context) {
    final data = barData;
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'التقارير والإحصائيات',
          style: TextStyle(
            color: Color(0xFF0B8F4D),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today, color: Color(0xFF0B8F4D)),
            onPressed: () {},
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),


              // General Stats
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'نظرة عامة',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          number: '$expiredCount',
                          label: 'منتهية الصلاحية',
                          color: Colors.red,
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.grey.shade300,
                        ),
                        _buildStatItem(
                          number: '$closeCount',
                          label: 'قاربت على الانتهاء',
                          color: Colors.orange,
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.grey.shade300,
                        ),
                        _buildStatItem(
                          number: '$safeCount',
                          label: 'صالحة',
                          color: Color(0xFF0B8F4D),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Pie Chart Section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'أكثر الفئات استهلاكاً',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 200,
                      child: PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                              value: categoryData["ألبان"]!.toDouble(),
                              title: '${categoryData["ألبان"]}',
                              color: Colors.blue,
                              radius: 60,
                            ),
                            PieChartSectionData(
                              value: categoryData["معلبات"]!.toDouble(),
                              title: '${categoryData["معلبات"]}',
                              color: Colors.orange,
                              radius: 60,
                            ),
                            PieChartSectionData(
                              value: categoryData["مشروبات"]!.toDouble(),
                              title: '${categoryData["مشروبات"]}',
                              color: Colors.green,
                              radius: 60,
                            ),
                            PieChartSectionData(
                              value: categoryData["وجبات"]!.toDouble(),
                              title: '${categoryData["وجبات"]}',
                              color: Colors.red,
                              radius: 60,
                            ),
                            PieChartSectionData(
                              value: categoryData["حلويات"]!.toDouble(),
                              title: '${categoryData["حلويات"]}',
                              color: Colors.blueGrey,
                              radius: 60,
                            ),
                            PieChartSectionData(
                              value: categoryData["أدوية"]!.toDouble(),
                              title: '${categoryData["أدوية"]}',
                              color: Colors.amber,
                              radius: 60,
                            ),
                          ],
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildLegendItem('ألبان', '35%', Colors.blue),
                    _buildLegendItem('معلبات', '25%', Colors.orange),
                    _buildLegendItem('مشروبات', '20%', Colors.green),
                    _buildLegendItem('حلويات', '20%', Colors.blueGrey),
                    _buildLegendItem('أدوية', '20%', Colors.amber),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Bar Chart Section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'المنتجات التي قاربت على الانتهاء',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 200,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 6,
                          barTouchData: BarTouchData(enabled: false),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  const days = [
                                    '1-7 مايو',
                                    '8-8 مايو',
                                    '21-21 مايو',
                                    '31-22 مايو',
                                  ];
                                  if (value.toInt() >= 0 &&
                                      value.toInt() < days.length) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        days[value.toInt()],
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    );
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                            leftTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          gridData: const FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          barGroups: [
                            BarChartGroupData(
                              x: 0,
                              barRods: [
                                BarChartRodData(
                                  toY: data[0].toDouble(),
                                  color: Colors.green,
                                  width: 20,
                                ),
                              ],
                            ),
                            BarChartGroupData(
                              x: 1,
                              barRods: [
                                BarChartRodData(
                                  toY: data[1].toDouble(),
                                  color: Colors.green,
                                  width: 20,
                                ),
                              ],
                            ),
                            BarChartGroupData(
                              x: 2,
                              barRods: [
                                BarChartRodData(
                                  toY: data[2].toDouble(),
                                  color: Colors.green,
                                  width: 20,
                                ),
                              ],
                            ),
                            BarChartGroupData(
                              x: 3,
                              barRods: [
                                BarChartRodData(
                                  toY: data[3].toDouble(),
                                  color: Colors.green,
                                  width: 20,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String number,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          number,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, String percentage, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontSize: 14)),
          const Spacer(),
          Text(
            percentage,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
