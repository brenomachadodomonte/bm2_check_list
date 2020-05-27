import 'package:checklist/util/storage.dart';
import 'package:flutter/material.dart';

class CheckList extends StatefulWidget {
  @override
  _CheckListState createState() => _CheckListState();
}

class _CheckListState extends State<CheckList> {

  GlobalKey<ScaffoldState> _key = GlobalKey();
  var controllerItem = TextEditingController();

  GlobalKey<FormState> _formKeyAdd = GlobalKey<FormState>();

  List myList = [];
  Storage db = Storage();

  @override
  void initState() {
      super.initState();
      _loadDataList();
  }

  _loadDataList() {
    db.loadData().then((data) {
      setState(() {
        myList = data;
      });
    });
  }

  _saveDataList(){
    db.saveData(myList).then((_){
      _loadDataList();
    });
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width - 10;

    return Scaffold(
      key: _key,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 254, 226),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Check List', style: TextStyle(color: Colors.black54,),),
            Icon(Icons.check, color: Colors.black54,),
          ],
        ),
      ),
      backgroundColor: Color.fromARGB(255, 255, 254, 226),
      body: (myList.length == 0) ? _emptyList() : Container(
        padding: EdgeInsets.all(5),
        child: ListView.builder(
          itemCount: myList.length,
          itemBuilder: (context, index) {
            return _row(index, width);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white,),
        onPressed: (){
          _showDialogAddItem(context);
        },
      ),
    );
  }

  _emptyList() {
    return Container(
      child: Center(
        child: Text('You don\'t have items in your list')
      ),
    );
  }

  _row(int index, double width){
    return Dismissible(
      key: UniqueKey(),
      background: Container(color: Colors.grey),
      child: Container(
        decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color.fromARGB(255, 0, 147, 221), width: 1.2),
            )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              child: Text((index+1).toString()),
              width: width * 0.2,
              padding: EdgeInsets.all(16),
            ),
            Container(
              width: width * 0.6,
              decoration: BoxDecoration(
                  border: Border(
                      left: BorderSide(color: Color.fromARGB(255, 218, 37, 30))
                  )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(myList[index]['text'], style: TextStyle(decoration: myList[index]['checked'] ? TextDecoration.lineThrough : TextDecoration.none),)
                ],
              ),
              padding: EdgeInsets.all(16),
            ),
            Container(
              width: width * 0.2,
              child: Checkbox(
                value: myList[index]['checked'],
                onChanged: (value){
                  myList[index]['checked'] = value;
                  _saveDataList();
                },
              ),
            )
          ],
        ),
      ),
      onDismissed: (orientation){
        setState(() {
          Map deletedItem = myList.removeAt(index);
          _saveDataList();
          _key.currentState
            ..removeCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text("Item ${index+1} Deleted"),
                action: SnackBarAction(
                  label: "UNDO",
                  onPressed: (){
                    myList.insert(index, deletedItem);
                    _saveDataList();
                  } // this is what you needed
                ),
              ),
            );
        });
      },
    );
  }

  void _showDialogAddItem(BuildContext context){
    controllerItem.text = '';
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Add Item"),
          content: Container(
            child: Form(
              key: _formKeyAdd,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                      autofocus: true,
                      minLines: 2,
                      maxLines: 5,
                      controller: controllerItem,
                      decoration: InputDecoration(
                        labelText: 'Item',
                        labelStyle: TextStyle(color: Colors.grey[700]),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if(value.isEmpty){
                          return "Item is required!";
                        }
                        return null;
                      }
                  ),
                  Divider(),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: FlatButton(
                          child: Text(
                            "CLOSE",
                            style: TextStyle(color: Theme.of(context).primaryColor),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: FlatButton(
                          child: Text(
                            "ADD",style: TextStyle(color: Theme.of(context).primaryColor),
                          ),
                          onPressed: () {
                            if(_formKeyAdd.currentState.validate()){
                              Map item = {
                                'text': controllerItem.text,
                                'checked':false,
                              };
                              myList.add(item);
                              _saveDataList();
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}
