import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:validators/validators.dart';

export 'edit.dart';

class expenses{
  String name;
  int amount;

  expenses(){
    this.name = "";
    this.amount = 0;
  }

}

class budget{
    int money;
    int incrementor;
    List<expenses> list;

    budget() {
      this.money = 0;
      this.list = List<expenses>();
      this.incrementor = 10;
    }
}

Future<String> get Path async{
  final directory = await getApplicationDocumentsDirectory();

  return ('${directory.path}/devData/');
}

Future<String> readContents(String f) async{

    final String filename = await Path + f;
    final String contents = await File(filename).readAsString();
    
    return contents;
}

Future<String> writeContents(String f,String contents) async{

    final String filename = await Path + f;
    File(filename).writeAsString(contents);

    return "";
}

class EditScreen extends StatefulWidget{

  final String filename;
  EditScreen(this.filename);

  @override
  EditScreenState createState() => EditScreenState();
}

class EditScreenState extends State<EditScreen>{

  int expenseTotal = 0;
  final incKey = GlobalKey<FormState>();
  final expKey = GlobalKey<FormState>();
  String contents;
  String sTemp;
  int temp;
  List<String> splitted;
  Color moneyColor = Colors.red;

  budget b = new budget();
  @override
  void initState(){
    super.initState();
    readContents(widget.filename).then((value) {
        this.setState(() {
          this.contents = value;
          this.parseContents();
          print(this.splitted);


          expenseTotal = 0;
          for(int i=0;i<b.list.length;i++)
            expenseTotal += b.list[i].amount;
        });
    });

  }

  void parseContents(){
    splitted = this.contents.split('\n');
    List<String> Split2;

    b = new budget();
    for(int i=0;i<splitted.length;i++){
        Split2 = splitted[i].split(' : ');
        if(i == 0){
           b.money = int.parse(Split2[1]);
        }
        else{
            expenses e = new expenses();
            e.name = Split2[0];
            e.amount = int.parse(Split2[1]);

            b.list.add(e);
        }
    }

    if(b.money >= 0)
        this.moneyColor = Colors.green;
    else
        this.moneyColor = Colors.red;
  }

  void changeState(){
    readContents(widget.filename).then((value) {
      this.setState(() {
        this.contents = value;
        parseContents();

        expenseTotal = 0;
        for(int i=0;i<b.list.length;i++)
            expenseTotal += b.list[i].amount;

        print(expenseTotal);
      });
    });

    print(b.list);
  }

