import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'edit.dart';
import 'package:flutter/services.dart';

void main(){


  runApp(MaterialApp(

    home : Home(),
  ));
}


bool change = false;
class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    //FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    return Scaffold(

      appBar: AppBar(

        title : Text('Your Budgets',style:TextStyle(color:Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        elevation: 0.0,
      ),

      body : SavedBudgets(stored: Storage()),

    );
  }
}

class SavedBudgets extends StatefulWidget{

  final Storage stored;

  SavedBudgets({Key key,@required this.stored}) : super(key : key);
  @override
  SavedBudgetsState createState() => SavedBudgetsState();
}

class SavedBudgetsState extends State<SavedBudgets>{


  List<String> files;

  @override
  void initState(){
    super.initState();
    widget.stored.getFiles.then((value){
      this.setState((){
        this.files = value;
        change = false;
      });
    });
  }

  void changeState(){
    widget.stored.getFiles.then((value){
      this.setState((){
        this.files = value;
        change = false;
      });
    });
  }


  Widget createCard(String val){

     Widget card = Container(
        alignment: Alignment.center,
        margin : EdgeInsets.symmetric(vertical:15.0,horizontal: 15.0),
        child : IntrinsicWidth(
          child : Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  //Icons here!
                  Container(
                    alignment: Alignment.center,
                    height : 40.0,
                    //color: Colors.red,
                    child : ButtonBar(
                      alignment: MainAxisAlignment.end,
                      children: <Widget>[
                        RaisedButton(
                            onPressed: (){
                                showDialog(context: context,
                                  builder: (BuildContext context){
                                      return (
                                          AlertDialog(
                                             title : Text('Delete budget ' + val + ' ?'),
                                             content : Text('This action is undoable',style : TextStyle(color : Colors.grey)),
                                             actions : <Widget>[
                                               FlatButton(
                                                 onPressed: (){
                                                   Navigator.pop(context);
                                                 },
                                                 child : Text('Cancel'),
                                               ),

                                               FlatButton(
                                                 onPressed: (){
                                                   deleteFile(val);
                                                   this.changeState();
                                                   Navigator.pop(context);
                                                 },
                                                 child : Text('Delete'),
                                                 color: Colors.red,
                                               ),

                                             ],
                                          )
                                      );
                                  }
                                );
                            },
                            elevation: 0.0,
                            color : Colors.grey[800],
                            child : Icon(
                              Icons.delete,
                              color : Colors.white,
                            ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Material(

                        color : Colors.grey[800],
                        child :
                        InkWell(
                          child :
                              Container(
                                  child : Text( val,style : TextStyle(fontSize: 25.0,color: Colors.white,),),
                                  alignment: Alignment.center,
                                  decoration : BoxDecoration(borderRadius: BorderRadius.circular(20.0),),
                                  height : 100,
                              ),
                          onTap: (){
                            print('Messi');
                            Navigator.push((context), MaterialPageRoute(builder: (context) => EditScreen(val)));
                          },
                        ),
                  ),
                ],
              ),
            ],
        ),
        ),
        decoration : BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.grey[800],),
    );

     return card;
  }

  /*Text(val,style : TextStyle(fontSize: 25.0)),
        decoration : BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.grey,
        ),*/

  dynamic populate(){

    print('Populating');

    print(change);


    print(files);
    if(files.isNotEmpty) {
      return (
         files.map((val)=> createCard(val)).toList()
      );
    }

    return <Widget>[

    ];
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        backgroundColor: Colors.white,
        body : GridView.count(

          crossAxisCount: 2,
          children: populate(),

        ),
        floatingActionButton: SpeedDial(
            child : Icon(Icons.add),
            backgroundColor: Colors.black,
            animatedIcon: AnimatedIcons.menu_close,
            children: [
               SpeedDialChild(
                 label : 'Refresh',
                 labelStyle: TextStyle(fontSize: 15.0),
                 backgroundColor: Colors.black,
                 onTap: () { changeState(); },
                 child : Icon(Icons.refresh),
               ),
               SpeedDialChild(
                 backgroundColor: Colors.black,
                 label : 'New Budget',
                 labelStyle: TextStyle(fontSize: 15.0),
                 child : Icon(Icons.add),
                 onTap : (){
                   Navigator.push(
                       context,
                       MaterialPageRoute(builder: (context) => SecScreen(this)));
                 },
               )
            ],
        ),
    );
  }
}


