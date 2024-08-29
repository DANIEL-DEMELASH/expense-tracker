
import 'package:flutter/material.dart';
import 'package:interview_task/data/models/currency.dart';
import 'package:interview_task/data/models/expense.dart';
import 'package:interview_task/data/models/income.dart';
import 'package:interview_task/data/models/total.dart';
import 'package:interview_task/presentation/pages/add_expense.dart';
import 'package:interview_task/presentation/pages/add_income.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import '../provider/local_provider/local_provider.dart';
import '../provider/remote_provider/remote_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  late TabController _tabController;
  
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  double calculateTotalIncomeAmount(List<Income> incomeList) {
    double totalAmount = 0;
    for (var income in incomeList) {
      totalAmount += income.amount ?? 0;
    }
    return totalAmount;
  }
  
  Map<String, double> convertToIncomeMap(List<Income> incomeList) {
    Map<String, double> incomeMap = {};

    for (var income in incomeList) {
      if (income.amount != null && income.incomeTypeName != null) {
        String key = '${income.incomeTypeName!} - ${income.amount}';
        incomeMap[key] = income.amount!;
      }
    }
    return incomeMap;
  }
  
  Map<String, double> convertToExpenseMap(List<Expense> expenseList) {
    Map<String, double> expenseMap = {};

    for (var expense in expenseList) {
      if (expense.amount != null) {
        String key = '${expense.expenseTypeName} - ${expense.amount}';
        expenseMap[key] = expense.amount!;
      }
    }
    return expenseMap;
  }
  
  double calculateTotalExpenseAmount(List<Expense> expenseList) {
    double totalAmount = 0;
    for (var expense in expenseList) {
      totalAmount += expense.amount ?? 0;
    }
    return totalAmount;
  }
  
  
  @override
  Widget build(BuildContext context) {
    Currency? currency = context.watch<RemoteProvider>().currency;
    double? selectedCurrencyRate = context.watch<RemoteProvider>().selectedCurrencyRate;
    
    final List<Total>? totalList = context.watch<LocalProvider>().totalList;
    final Total? selectedTotal = context.watch<LocalProvider>().selectedTotal;
    final List<Expense>? expenseList = context.watch<LocalProvider>().expenseList;
    final List<Income>? incomeList = context.watch<LocalProvider>().incomeList;
    
    return Scaffold(
      backgroundColor: Colors.white,
      
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Monefy Clone'),
        actions: [
          currency != null ? currency.data.isNotEmpty ?
          DropdownButton<double>(
            hint: const Text('USD'),
            value: selectedCurrencyRate,
            underline: const SizedBox(),
            dropdownColor: Colors.white,
            onChanged: (double? newValue) {
              context.read<RemoteProvider>().setCurrency(newValue!);
            },
            items: currency.data.entries.map<DropdownMenuItem<double>>((MapEntry<String, double> entry) {
              return DropdownMenuItem<double>(
                value: entry.value,
                child: Text(entry.key), 
              );
            }).toList(),
          )
          : const Text('data not found') : const CircularProgressIndicator() 
        ],
      ),
      
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(4)
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButton<Total>(
                  value: selectedTotal,
                  hint: const Text('select a month'),
                  underline: const SizedBox(),
                  dropdownColor: Colors.white,
                  items: totalList?.map((total) {
                    return DropdownMenuItem<Total>(
                      value: total,
                      child: Text(total.month.toString()),
                    );
                  }).toList(),
                  onChanged: (Total? newTotal) {
                    context.read<LocalProvider>().setCurrentTotal(newTotal!);
                  },
                ),
              ),
            ),
              
            const SizedBox(height: 20),
            
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F4F7),
                borderRadius: BorderRadius.circular(8)
              ),
              child: TabBar(
                unselectedLabelColor: const Color(0xFF667085),
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xff344054),
                ),
                dividerHeight: 0,
                indicatorWeight: 0,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(  
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
               
                controller: _tabController,
                  tabs: const [
                    Tab(
                      text: 'Summary',
                    ),
                    Tab(
                      text: 'Income',
                    ),
                    Tab(
                      text: 'Expense',
                    ),
                  ]
              ),
            ),
            
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  
                  // Total Tab
                  selectedTotal != null ? PieChart(
                    dataMap: {
                      'Income - ${selectedTotal.totalIncome}' : selectedTotal.totalIncome!,
                      'Expense - ${selectedTotal.totalExpense}' : selectedTotal.totalExpense!
                    },
                    animationDuration: const Duration(milliseconds: 800),
                    chartLegendSpacing: 32,
                    chartRadius: MediaQuery.of(context).size.width / 2,
                    colorList: const [
                      Colors.green,
                      Colors.red
                    ],
                    initialAngleInDegree: 0,
                    chartType: ChartType.ring,
                    ringStrokeWidth: 32,
                    centerText: "Balance ${((selectedTotal.balance)! * (selectedCurrencyRate ?? 1)).toStringAsFixed(2)}",
                    legendOptions: const LegendOptions(
                      showLegendsInRow: false,
                      legendPosition: LegendPosition.bottom,
                      showLegends: true,
                      legendShape: BoxShape.circle,
                      legendTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    chartValuesOptions: const ChartValuesOptions(
                      showChartValueBackground: true,
                      showChartValues: true,
                      showChartValuesInPercentage: true,
                      showChartValuesOutside: true,
                      decimalPlaces: 1,
                    ),
                  ) : const Center(child: Text('Please select a month'),),
                  
                  
                  // Income List Tab
                  (incomeList != null) ? incomeList.isNotEmpty ? PieChart(
                    dataMap: convertToIncomeMap(incomeList) ,
                    animationDuration: const Duration(milliseconds: 800),
                    chartLegendSpacing: 32,
                    chartRadius: MediaQuery.of(context).size.width / 2,
                    initialAngleInDegree: 0,
                    chartType: ChartType.ring,
                    ringStrokeWidth: 32,
                    centerText: "Total income ${(calculateTotalIncomeAmount(incomeList) * (selectedCurrencyRate ?? 1)).toStringAsFixed(2)}",
                    legendOptions: const LegendOptions(
                      showLegendsInRow: false,
                      legendPosition: LegendPosition.bottom,
                      showLegends: true,
                      legendShape: BoxShape.circle,
                      legendTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    chartValuesOptions: const ChartValuesOptions(
                      showChartValueBackground: true,
                      showChartValues: true,
                      showChartValuesInPercentage: false,
                      showChartValuesOutside: true,
                      decimalPlaces: 1,
                    ),
                  ):const Center(child: Text('You don\'t have Income this month'),) :const Center(child: Text('Please select a month')),
                  
                  // Expense List Tab
                  (expenseList != null ) ? expenseList.isNotEmpty ? PieChart(
                    dataMap: convertToExpenseMap(expenseList),
                    animationDuration: const Duration(milliseconds: 800),
                    chartLegendSpacing: 32,
                    chartRadius: MediaQuery.of(context).size.width / 2,
                    initialAngleInDegree: 0,
                    chartType: ChartType.ring,
                    ringStrokeWidth: 32,
                    centerText: "Total expense ${(calculateTotalExpenseAmount(expenseList) * (selectedCurrencyRate ?? 1)).toStringAsFixed(2)}",
                    legendOptions: const LegendOptions(
                      showLegendsInRow: false,
                      legendPosition: LegendPosition.bottom,
                      showLegends: true,
                      legendShape: BoxShape.circle,
                      legendTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    chartValuesOptions: const ChartValuesOptions(
                      showChartValueBackground: true,
                      showChartValues: true,
                      showChartValuesInPercentage: false,
                      showChartValuesOutside: true,
                      decimalPlaces: 1,
                    ),
                  ) : const Center(child: Text('You don\'t have Expense this month')): const Center(child: Text('Please select a month')),      
                ]
              )
            )
          ],
        ),
      ),
      
      bottomNavigationBar: SizedBox(
        width: double.infinity,
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                context.read<LocalProvider>().getIncomeTypes();
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) =>  const AddIncomePage(),
                  )
                );
              },
              child: Container(
                height: 55,
                width: MediaQuery.of(context).size.width / 2 - 26,
                padding:
                    const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(12)),
                child: const Center(
                  child: Text(
                    'New Income',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            
            GestureDetector(
              onTap: () {
                context.read<LocalProvider>().getExpenseTypes();
                Navigator.push(
                  context, MaterialPageRoute(
                    builder: (context) =>  const AddExpensePage()),
                );
              },
              child: Container(
                height: 55,
                width: MediaQuery.of(context).size.width / 2 - 26,
                padding:
                    const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(12)),
                child: const Center(
                  child: Text(
                    'New Expense',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ]
        )
      )
    );
  }
}