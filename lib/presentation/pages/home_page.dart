import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

    for (var income in incomeList) {
      if (income.amount != null && income.incomeTypeName != null) {
        String key = income.incomeTypeName!;
        incomeMap[key] = income.amount!;
      }
    }
    return incomeMap;
  }

  Map<String, double> convertToExpenseMap(List<Expense> expenseList) {
    Map<String, double> expenseMap = {};

    for (var expense in expenseList) {
      if (expense.amount != null) {
        String key = '${expense.expenseTypeName}';
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
      
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(height: 20),
            
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
                    
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(4)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButton<String>(
                        value: selectedMonthID,
                        hint: const Text('select a month'),
                        underline: const SizedBox(),
                        dropdownColor: Colors.white,
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
                                    ),
                    ),
                  );
                    
                }
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
                  selectedTotal != null ? PieChart(
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
                  ) : const Center(child: Text('Please select a month'),),
                  
                  
                  (incomeList != null) ? incomeList!.isNotEmpty ? PieChart(
                    dataMap: convertToMap(incomeList!) ,
                    animationDuration: const Duration(milliseconds: 800),
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
                  ):const Center(child: Text('You don\'t have Income this month'),) :const Center(child: Text('Please select a month')),
                  
                  (expensesList != null ) ? expensesList!.isNotEmpty ? PieChart(
                    dataMap: convertToExpenseMap(expensesList!),
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
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => LocalBloc()..add(GetIncomeTypes()),
                      child: const AddIncomePage(),
                    )
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
                    'Add Income',
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
                Navigator.push(
                  context, MaterialPageRoute(
                    builder: (context) =>  BlocProvider(
                      create: (context) => LocalBloc()..add(GetExpenseTypes()), 
                      child: const AddExpensePage(),
                    )
                  )
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
                    'Add Expense',
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