import 'package:flutter/material.dart';

class CheckList extends StatefulWidget {
  @override
  _CheckListState createState() => _CheckListState();
}

class _CheckListState extends State<CheckList> {

  List myList =  List.generate(20, (index){
    return {
      'text':'Create amazing apps in flutter',
      'checked':false,
      'decoration':TextDecoration.none};
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Container(
        color: Color.fromARGB(255, 255, 254, 226),
        padding: EdgeInsets.all(5),
        child: ListView(
          children: List.generate(20, (index){
            return Container(
              decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color.fromARGB(255, 0, 147, 221), width: 1.2),
                  )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Container(
                      child: Text(index.toString()),
                      width: 50,
                      padding: EdgeInsets.all(16),
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              left: BorderSide(color: Color.fromARGB(255, 218, 37, 30))
                          )
                      ),
                      child: Column(
                        children: <Widget>[
                          Text('Create amazing apps with flutter', style: TextStyle(decoration: myList[index]['decoration']),)
                        ],
                      ),
                      padding: EdgeInsets.all(16),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Checkbox(
                      activeColor: Colors.grey,
                      value: myList[index]['checked'],
                      onChanged: (value){
                        setState(() {
                          myList[index]['checked'] = value;
                          myList[index]['decoration'] = value ? TextDecoration.lineThrough : TextDecoration.none;
                        });
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

}
