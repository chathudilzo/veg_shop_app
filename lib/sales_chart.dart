// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:get/get.dart';
// import 'package:veg_shop_app/vegeitable_controller.dart';

// class SalesChart extends StatefulWidget {
//    SalesChart({super.key});

//   @override
//   State<SalesChart> createState() => _SalesChartState();
// }

// class _SalesChartState extends State<SalesChart> {
// List<Map<String,dynamic>> valueList=[];
// VegetableController controller=Get.find();
// @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     fetchData();
//   }

//   fetchData(){
//     setState(() {
//       valueList=controller.finalValueList;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BarChart(
//       BarChartData(barTouchData: barTouchData,
//         titlesData: titlesData,
//         borderData: borderData,
//         barGroups: barGroups,
//         gridData:  FlGridData(show: false),
//         alignment: BarChartAlignment.spaceAround,
//         maxY: 20,)
//     );
//   }

//    BarTouchData get barTouchData => BarTouchData(
//         enabled: false,
//         touchTooltipData: BarTouchTooltipData(
//           tooltipBgColor: Colors.transparent,
//           tooltipPadding: EdgeInsets.zero,
//           tooltipMargin: 8,
//           getTooltipItem: (
//             BarChartGroupData group,
//             int groupIndex,
//             BarChartRodData rod,
//             int rodIndex,
//           ) {
//             return BarTooltipItem(
//               rod.toY.round().toString(),
//               const TextStyle(
//                 color: Colors.cyan,
//                 fontWeight: FontWeight.bold,
//               ),
//             );
//           },
//         ),
//       );

// Widget getTitles(double value, TitleMeta meta, List<Map<String, dynamic>> valueList) {
//   final style = TextStyle(
//     color: Colors.blue,
//     fontWeight: FontWeight.bold,
//     fontSize: 14,
//   );
//   String text;
//   if (value.toInt() < valueList.length) {
//     text = valueList[value.toInt()]['name'];
//   } else {
//     text = '';
//   }
//   return SideTitleWidget(
//     axisSide: meta.axisSide,
//     space: 4,
//     child: Text(text, style: style),
//   );
// }

// FlTitlesData get titlesData => FlTitlesData(
//   show: true,
//   bottomTitles: AxisTitles(
//     sideTitles: SideTitles(
//       showTitles: true,
//       reservedSize: 30,
//       getTitlesWidget: (value, previousValue, _) =>
//           getTitles(value, TitleMeta.bottom, valueList),
//     ),
//   ),
//   leftTitles:  AxisTitles(
//     sideTitles: SideTitles(showTitles: false),
//   ),
//   topTitles:  AxisTitles(
//     sideTitles: SideTitles(showTitles: false),
//   ),
//   rightTitles:  AxisTitles(
//     sideTitles: SideTitles(showTitles: false),
//   ),
// );


// }