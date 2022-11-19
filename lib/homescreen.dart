
import 'package:flutter/material.dart';
import 'package:rest_api/users_pet_model.dart';
import 'package:http/http.dart' as http;


class RestApi extends StatefulWidget {
  const RestApi({Key? key}) : super(key: key);

  @override
  _RestApiState createState() => _RestApiState();
}

class _RestApiState extends State<RestApi> {
  // to hold the dat
  late UsersPet usersPet;

  // to check if data is loaded flag

  bool isLoaded = false;

  // to check for errorMsg

  String errorMsg = "";

  //API CALL

  Future<UsersPet> getDataFromApi() async{
    Uri url = Uri.parse('https://jatinderji.github.io/users_pets_api/users_pets.json');
    var response = await http.get(url);
    if(response.statusCode == 200){
      UsersPet usersPet = usersPetFromJson(response.body);
      return usersPet;
    }else{
      errorMsg = '${response.body} : ${response.body}';
      return UsersPet(data: []);
    }
  }

  assignedData() async{
    usersPet = await getDataFromApi();
    setState(() {
      isLoaded = true;
    });
  }

  @override
  void initState() {
    // call method
    assignedData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rest Api Call'),
        centerTitle: true,
      ),
      body: ! isLoaded ? const Center(child: CircularProgressIndicator(),):
          errorMsg.isNotEmpty?  Center(child: Text(errorMsg),):
              usersPet.data.isEmpty? const Center(child: Text('No data'),):
                  ListView.builder(
                      itemCount: usersPet.data.length,
                      itemBuilder: (context, index)=> getMyRow(index))
    );
  }

  Widget getMyRow(int index) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          radius: 21,
          backgroundImage: NetworkImage(usersPet.data[index].petImage),
          backgroundColor: usersPet.data[index].isFriendly ? Colors.green : Colors.red,
          child: CircleAvatar(
            radius: 20,
            backgroundColor: usersPet.data[index].isFriendly? Colors.green: Colors.red ,
            backgroundImage: NetworkImage(usersPet.data[index].petImage),
          ),
        ),
        trailing: Icon(usersPet.data[index].isFriendly ? Icons.pets : Icons.do_not_touch,
                  color: usersPet.data[index].isFriendly ? Colors.green : Colors.red,

      ),
        title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Text(usersPet.data[index].userName, style: TextStyle(fontWeight: FontWeight.bold, ),),
          Text('Dog: ${usersPet.data[index].petName}'),

        ],
      ),
      ),
    );
  }
}
