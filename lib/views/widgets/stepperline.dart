import 'package:flutter/material.dart';

class NumberedStepper extends StatelessWidget {
  final int currentStep;
  final List<String> stepTitles;
  const NumberedStepper({
    Key? key,
    required this.currentStep,
    required this.stepTitles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(stepTitles.length, (index) {
        return _buildStepItem(context,index);
      }),
    );
  }

  Widget _buildStepItem(BuildContext context,int index) {
    final isCurrent = index == currentStep;
    return Expanded(
      flex: isCurrent ? 4 : 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.linear,
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color:
                        isCurrent
                            ? const Color.fromARGB(255, 183, 191, 196)
                            : const Color.fromARGB(255, 233, 233, 233),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: Duration(milliseconds: 300),
                      style: TextStyle(
                        color: isCurrent ? Colors.black : Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: isCurrent ? 18 : 16,
                      ),
                      child: Text('${index + 1}'),
                    ),
                  ),
                ),
                isCurrent ? SizedBox(width: 10) : SizedBox(),
                isCurrent
                    ? Text(
                      stepTitles[index],
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color:Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        :  Color.fromARGB(255, 44, 62, 80),
                      ),
                    )
                    : Text(""),
              ],
            ),
            SizedBox(height: 5),
            AnimatedContainer(
              duration: Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              height: 7,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color:
                    isCurrent
                        ? Color.fromARGB(255, 44, 62, 80)
                        : const Color.fromARGB(255, 233, 233, 233),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
