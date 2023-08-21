import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'bottom_navigation.dart';
import 'helpers/db_helper.dart';

class LogoPage extends StatefulWidget {
  @override
  _LogoPageState createState() => _LogoPageState();
}

class _LogoPageState extends State<LogoPage> {
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    final orderList = await DBHelper.getOrders();

    setState(() {
      orders = orderList;
    });
  }

  // totaalprijs
  double calculateTotalPrice() {
    DateTime now = DateTime.now();
    DateTime start = now.subtract(Duration(hours: 16)); // 16 uur = totaal

    double totalPrice = 0;

    for (var order in orders) {
      DateTime completedTime = DateTime.parse(order['completedTime']);
      if (completedTime.isAfter(start) && completedTime.isBefore(now)) {
        totalPrice += order['totalPrice'];
      }
    }

    return totalPrice;
  }

  // totale prijs
  Widget _buildTotalPrice() {
    double totalPrice = calculateTotalPrice();
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Text(
        'Total: \€${totalPrice.toStringAsFixed(2)}',
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  // grafiek
  Widget _buildChart() {
    Map<DateTime, List<OrderData>> groupedData = {};

    for (var order in orders) {
      DateTime completedTime = DateTime.parse(order['completedTime']);
      DateTime roundedTime = DateTime(
        completedTime.year,
        completedTime.month,
        completedTime.day,
        completedTime.hour,
        (completedTime.minute ~/ 15) * 15,
      );

      groupedData[roundedTime] ??= [];
      groupedData[roundedTime]!.add(OrderData(
        order['completedTime'],
        order['totalPrice'],
      ));
    }

    DateTime now = DateTime.now();
    DateTime start = now.subtract(Duration(hours: 16)); // diplay de laatste 16 uur

    final series = [
      charts.Series<OrderData, DateTime>(
        id: 'Orders',
        domainFn: (OrderData order, _) => DateTime.parse(order.completedTime),
        measureFn: (OrderData order, _) => order.totalPrice,
        data: groupedData.entries
            .map((entry) => OrderData(
                  entry.key.toIso8601String(),
                  entry.value.fold(
                      0, (sum, order) => sum + order.totalPrice),
                ))
            .toList(),
      ),
    ];

    return charts.TimeSeriesChart(
      series,
      animate: true,
      domainAxis: charts.DateTimeAxisSpec(
        viewport: charts.DateTimeExtents(
          start: start,
          end: now,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2D3945),
        title: Text('Statistics'),
        automaticallyImplyLeading: false,
        actions: [
          _buildTotalPrice(),
        ],
      ),
      body: Center(
        child: _buildChart(),
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.popUntil(context, ModalRoute.withName('/'));
            Navigator.pushNamed(context, '/directe_verkoop');
          } else if (index == 2) {
            Navigator.popUntil(context, ModalRoute.withName('/'));
            Navigator.pushNamed(context, '/settings_page');
          }
        },
      ),
    );
  }
}

class OrderData {
  final String completedTime;
  final double totalPrice;

  OrderData(this.completedTime, this.totalPrice);
}