class SecScreen extends StatefulWidget {

  SavedBudgetsState parent;
  SecScreen(this.parent);
  @override
  _SecScreenState createState() => _SecScreenState();


}

class _SecScreenState extends State<SecScreen>{

    String budgetName;
    final formKey = GlobalKey<FormState> ();


    @override
    Widget build(BuildContext context){

      return Scaffold(
        appBar: AppBar(
          title : Text('Create New Budget',style : TextStyle(color : Colors.white)),
          backgroundColor: Colors.black,
          elevation: 0.0,
          brightness: Brightness.dark,
        ),
        body : Container(
            child : Form(
              key : formKey,
              child : Column(
                  children : <Widget> [
                        TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Enter Budget Name ',
                          labelStyle: TextStyle(color : Colors.black),
                        ),
                        validator: (value){
                          if(value.isEmpty){
                            return 'Enter a name!';
                          }
                          else if(value.length > 10){
                            return 'Length cannot exceed 10 chars!';
                          }

                          this.setState(() {
                              this.budgetName = value;
                            }
                          );

                          return null;
                        },
                      ),

                      RaisedButton(
                          color: Colors.black,
                          onPressed: () {
                                if(formKey.currentState.validate()){

                                    final temp = Storage();
                                    temp.CreateNewBudget(this.budgetName,widget.parent);
                                    change = true;


                                    Navigator.pop(context);
                                }
                          },
                          child : Row(
                            mainAxisSize: MainAxisSize.min,
                            children : <Widget>[
                                  Text('Create   ',style : TextStyle(color: Colors.white,fontSize: 15.0)),
                                  Icon(Icons.create,color: Colors.white,size: 15,),
                            ],
                          ),
                          shape : RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28.0),
                          ),
                      )
                  ],
              ),
            ),
        ),
      );
    }
}

SnackBar createdBar(){

  return SnackBar(
    content : Text('Processing'),
    action : SnackBarAction(
        label : 'Undo',
        textColor: Colors.red[300],
        onPressed: () {

        },
    ),
  );
}

class Storage {

      Future<String> get localPath async {
        final directory = await getApplicationDocumentsDirectory();

        print(directory);

        Directory dir = await  Directory('${directory.path}/devData').create();

        print(dir);
        return dir.path;
      }

      Future<String> get Path async{
        final directory = await getApplicationDocumentsDirectory();

        return ('${directory.path}/devData/');
      }
      Future<File> CreateNewBudget(String title,SavedBudgetsState parent) async {
        final location = await localPath;
        File MyFile = await File('$location/$title').create();
        String init = 'Money : 0';
        MyFile.writeAsString(init);
        parent.changeState();

        return MyFile;
      }

      Future<List<String>> get getFiles async {
        Directory location = Directory(await localPath);
        List contents = location.listSync();

        print(contents);
        var files = <String>[];
        for (var x in contents) {
          if (x is File) {
            int index = x.path.lastIndexOf('/');
            files.add(x.path.substring(index + 1));
          }
        }


        return files;
      }

}

Future<String> deleteFile (String filename) async{
  final s = Storage();
  final dir = Directory(await s.Path);

  var contents = dir.listSync();

  for(var f in contents){
    if(f is File){
      int index = f.path.lastIndexOf('/');
      if(f.path.substring(index + 1) == filename){
        f.delete();
        print('Deleted! ${f.path}');
      }
    }
  }

  return '';
}
