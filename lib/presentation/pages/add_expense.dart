import 'package:flutter/cupertino.dart';
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
  final TextEditingController _textFieldController = TextEditingController();

  
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
          _dateController.text = DateFormat('MMMM yyyy').format(picked);
        });
      }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          }, 
          icon: const Icon(CupertinoIcons.chevron_back)
        ),
        title: const Text('New Expense'),
      ),
      
      body: BlocListener<LocalBloc, LocalState>(
        listener: (context, state){
          if(state is ErrorState){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
          }
      },
      child: BlocBuilder<LocalBloc, LocalState>(builder: (context, state){
        if(state is LoadedExpenseTypes){
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                const SizedBox(height: 30),
                
                TextField(
                  controller: _dateController,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  decoration: InputDecoration(
                    labelText: 'Month',
                    hintText: 'YYYY-MM',
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8)
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8)
                    ),
                  ),
                ),
                
                const SizedBox(height: 30,),
                
                TextField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true), // Sets the keyboard type to number
                  inputFormatters: <TextInputFormatter>[
                     FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    hintText: 'amount',
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8)
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8)
                    ),
                  ),
                 
                ),
                
                const SizedBox(height: 20),
                
                 TextField(
                  controller: _noteController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'note',
                    hintText: 'note',
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0)
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8)
                    ),
                    
                  ),
                  
                ),
                
                const SizedBox(height: 30,),
                
                Container(
                  height: 55,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButton<String>(
                          value: selectedExpenseType,
                          hint: const Text('Expense Type'),
                          isExpanded: true,
                          underline: const SizedBox(),
                          dropdownColor: Colors.white,
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
                      ),
                      
                      TextButton(onPressed: (){
                        showDialog(
                          context: context,
                          builder: (context) {
                            return BlocProvider(
                              create: (context) => LocalBloc(),
                              child: BlocBuilder<LocalBloc, LocalState>(
                                builder: (context, state ){
                                  return AlertDialog(
                                  title: const Text('New Expense Type'),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)
                                  ),
                                  content: TextField(
                                    controller: _textFieldController,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(8)
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(8)
                                      ),
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    
                                    TextButton(
                                      child: const Text('Save'),
                                      onPressed: () {
                                        if(_textFieldController.text.length > 2){
                                          context.read<LocalBloc>().add(AddExpenseType(expenseType: ExpenseType(name: _textFieldController.text))); 
                                          Navigator.of(context).pop();
                                        }else{
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('name must be at least 3 characters')));
                                        }
                                        
                                      },
                                    ),
                                  ],
                                );
                                }
                              ),
                            );
                          },
                        );
                      }, child: const Text('New Type'))
                    ],
                  ),
                ),
                  
                const SizedBox(height: 50),
                
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 12, 
                    vertical: MediaQuery.of(context).size.width / 30),
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.grey)
                  ),
                  onPressed: (){
                    if(_amountController.text.isEmpty || 
                      _noteController.text.isEmpty || 
                      _dateController.text.isEmpty || 
                      selectedExpenseType == null){
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Error: All inputs must be filled', 
                              style: TextStyle(color: Colors.red)
                            ), 
                            backgroundColor: Colors.white,));
                    }else{
                      context.read<LocalBloc>().add(AddExpense(expense: Expense(
                        amount: double.parse(_amountController.text),
                        currency: 'ETB',
                        note: _noteController.text,
                        createdDate: _dateController.text,
                        expenseType: int.parse(selectedExpenseType!)
                      )));
                      Navigator.pop(context);
                    }    
                  }, 
                  child: const Text('Save', 
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black))
                  )
                  
              ],
            ),
          ),
        );}
        return Container();
      }),
      ),
    );
  }
  

}