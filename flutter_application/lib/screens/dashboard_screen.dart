import 'package:flutter/material.dart';
import 'package:flutter_application/screens/calorie_screen.dart';
import 'package:flutter_application/screens/profil_screen.dart';
import 'package:flutter_application/screens/water_tracker_screen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Static data for dashboard
  final String username = "Fatma Zahra";
  final String date = "May 1, 2025";
  final int goalWeight = 70; // Final goal weight
  final double currentWeight = 75.0; // Current weight (Week 7)
  final double startWeight = 85.0; // Starting weight (Week 1)
  final int goalDays = 90; // Total goal duration in days
  final int completedDays = 49; // 7 weeks = 49 days
  final double progressPercentage = 49 / 90; // completedDays / goalDays
  
  // Nutrient tracking data
  final Map<String, double> nutrientData = {
    'Protein': 85.0,
    'Carbs': 62.0,
    'Fat': 48.0,
    'Fiber': 75.0,
  };
  
  // Weekly calorie data
  final List<double> weeklyCalories = [1800, 1950, 1750, 1850, 1700, 1900, 1800];
  final List<String> weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  
  // Water intake data
  final List<double> weeklyWater = [1.8, 2.1, 1.9, 2.3, 2.0, 1.7, 2.2];
  
  // Weekly weight tracking data - Values align with journey card data
  final List<double> weightHistory = [85.0, 83.2, 81.5, 79.8, 78.0, 76.5, 75.0];
  final List<String> weightDates = ['Week 1', 'Week 2', 'Week 3', 'Week 4', 'Week 5', 'Week 6', 'Week 7'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildProgressCard(),
              _buildWeightChart(),
              _buildCalorieChart(),
              _buildNutrientCards(),
              _buildWaterIntakeCard(),
              SizedBox(height: 80), // Space for bottom navigation
            ],
          ),
        ),
      ),
      
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/images/profil.png'),
                radius: 24,
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    date,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF2E6930),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Weight Loss Journey',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.trending_down, color: Colors.amber),
              ],
            ),
            SizedBox(height: 20),
            CircularPercentIndicator(
              radius: 80.0,
              lineWidth: 15.0,
              percent: progressPercentage,
              center: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$completedDays / $goalDays',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'DAYS',
                    style: TextStyle(color: Colors.green[300], fontSize: 14.0),
                  ),
                ],
              ),
              progressColor: Colors.amber,
              backgroundColor: Colors.green.withOpacity(0.3),
              circularStrokeCap: CircularStrokeCap.round,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildProgressStat('Start', '$startWeight kg', Colors.white70),
                _buildProgressStat('Current', '$currentWeight kg', Colors.white),
                _buildProgressStat('Goal', '$goalWeight kg', Colors.amber),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressStat(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildWeightChart() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Weight Progress',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Weekly', // Changed from "1 Year" to "Weekly"
                    style: TextStyle(
                      color: Colors.green[800],
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              height: 200,
              child:               _buildCustomLineChart(
                dataPoints: weightHistory,
                labels: weightDates,
                color: Color(0xFF2E6930),
                fillColor: Color(0xFF2E6930).withOpacity(0.1),
                minY: 70, // Min value aligned with goal weight
                maxY: 85, // Max value aligned with start weight
                horizontalLines: [70, 73, 76, 79, 82, 85], // Horizontal lines covering the full range
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomLineChart({
    required List<double> dataPoints,
    required List<String> labels,
    required Color color,
    required Color fillColor,
    required double minY,
    required double maxY,
    required List<double> horizontalLines,
  }) {
    return CustomPaint(
      size: Size(double.infinity, 200),
      painter: _CustomLineChartPainter(
        dataPoints: dataPoints,
        labels: labels,
        lineColor: color,
        fillColor: fillColor,
        minY: minY,
        maxY: maxY,
        horizontalLines: horizontalLines,
      ),
    );
  }

  Widget _buildCalorieChart() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Weekly Calories',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'This Week',
                    style: TextStyle(
                      color: Colors.green[800],
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              height: 200,
              child: _buildCustomBarChart(
                values: weeklyCalories,
                labels: weekDays,
                maxValue: 2500,
                primaryColor: Color(0xFF2E6930),
                thresholdValue: 1900,
                thresholdColor: Colors.red[400]!,
                horizontalLines: [500, 1000, 1500, 2000, 2500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomBarChart({
    required List<double> values,
    required List<String> labels,
    required double maxValue,
    required Color primaryColor,
    double? thresholdValue,
    Color? thresholdColor,
    required List<double> horizontalLines,
  }) {
    return CustomPaint(
      size: Size(double.infinity, 200),
      painter: _CustomBarChartPainter(
        values: values,
        labels: labels,
        maxValue: maxValue,
        primaryColor: primaryColor,
        thresholdValue: thresholdValue,
        thresholdColor: thresholdColor,
        horizontalLines: horizontalLines,
      ),
    );
  }

  Widget _buildNutrientCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nutrients Intake',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildNutrientCard('Protein', nutrientData['Protein']!, Colors.blue),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildNutrientCard('Carbs', nutrientData['Carbs']!, Colors.orange),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildNutrientCard('Fat', nutrientData['Fat']!, Colors.red),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildNutrientCard('Fiber', nutrientData['Fiber']!, Colors.green),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientCard(String nutrient, double percentage, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                nutrient,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${percentage.toInt()}%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey[200],
              color: color,
              minHeight: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaterIntakeCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Water Intake',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.water_drop, color: Colors.blue),
              ],
            ),
            SizedBox(height: 16),
            Container(
              height: 150,
              child: _buildCustomBarChart(
                values: weeklyWater,
                labels: weekDays,
                maxValue: 3,
                primaryColor: Colors.blue.withOpacity(0.8),
                horizontalLines: [1, 2, 3],
              ),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline, size: 14, color: Colors.grey),
                SizedBox(width: 4),
                Text(
                  'Recommended: 2L per day',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  }


// Custom painters for charts

class _CustomLineChartPainter extends CustomPainter {
  final List<double> dataPoints;
  final List<String> labels;
  final Color lineColor;
  final Color fillColor;
  final double minY;
  final double maxY;
  final List<double> horizontalLines;

  _CustomLineChartPainter({
    required this.dataPoints,
    required this.labels,
    required this.lineColor,
    required this.fillColor,
    required this.minY,
    required this.maxY,
    required this.horizontalLines,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final double chartWidth = width - 40; // Leave space for y-axis labels
    final double chartHeight = height - 30; // Leave space for x-axis labels
    final double chartLeft = 40;
    final double chartTop = 10;

    final Paint linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final Paint fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final Paint dotPaint = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.fill;

    final Paint dotStrokePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final Paint gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw horizontal grid lines
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (double value in horizontalLines) {
      final double y = chartTop + chartHeight - (value - minY) / (maxY - minY) * chartHeight;
      
      // Draw grid line
      canvas.drawLine(
        Offset(chartLeft, y),
        Offset(chartLeft + chartWidth, y),
        gridPaint,
      );
      
      // Draw y-axis label
      textPainter.text = TextSpan(
        text: value.toInt().toString(),
        style: TextStyle(color: Colors.grey[600], fontSize: 10),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(chartLeft - textPainter.width - 5, y - textPainter.height / 2),
      );
    }

    // Calculate points for the line
    final List<Offset> points = [];
    final double xStep = chartWidth / (dataPoints.length - 1);

    for (int i = 0; i < dataPoints.length; i++) {
      final double x = chartLeft + i * xStep;
      final double y = chartTop + chartHeight - (dataPoints[i] - minY) / (maxY - minY) * chartHeight;
      points.add(Offset(x, y));
    }

    // Draw fill
    final Path fillPath = Path()
      ..moveTo(points.first.dx, chartTop + chartHeight)
      ..lineTo(points.first.dx, points.first.dy);
    
    for (int i = 1; i < points.length; i++) {
      fillPath.lineTo(points[i].dx, points[i].dy);
    }
    
    // fillPath.lineTo(points.last.dx, chartTop + chartHeight)
    //   ..close();
    
    canvas.drawPath(fillPath, fillPaint);

    // Draw line
    final Path linePath = Path()..moveTo(points.first.dx, points.first.dy);
    
    for (int i = 1; i < points.length; i++) {
      if (i < points.length - 1) {
        final Offset p1 = points[i];
        final Offset p2 = points[i + 1];
        
        // Use a simple curve for smoother lines
        final Offset controlPoint = Offset(
          (p1.dx + p2.dx) / 2,
          p1.dy,
        );
        
        linePath.quadraticBezierTo(controlPoint.dx, controlPoint.dy, p2.dx, p2.dy);
      } else {
        linePath.lineTo(points[i].dx, points[i].dy);
      }
    }
    
    canvas.drawPath(linePath, linePaint);

    // Draw dots
    for (Offset point in points) {
      canvas.drawCircle(point, 4, dotPaint);
      canvas.drawCircle(point, 4, dotStrokePaint);
    }

    // Draw x-axis labels
    for (int i = 0; i < labels.length; i++) {  // Show all weekly labels
      final double x = chartLeft + i * chartWidth / (dataPoints.length - 1);
      textPainter.text = TextSpan(
        text: labels[i],
        style: TextStyle(color: Colors.grey[600], fontSize: 10),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, chartTop + chartHeight + 5),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _CustomBarChartPainter extends CustomPainter {
  final List<double> values;
  final List<String> labels;
  final double maxValue;
  final Color primaryColor;
  final double? thresholdValue;
  final Color? thresholdColor;
  final List<double> horizontalLines;

  _CustomBarChartPainter({
    required this.values,
    required this.labels,
    required this.maxValue,
    required this.primaryColor,
    this.thresholdValue,
    this.thresholdColor,
    required this.horizontalLines,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final double chartWidth = width - 40; // Leave space for y-axis labels
    final double chartHeight = height - 30; // Leave space for x-axis labels
    final double chartLeft = 40;
    final double chartTop = 10;
    
    final double barWidth = (chartWidth - (values.length - 1) * 8) / values.length;

    final Paint gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // Draw horizontal grid lines
    for (double value in horizontalLines) {
      final double y = chartTop + chartHeight - (value / maxValue * chartHeight);
      
      canvas.drawLine(
        Offset(chartLeft, y),
        Offset(chartLeft + chartWidth, y),
        gridPaint,
      );
      
      textPainter.text = TextSpan(
        text: value.toInt().toString(),
        style: TextStyle(color: Colors.grey[600], fontSize: 10),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(chartLeft - textPainter.width - 5, y - textPainter.height / 2),
      );
    }

    // Draw bars
    for (int i = 0; i < values.length; i++) {
      final double x = chartLeft + i * (barWidth + 8);
      final double barHeight = (values[i] / maxValue) * chartHeight;
      final double y = chartTop + chartHeight - barHeight;
      
      final Paint barPaint = Paint()
        ..color = thresholdValue != null && values[i] > thresholdValue! 
            ? thresholdColor! 
            : primaryColor
        ..style = PaintingStyle.fill;
      
      final RRect roundedRect = RRect.fromRectAndCorners(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        topLeft: Radius.circular(6),
        topRight: Radius.circular(6),
      );
      
      canvas.drawRRect(roundedRect, barPaint);
      
      // Draw x-axis label
      textPainter.text = TextSpan(
        text: labels[i],
        style: TextStyle(color: Colors.grey[600], fontSize: 10),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x + (barWidth - textPainter.width) / 2, chartTop + chartHeight + 5),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}