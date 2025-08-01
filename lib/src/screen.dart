import 'package:flutter/material.dart';



final class ShararaSideBarController{
   ShararaSideBarController({
     this.backgroundColor,
    this.duration = const Duration(milliseconds:250),
    this.translationBegin,
    this.translationEnd,
    this.backgroundBoxDecoration,
  });
  final Color? backgroundColor;
  final BoxDecoration? backgroundBoxDecoration;
  final Duration duration;
  final Matrix4? translationBegin,translationEnd;
  AnimationController? animationController;

  openDrawer({final bool toggle = true}){
    if( ! toggle  || animationController?.isForwardOrCompleted == false ) {
      animationController?.forward();
      return;
    }
    animationController?.reverse();
  }

  closeDrawer()=> animationController?.reverse();


  dispose()=> animationController?.dispose();

}


class ShararaSideBarBuilder extends StatelessWidget {
  const ShararaSideBarBuilder({super.key,
   required this.sidebar,
   required this.child,
    required this.controller
  });
  final ShararaSideBarController controller;
  final Widget child,sidebar;

  @override
  Widget build(BuildContext context) {

    return  _BuilderShararaSideBarBuilder(size:MediaQuery.sizeOf(context),controller: controller,
      sidebar:sidebar,
      directionality:Directionality.of(context),
      child:child,
    );
  }
}



 class _BuilderShararaSideBarBuilder extends StatefulWidget {
   const _BuilderShararaSideBarBuilder({super.key,
     required this.size,
     required this.controller,
     required this.child,
     required this.sidebar,
     required this.directionality,
   });
   final Size size;
   final ShararaSideBarController controller;
   final Widget child,sidebar;
   final TextDirection directionality;
  @override
  State<_BuilderShararaSideBarBuilder> createState() => __BuilderShararaSideBarBuilderState();
}

class __BuilderShararaSideBarBuilderState extends State<_BuilderShararaSideBarBuilder> with SingleTickerProviderStateMixin {
   late final AnimationController animationController;
   late final Animation<double> animation;
   late final Animation matrix4Animation,sideBarMatrixAnimation;
   late final bool isRight ;


  @override
  void initState() {
     isRight = widget.directionality == TextDirection.rtl;
     animationController = AnimationController(vsync: this,duration:widget.controller.duration);
     widget.controller.animationController = animationController;
     animation = CurvedAnimation(parent: animationController, curve: Curves.linear);
     matrix4Animation = Matrix4Tween(
       begin:widget.controller.translationBegin ?? Matrix4.identity(),
       end:(
           widget.controller.translationEnd ??
               (isRight ?
               (Matrix4.translationValues(- calculateAvailableSpace,60, 0)
                 )
                   :Matrix4.translationValues(calculateAvailableSpace ,60,0))
       )
     ).animate(animation);
     sideBarMatrixAnimation = Matrix4Tween(
       begin: Matrix4.identity()
           ..setTranslationRaw(
               isRight ?
                  calculateAvailableSpace :
               - calculateAvailableSpace,
               widget.size.height/4, 0),
       end:Matrix4.identity()
     ).animate(animation);

    super.initState();
  }


  double get calculateAvailableSpace => widget.size.width * 0.7;


  _getFactor(final Offset p){
    final double factor =
        p.dx  / widget.size.width;
    if(isRight)return 1-factor;
    return factor;
  }

   @override
   Widget build(BuildContext context) {
     return GestureDetector(
       onHorizontalDragUpdate:(d){
         animationController.animateTo(
           _getFactor(d.globalPosition)
         );
       },
       onHorizontalDragEnd:(d){
         final double factor = _getFactor(d.globalPosition);
         if( factor > 0.5){ animationController.forward();return;}
         animationController.reverse();
       },
       child: Container(
         decoration:widget.controller.backgroundBoxDecoration??
          BoxDecoration(
            color:widget.controller.backgroundColor
          ),
         child: AnimatedBuilder(
             animation:animation,
             builder:(BuildContext context,a){
             return Stack(
               children: [

                 Transform(
                  transform:sideBarMatrixAnimation.value,
                 child: Row(
                   children: [
                     ConstrainedBox(
                       constraints:BoxConstraints(
                           maxWidth:calculateAvailableSpace - 10
                       ),
                       child:widget.sidebar,
                     )
                   ],
                 ))
                 ,
                 Transform(
                   transform:matrix4Animation.value,
                   child:GestureDetector(
                     onTap:animationController.value != 1 ? null :
                     (){
                       widget.controller.closeDrawer();
                     },
                     child: Container(
                         clipBehavior:Clip.hardEdge,
                       padding:EdgeInsets.all(60 * animationController.value),
                       decoration:BoxDecoration(
                           borderRadius:BorderRadius.circular(200 * animationController.value),
                           color:Theme.of(context).canvasColor
                       ),
                       child:widget.child,
                     ),
                   ),
                 )
               ],
             );
           }
         ),
       ),
     );
   }
}
