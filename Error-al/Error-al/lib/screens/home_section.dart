import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeSection extends StatelessWidget {
  const HomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600;

    return Column(
      children: [
        const SizedBox(
            height: 80), // Adjust this value to move the UI further down
        // Stat Cards
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildStatCard(
              'Employees',
              '',
              Icons.people,
              Colors.green,
              isWideScreen,
              onTap: () => Navigator.pushNamed(context, '/employees'),
            ),
            _buildStatCard(
              'Interviews',
              '',
              Icons.assignment,
              Colors.orange,
              isWideScreen,
              onTap: () => Navigator.pushNamed(context, '/interview'),
            ),
            _buildStatCard(
              'Applicants',
              '',
              Icons.person_add,
              Colors.red,
              isWideScreen,
              onTap: () => Navigator.pushNamed(context, '/applicants'),
            ),
            _buildStatCard(
              'Pending',
              '',
              Icons.hourglass_empty,
              Colors.grey,
              isWideScreen,
              onTap: () => Navigator.pushNamed(context, '/pending'),
            ),
          ],
        ),
        const SizedBox(height: 22),
        _buildGraphCard(screenWidth),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    bool isWideScreen, {
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isWideScreen ? 290 : double.infinity,
        height: isWideScreen ? 140 : 180,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGraphCard(double width) {
    return Container(
      width: (width * 0.79),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hires per month',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 300,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 100,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey[200],
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 20,
                      reservedSize: 40,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        const months = [
                          'Jan',
                          'Feb',
                          'Mar',
                          'Apr',
                          'May',
                          'Jun',
                          'Jul',
                          'Aug',
                          'Sep',
                          'Oct',
                          'Nov',
                          'Dec'
                        ];
                        if (value.toInt() < months.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              months[value.toInt()],
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 10),
                      FlSpot(1, 25),
                      FlSpot(2, 45),
                      FlSpot(3, 30),
                      FlSpot(4, 60),
                      FlSpot(5, 20),
                      FlSpot(6, 35),
                      FlSpot(7, 40),
                      FlSpot(8, 35),
                      FlSpot(9, 35),
                      FlSpot(10, 40),
                      FlSpot(11, 45),
                    ],
                    isCurved: true,
                    color: const Color(0xFF358873),
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFF358873).withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
