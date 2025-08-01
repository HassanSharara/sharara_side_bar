## sharara_side_bar package
new sharara package for building side bar animated widgets with fast and nice animations

## install
```shell
flutter pub add sharara_side_bar
```


## example
```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sharara_side_bar/sharara_side_bar.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(
    const App()
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
      debugShowCheckedModeBanner:false,
      home:Directionality(textDirection: TextDirection.ltr, child: Launcher()),
    );
  }
}

class Launcher extends StatelessWidget {
  const Launcher({super.key});

  @override
  Widget build(BuildContext context) {
    return  FirstScreen(
      key:UniqueKey(),
    );
  }
}


class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  late final ShararaSideBarController controller;

   @override
  void initState() {
    controller = ShararaSideBarController(

        backgroundColor: Colors.blue
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Material(
      child: ShararaSideBarBuilder(controller: controller,
        sidebar:
        ListView(
          children: [
             SizedBox(
               height:200,
               child:Column(
                 mainAxisAlignment:MainAxisAlignment.center,
                 crossAxisAlignment:CrossAxisAlignment.center,
                 children: [
                   const Icon(Icons.person,
                   color:Colors.white,size:40,),
                   SizedBox(height:10,),
                   Text("Sharara App",style:TextStyle(
                     color:Colors.white,
                     fontWeight:FontWeight.bold,
                     fontSize:18
                   ),)
                 ],
               ),
             ),

            const SizedBox(height:20,),

            _element(Icons.person,"الحساب الشخصي"),
            _element(Icons.policy,"سياسة الخصوصية"),
            _element(Icons.gamepad,"العاب"),
            _element(Icons.info,"من نحن"),
            _element(Icons.shopping_cart,"المشتريات"),
            _element(Icons.history,"تاريخ التعاملات"),
            _element(Icons.logout,"تسحيل الخروج"),
          ],
        ),
        child:  Scaffold(
            appBar:AppBar(
              leading: IconButton(onPressed: controller.openDrawer, icon: const Icon(Icons.list)),
            ),
            body:const BasicScreen()),
      ),
    );
  }
  Widget _element( final IconData icon, final String title){
     return Padding(
       padding: const EdgeInsets.symmetric(vertical:21),
       child: Row(
         children: [
           Expanded(
             child: Row(
               children: [
                 Icon(icon,size:30,color:Colors.white,),
                 const SizedBox(width:8,),
                 Text(title,style:TextStyle(
                     fontSize:13,
                     fontWeight:FontWeight.bold,
                     color:Colors.white),)
               ],
             ),
           ),

           Icon(Icons.arrow_forward_ios,size:16,color:Colors.white,)
         ],
       ),
     );
  }
}

class BasicScreen extends StatelessWidget {
  const BasicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child:Text("hello world"),
      );
  }
}


```