  void updateContents(){
     contents = "";
     contents += "Money : ";
     contents += b.money.toString();

     for(int i=0;i<b.list.length;i++){
       contents += '\n';
       contents += b.list[i].name;
       contents += ' : ';
       contents += b.list[i].amount.toString();
     }
     writeContents(widget.filename,this.contents);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar : AppBar(
          title: Text(widget.filename),
          backgroundColor: Colors.black,
          brightness: Brightness.dark,
          elevation: 0.0,
        ),
        body : populator(),
        floatingActionButton: SpeedDial(
          child : Icon(Icons.add),
          backgroundColor: Colors.black,
          animatedIcon: AnimatedIcons.menu_close,
          children: <SpeedDialChild>[
            SpeedDialChild(
                label : 'Change Incrementor',
                child: Icon(Icons.edit),
                onTap: (){
                  showDialog(context: context, builder : (BuildContext context){
                    return (
                        AlertDialog(
                            title : Text('Change Increment for budget'),
                            content :
                              Container(
                                height : 80.0,
                                child :
                                  Form(
                                    key : incKey,
                                    child : Column(
                                      children: <Widget>[
                                        Container(
                                          child :
                                          TextFormField(
                                              decoration: InputDecoration(
                                                labelText: 'Enter value ',
                                                labelStyle: TextStyle(color : Colors.black),
                                              ),
                                              validator : (value){
                                                if(value.isEmpty || !isNumeric(value)){
                                                  return 'Please enter a valid incrementor';
                                                }

                                                this.setState(() {
                                                  temp = int.parse(value);
                                                });

                                                return null;
                                              }
                                          ),
                                          width : 200.0,
                                        ),
                                      ],
                                    ),
                                  ),

                              ),
                            actions : <Widget>[
                                  FlatButton(
                                    onPressed: (){
                                      if(incKey.currentState.validate()){
                                        b.incrementor = temp;
                                        Navigator.pop(context);
                                      }
                                    },
                                    child : Text('Change'),
                                    color : Colors.black,
                                  ),
                            ],
                        )
                    );
                  });
                },
                backgroundColor: Colors.black,
            ),

            SpeedDialChild(
              label : 'Change Budget',
              child: Icon(Icons.attach_money),
              onTap: (){
                showDialog(context: context, builder : (BuildContext context){
                  return (
                      AlertDialog(
                        title : Text('Change budget'),
                        content :
                        Container(
                          height : 80.0,
                          child :
                          Form(
                            key : incKey,
                            child : Column(
                              children: <Widget>[
                                Container(
                                  child :
                                  TextFormField(
                                      decoration: InputDecoration(
                                        labelText: 'Enter value ',
                                        labelStyle: TextStyle(color : Colors.black),
                                      ),
                                      validator : (value){
                                        if(value.isEmpty || !isNumeric(value)){
                                          return 'Please enter a valid budget';
                                        }

                                        this.setState(() {
                                          temp = int.parse(value);
                                        });

                                        return null;
                                      }
                                  ),
                                  width : 200.0,
                                ),
                              ],
                            ),
                          ),

                        ),
                        actions : <Widget>[
                          FlatButton(
                            onPressed: (){
                              if(incKey.currentState.validate()){
                                b.money = temp;
                                Navigator.pop(context);
                              }
                            },
                            child : Text('Change'),
                            color : Colors.black,
                          ),
                        ],
                      )
                  );
                });
              },
              backgroundColor: Colors.black,
            ),

          ],
        ),
    );
  }

  Widget createCard(expenses e){
     return Container(
       //width : 270.0,
       //height : 300.0,
       padding: EdgeInsets.symmetric(vertical: 30.0,horizontal: 20.0),
       margin : EdgeInsets.symmetric(vertical : 25.0,horizontal: 20.0),
       decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(20.0),
         color : Colors.grey[800],
       ),
       child :
           Row(
             children : <Widget>[
               Container(
                 width : 270.0,
                 child :
                  Row(
                   children : <Widget>[
                     Text('Name : ' + e.name,style : TextStyle(fontSize : 20.0,color : Colors.white)),
                     Text('    Amount : ' + e.amount.toString(),style : TextStyle(fontSize : 20.0,color : Colors.white)),
                   ],
                  ),
               ),

               GestureDetector(
                  onTap : (){
                    for(int i=0;i<b.list.length;i++){
                      if(b.list[i].name == e.name){
                        b.list.removeAt(i);
                        break;
                      }
                    }

                    updateContents();
                    changeState();
                  },
                  child : Icon(Icons.delete,color : Colors.white),
               ),
            ],
           ),
     );
  }

  dynamic createExpensesCards(){



      if(b.list.length > 0){

          return(
            b.list.map((val) => createCard(val)).toList()
          );
      }

      return <Widget>[];
  }
  Widget populator(){
    return Container(
        child : Column(
            children: <Widget>[
              Container(
                    padding: EdgeInsets.symmetric(vertical : 20.0,horizontal: 20.0),
                    child : Row(
                              children : <Widget> [
                                      Text(
                                        'Budget : ',
                                        style : TextStyle(fontSize: 30.0),
                                      ),
                                      Container(

                                        child :
                                            GestureDetector(
                                              onTap : (){
                                                b.money -= b.incrementor;
                                                updateContents();
                                                this.changeState();
                                                print(b.money);
                                              },
                                              child : Icon(Icons.arrow_left,size : 50.0),
                                            ),
                                        width: 50.0,
                                        //color:this.moneyColor,
                                      ),

                                      Text(
                                        '\$' + this.b.money.toString(),
                                        style: TextStyle(fontSize: 30.0,color: this.moneyColor),
                                      ),

                                      Container(
                                        child :
                                          GestureDetector(
                                              onTap : (){
                                                b.money += b.incrementor;
                                                updateContents();
                                                this.changeState();
                                                print(b.money);
                                              },
                                              child : Icon(Icons.arrow_right,size : 50.0),
                                           ),
                                        width: 50.0,
                                        //color:this.moneyColor,
                                      ),
                              ],
                    ),
              ),

              //Expense notifier
              Container(
                child :
                    Row(
                        children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child :
                                Row(
                                  children: <Widget>[
                                    Text(
                                      'Expenses : ' + expenseTotal.toString(),
                                       style : TextStyle(fontSize:20.0,color : Colors.black),
                                    ),
                                    Text(
                                      '     Remaining Budget : ' + (b.money - expenseTotal).toString(),
                                       style : TextStyle(fontSize:20.0,color : detColor(b.money - expenseTotal)),
                                    ),
                                  ],
                                ),
                              ),
                        ],
                    ),
              ),

              Container(
                margin : EdgeInsets.symmetric(vertical: 30.0),
                padding : EdgeInsets.symmetric(vertical : 15.0,horizontal: 20.0),
                color : Colors.black,
                width : 1000.0,
                child :
                Text('Expenses : ',style : TextStyle(fontSize: 30.0,color: Colors.white)),
              ),

              //Display Expenses
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: createExpensesCards(),
              ),

              //Create Expense Button
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
                width : 170.0,
                margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 30.0),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color : Colors.black,
                ),
                child :
                  GestureDetector(
                      onTap: (){
                        showDialog(context: context , builder: (BuildContext context){
                             return (
                                  AlertDialog(
                                     shape : RoundedRectangleBorder(
                                       borderRadius: BorderRadius.circular(20.0),
                                     ),
                                     title : Text('Add Expense'),
                                     content :
                                      Container(
                                        height : 180.0,
                                        child :
                                          Form(
                                            key : expKey,
                                            child : Column(
                                               children: <Widget>[
                                                 TextFormField(
                                                    decoration: InputDecoration(
                                                      labelText: 'Expense Name',
                                                      labelStyle: TextStyle(),
                                                    ),
                                                    validator: (value){
                                                       if(value.isEmpty){
                                                         return 'Enter a name!';
                                                       }
                                                       else if(value.length > 10){
                                                         return 'Length cannot exceed 10';
                                                       }

                                                       this.setState(() {
                                                          sTemp = value;
                                                       });
                                                       return null;
                                                    },
                                                 ),

                                                 TextFormField(
                                                   decoration: InputDecoration(
                                                     labelText : 'Enter Expense amount ',
                                                     labelStyle: TextStyle(),
                                                   ),

                                                   validator : (value){
                                                     if(value.isEmpty || !isNumeric(value)){
                                                       return 'Enter valid amount!';
                                                     }

                                                     this.setState(() {
                                                        temp = int.parse(value);
                                                     });
                                                     return null;
                                                   },
                                                 ),

                                               ],
                                            ),
                                          ),
                                      ),
                                      actions : <Widget>[
                                        FlatButton(
                                          onPressed: (){
                                            Navigator.pop(context);
                                          },
                                          child : Text('Cancel',style : TextStyle(color : Colors.black)),

                                          color : Colors.white,
                                        ),

                                        FlatButton(
                                          onPressed: (){
                                            if(expKey.currentState.validate()){
                                              print('Validated!');

                                              expenses n = expenses();
                                              n.name = sTemp;
                                              n.amount = temp;
                                              print(n.name);
                                              print(n.amount);
                                              b.list.add(n);
                                              updateContents();
                                              changeState();
                                              Navigator.pop(context);
                                              changeState();
                                            }
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20.0),
                                          ),
                                          child : Text('Create'),
                                          color : Colors.black,
                                        ),

                                      ],
                                  )
                             );
                        });
                      },
                      child : Row(
                        children: <Widget>[
                          Text(
                            'Add Expense ',
                             style : TextStyle(fontSize : 20.0,color : Colors.white),
                          ),
                          Icon(
                            Icons.add_circle,
                            color : Colors.white,
                          ),
                        ],
                      ),
                  ),
              ),
            ],
            crossAxisAlignment : CrossAxisAlignment.start,
        ),
    );
  }

  Color detColor(int x){
    if(x >= 0)
        return Colors.green;

     return Colors.red;
  }
}
