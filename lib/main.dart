import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
		return Material(
      child: Center(
        child: TriggerSwitch(
          height: 50,
          width: 120,
          blurRadius: 6.0,
          value: false,
          onChanged: (bool value){
            print(value);
          },
        ),
      ),
    );
  }
}

@immutable
class TriggerSwitch extends StatefulWidget {
  /// Criar um botão interruptor que retornará true ou false através
  /// da função `onChange` quando clicado
  ///Exemplo de uso:
  /// ```
  /// TriggerSwitch(
  ///   blurRadius: 6.0,
  ///   value: false,
  ///   onChanged: (bool value){
  ///     print(value);
  ///   },
  /// ),
  /// ```
  final double height;
  final double width;
  final Color checkedColor;
  final Color unCheckedColor;
  final Color circleColor;
  final double blurRadius;
  final Offset offset;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Curve curve;
  final Curve reverseCurve;
  final int transitionTime;
  const TriggerSwitch({
    Key key,
    this.height = 18.0,
    this.width = 38.0,
    this.checkedColor = Colors.green,
    this.unCheckedColor = Colors.red,
    this.circleColor = Colors.white,
    this.blurRadius = 0.0,
    this.offset = const Offset(0.0, 0.0),
    @required this.value,
    @required this.onChanged,
    this.curve = Curves.bounceIn,
    this.reverseCurve = Curves.bounceInOut,
    this.transitionTime = 450,
  }): assert(value != null, 'Insira o valor inicial'),
      assert(onChanged != null, 'Insira a função "onChanged"'),
      super(key: key);
  
  @override
  _TriggerSwitchState createState() => _TriggerSwitchState();
}

class _TriggerSwitchState extends State<TriggerSwitch> with SingleTickerProviderStateMixin{

  Animation<Alignment> animation;
  AnimationController animationController;

  @override
  void initState() {

    animationController = AnimationController(
      vsync: this, 
      duration: Duration(
        milliseconds: widget.transitionTime
      )
    );
    
    animation = Tween<Alignment>(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).animate(CurvedAnimation(
      parent: animationController, 
      curve: widget.curve, 
      reverseCurve: widget.reverseCurve
      )
    );

    if(!widget.value){
      animationController.reverse();
    }else{
      animationController.forward();
    }
    
    super.initState();
  }
  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(animationController.isCompleted){
          animationController.reverse();
          widget.onChanged(false);
        }else{
          animationController.forward();
          widget.onChanged(true);
        }
      },
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return Container(
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
              color: animationController.isCompleted ? widget.checkedColor : widget.unCheckedColor,
              borderRadius: BorderRadius.circular(widget.height/2),
              boxShadow: [
                BoxShadow(
                  color: animationController.isCompleted ? widget.checkedColor : widget.unCheckedColor,
                  blurRadius: widget.blurRadius,
                  offset: widget.offset,
                )
              ],
            ),
            child: Align(
              alignment: animation.value,
              child: Container(
                height: widget.height-4,
                width: widget.height-4,
                alignment: Alignment.center,
                margin: const EdgeInsets.all(2.5),
                decoration: BoxDecoration(
                  color: widget.circleColor,
                  shape: BoxShape.circle,
                ),
                child: Container(
                  height: widget.height-(widget.height*0.65),
                  width: animationController.isCompleted
                    ? widget.height-(widget.height*0.65)
                    : widget.height-(widget.height*0.85),
                  decoration: BoxDecoration(
                    color: animationController.isCompleted ? widget.checkedColor : widget.unCheckedColor,
                    borderRadius: BorderRadius.circular(widget.height),
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}


