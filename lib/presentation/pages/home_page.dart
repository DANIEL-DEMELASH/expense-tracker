import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_task/data/data_sources/local/expense_db.dart';
import 'package:interview_task/data/models/expense.dart';
import 'package:interview_task/data/models/income.dart';
import 'package:interview_task/data/models/total.dart';
import 'package:interview_task/presentation/bloc/local_db_bloc/local_bloc.dart';
import 'package:interview_task/presentation/bloc/local_db_bloc/local_event.dart';
import 'package:interview_task/presentation/bloc/local_db_bloc/local_state.dart';
import 'package:interview_task/presentation/pages/add_expense.dart';
import 'package:interview_task/presentation/pages/add_income.dart';
import 'package:pie_chart/pie_chart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  String? selectedMonthID;
  String? selectedMonthName;
  Total? selectedTotal;
  List<Total>? totalList;
  List<Income>? incomeList;
  List<Expense>? expensesList;
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
  Map<String, double> convertToMap(List<Income> incomeList) {
    Map<String, double> incomeMap = {};

    if (incomeList.isEmpty) {
      return incomeMap;
    }

    for (var income in incomeList) {
      if (income.amount != null && income.incomeTypeName != null) {
        String key = '${income.id} ${income.incomeTypeName!}';
        incomeMap[key] = income.amount!;
      }
    }

    return incomeMap;
  }

  Map<String, double> convertToExpenseMap(List<Expense> expenseList) {
    Map<String, double> expenseMap = {};

    if (expenseList.isEmpty) {
      return expenseMap;
    }

    for (var expense in expenseList) {
      if (expense.amount != null) {
        String key = '${expense.id} ${expense.expenseTypeName}';
        expenseMap[key] = expense.amount!;
      }
    }

    return expenseMap;
  }


double calculateTotalAmount(List<Income> incomeList) {
  double totalAmount = 0;
  for (var income in incomeList) {
    totalAmount += income.amount ?? 0;
  }
  return totalAmount;
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Monefy Clone'),
      ),
      body: Column(
        children: [
          BlocListener<LocalBloc, LocalState>(
            listener: (context, state){
              if(state is LoadedTotalList){
                setState(() {
                  totalList = state.totalLists;
                  // selectedMonth = state.totalLists.last.id.toString();
                  //  context.read<LocalBloc>().add(GetTotal(int.parse(selectedMonth!)));
                });
              }
              if(state is LoadedTotal){
                setState(() {
                  selectedTotal = state.total;
                });
              }
              
              if(state is LoadedIncome){
                setState(() {
                  incomeList = state.incomeList;  
                });
                
              }
              
               if(state is LoadedExpense){
                setState(() {
                  expensesList = state.expenseList;  
                });
              }
              
              if(state is ExpenseSaved){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('expense saved with ID ${state.id}')));
              }
            },
            child: BlocBuilder<LocalBloc, LocalState>(
              builder: (context, state){
                
                if(state is LoadingTotalList){
                  return const CircularProgressIndicator();
                  }  
                  
                return DropdownButton<String>(
                  value: selectedMonthID,
                  hint: const Text('select a month'),
                  items: totalList?.map((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.id.toString(),
                    child: Text(entry.month.toString()),
                  );
                }).toList(),
                onChanged: (String? newKey) {
                  setState(() {
                    selectedMonthID = newKey!;
                  });
                  context.read<LocalBloc>().add(GetTotal(int.parse(newKey!)));
                  context.read<LocalBloc>().add(GetIncomesByMonth(id: int.parse(newKey)));
                  context.read<LocalBloc>().add(GetExpensesByMonth(id: int.parse(newKey)));
                },
              );
                  
              }
            ),
          ),
          
          TabBar(
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black,
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
                        
          const SizedBox(height: 0),
          
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                PieChart(
                  dataMap: {
                    'Income' : selectedTotal?.totalIncome ?? 0,
                    'Expense' : selectedTotal?.totalExpense ?? 0
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
                  centerText: "Balance ${selectedTotal?.balance} ${selectedTotal?.currency}",
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
                  // gradientList: ---To add gradient colors---
                  // emptyColorGradient: ---Empty Color gradient---
                ),
                // Container(),
                PieChart(
                  dataMap: incomeList != null ? (incomeList!.isNotEmpty ? convertToMap(incomeList!) : {'Income': 0.0}) : {'Income': 0.0},
                  animationDuration: Duration(milliseconds: 800),
                  chartLegendSpacing: 32,
                  chartRadius: MediaQuery.of(context).size.width / 2,
                  initialAngleInDegree: 0,
                  chartType: ChartType.ring,
                  ringStrokeWidth: 32,
                  centerText: "Total income ${calculateTotalAmount(incomeList ?? [])} ${incomeList?.first.currency}",
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
                  // gradientList: ---To add gradient colors---
                  // emptyColorGradient: ---Empty Color gradient---
                ),
                
                PieChart(
                  dataMap: expensesList != null ? (expensesList!.isNotEmpty ? convertToExpenseMap(expensesList!) : {'Expense': 0.0}) : {'Expense': 0.0},
                  animationDuration: const Duration(milliseconds: 800),
                  chartLegendSpacing: 32,
                  chartRadius: MediaQuery.of(context).size.width / 2,
                  initialAngleInDegree: 0,
                  chartType: ChartType.ring,
                  ringStrokeWidth: 32,
                  
                  centerText: "Total expense ${calculateTotalExpenseAmount(expensesList ?? [])} ${expensesList?.first.currency}",
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
                  // gradientList: ---To add gradient colors---
                  // emptyColorGradient: ---Empty Color gradient---
                ),      
              ]
            )
          )
              
        ],
      ),
      
      bottomSheet: SizedBox(
        height: 60,
        child: Row(
          children: [
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => BlocProvider(create: (context) => LocalBloc()..add(GetIncomeTypes()), child: AddIncomePage())));
            }, child: const Text('add income')),
            ElevatedButton(onPressed: (){
              Navigator.push(
                context, MaterialPageRoute(
                  builder: (context) =>  BlocProvider(
                    create: (context) => LocalBloc()..add(GetExpenseTypes()), 
                    child: const AddExpensePage(),
                    )));
            }, child: const Text('add expense')),
          ],
        ),
      ),
    );
  }
}