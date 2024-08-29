import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:interview_task/data/models/income.dart';
import 'package:interview_task/presentation/provider/local_provider/local_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddIncomePage extends StatefulWidget {
  const AddIncomePage({super.key});

  @override
  State<AddIncomePage> createState() => _AddIncomePageState();
}

class _AddIncomePageState extends State<AddIncomePage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _textFieldController = TextEditingController();
  
  String? selectedIncomeType;
  bool isVisible = false;
  
  @override
  void dispose() {
    _dateController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    _textFieldController.dispose();
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
    List<IncomeType>? incomeTypes = context.watch<LocalProvider>().incomeTypes;

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
        title: const Text('New Income'),
      ),
      
      body: SingleChildScrollView(
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
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    labelText: 'Note',
                    hintText: 'note',
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
                
                Container(
                  height: 55,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: Row(
                    children: [
                      incomeTypes != null ? Expanded(
                        child: DropdownButton<String>(
                          value: selectedIncomeType,
                          hint: const Text('Income Type'),
                          isExpanded: true,
                          underline: const SizedBox(),
                          dropdownColor: Colors.white,
                          items: incomeTypes.map((expense) {
                                      
                            return DropdownMenuItem<String>(
                              value: expense.id.toString(),
                              child: Text(expense.name.toString()),
                            );
                          }).toList(),
                          
                          onChanged: (String? newKey) {
                            setState(() {
                              selectedIncomeType = newKey;
                            });
                          },
                        ),
                      ) : const CircularProgressIndicator(),
                      
                      TextButton(onPressed: (){
                        setState(() {
                          isVisible = !isVisible;
                        });
                      }, child: const Text('New Type', style: TextStyle(color: Colors.black),))
                    ],
                  ),
                ),
                
                Visibility(
                  visible: isVisible,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: Column(
                      children: [
                        TextField(
                          controller: _textFieldController,
                          decoration: InputDecoration(
                            hintText: 'New Income Type',
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
                        
                        const SizedBox(height: 10,),
                        
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 12, 
                            vertical: MediaQuery.of(context).size.width / 30),
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: Colors.grey)
                          ),
                          child: const Text('Add Income Type', style: TextStyle(color: Colors.black, fontSize: 16),),
                            onPressed: () {
                              if(_textFieldController.text.length > 2){
                                setState(() {
                                  isVisible = false;
                                });
                                context.read<LocalProvider>().addIncomeType(IncomeType(name: _textFieldController.text)); 
                                _textFieldController.clear();
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Income Type Saved', style: TextStyle(color: Colors.green),), backgroundColor: Colors.white,));
                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('name must be at least 3 characters', style: TextStyle(color: Colors.red),), backgroundColor: Colors.white,));
                              }
                            },
                          ),
                                      
                          const SizedBox(height: 20)
                      ],),
                  )),
                  
                const SizedBox(height: 30,),
                
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 12, 
                    vertical: MediaQuery.of(context).size.width / 30),
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.grey)
                  ),
                  onPressed: (){
                    if(_amountController.text.isEmpty || _noteController.text.isEmpty || _dateController.text.isEmpty || selectedIncomeType == null){
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error: All inputs must be filled', style: TextStyle(color: Colors.red),), backgroundColor: Colors.white,));
                    }else{
                      context.read<LocalProvider>().addIncome(Income( 
                        amount: double.parse(_amountController.text),
                        currency: 'USD',
                        note: _noteController.text,
                        createdDate: _dateController.text,
                        incomeType: int.parse(selectedIncomeType!)));
                      context.read<LocalProvider>().getTotalList();
                      
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
        )
    );
  }
  

}