import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_task/data/models/expense.dart';
import 'package:interview_task/presentation/bloc/local_db_bloc/local_bloc.dart';
import 'package:interview_task/presentation/bloc/local_db_bloc/local_event.dart';
import 'package:interview_task/presentation/bloc/local_db_bloc/local_state.dart';
import 'package:intl/intl.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpensePage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  
  String? selectedExpenseType;
  List<ExpenseType>? expenseTypes;

  @override
  void dispose() {
    _dateController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }
  
    Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        // Format the selected date to 'YYYY-MM'
        _dateController.text = DateFormat('MMMM yyyy').format(picked);
      });
    }
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Expense'),
      ),
      
      body: BlocListener<LocalBloc, LocalState>(
        listener: (context, state){
          if(state is LoadedExpenseTypes){
          
          }
      },
      child: BlocBuilder<LocalBloc, LocalState>(builder: (context, state){
        if(state is LoadedExpenseTypes){
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              TextField(
                controller: _dateController,
                readOnly: true,
                onTap: () => _selectDate(context),
                decoration: const InputDecoration(
                  labelText: 'Select Date',
                  hintText: 'YYYY-MM',
                ),
              ),
              const SizedBox(height: 30,),
              TextField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true), // Sets the keyboard type to number
                inputFormatters: <TextInputFormatter>[
                   FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Enter Number',
                  hintText: 'Enter a number',
                ),
               
              ),
              const SizedBox(height: 20),
               TextField(
                controller: _noteController,
                maxLines: 5, // Allows the TextField to expand vertically based on content
                decoration: const InputDecoration(
                  labelText: 'Enter text',
                  hintText: 'Enter multiple lines of text',
                  border: OutlineInputBorder(),
                ),
                
              ),
              
              const SizedBox(height: 30,),
              
              DropdownButton<String>(
                value: selectedExpenseType,
                hint: const Text('select expense type'),
                items: state.expenseTypes.map((expense) {
                            
                  return DropdownMenuItem<String>(
                    value: expense.id.toString(),
                    child: Text(expense.name.toString()),
                  );
                }).toList(),
                
                onChanged: (String? newKey) {
                  setState(() {
                    selectedExpenseType = newKey!;
                  });
                },
              ),
                
              const SizedBox(height: 30,),
              
              ElevatedButton(onPressed: (){
                context.read<LocalBloc>().add(AddExpense(expense: Expense(
                  amount: double.parse(_amountController.text),
                  currency: 'ETB',
                  note: _noteController.text,
                  createdDate: _dateController.text,
                  expenseType: int.parse(selectedExpenseType!)
                )));
                Navigator.pop(context);
              }, child: Text('submit'))          
                
            ],
          ),
        );}
        return Container();
      }),
      ),
    );
  }
  

}