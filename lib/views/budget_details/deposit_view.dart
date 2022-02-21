import 'package:cedi_budget_update/models/budget.dart';
import 'package:cedi_budget_update/services/auth_service.dart';
import 'package:cedi_budget_update/services/database_service.dart';
import 'package:cedi_budget_update/views/budget_details/budget_details_view.dart';
import 'package:cedi_budget_update/widgets/rounded_button.dart';
import 'package:cedi_budget_update/widgets/snackbar_and_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class DepositView extends StatefulWidget {
  final Budget budget;

  const DepositView({Key? key, required this.budget}) : super(key: key);
  @override
  _DepositViewState createState() => _DepositViewState();
}

class _DepositViewState extends State<DepositView> {
  String _amount = '0';
  String _error = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Amount'),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  'GH¢$_amount',
                  style: const TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  _error,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.4,
                  children: setKeyboard(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _actionBtn('spent'),
                    _actionBtn('saved'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _numberBtn(String number) {
    return TextButton(
      child: Text(
        number,
        style: TextStyle(
          fontSize: 40,
          color: Theme.of(context).textTheme.bodyText2!.color,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () {
        setState(() {
          if (_amount == '0') {
            _amount = number;
          } else if (_amount.length == 7) {
            _amount = _amount;
            HapticFeedback.heavyImpact();
          } else {
            _amount += number;
          }
        });
      },
    );
  }

  Widget _negativeBtn() {
    return TextButton(
      child: Text(
        '-',
        style: TextStyle(
          fontSize: 40,
          color: Theme.of(context).textTheme.bodyText2!.color,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () {
        setState(() {
          if (_amount == '0') {
            _amount = '-';
          } else if (_amount.length == 7) {
            _amount = _amount;
            HapticFeedback.heavyImpact();
          } else {
            _amount = '-' + _amount;
          }
        });
      },
    );
  }

  Widget _decimalBtn() {
    return TextButton(
      child: Text(
        '.',
        style: TextStyle(
          fontSize: 40,
          color: Theme.of(context).textTheme.bodyText2!.color,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () {
        setState(() {
          if (_amount == '0') {
            _amount += '.';
          } else if (_amount.length == 7) {
            _amount = _amount;
            HapticFeedback.heavyImpact();
          } else {
            _amount += '.';
          }
        });
      },
    );
  }

  Widget _deleteBtn() {
    return TextButton(
      child: Icon(
        Icons.backspace_rounded,
        color: Theme.of(context).textTheme.bodyText2!.color,
      ),
      onPressed: () {
        setState(() {
          if (_amount.length <= 1) {
            _amount = '0';
          } else {
            _amount = _amount.substring(0, _amount.length - 1);
          }
        });
      },
      onLongPress: () {
        HapticFeedback.heavyImpact();
        setState(() {
          _amount = '0';
          _error = '';
        });
      },
    );
  }

  Widget _actionBtn(String type) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: RoundedButton(
          color: Theme.of(context).colorScheme.secondary,
          child: Text(
            type[0].toUpperCase() + type.substring(1),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            actionPressed(type);
          },
        ),
      ),
    );
  }

  Future<void> actionPressed(String type) async {
    if (_amount == '0') {
      setState(() {
        _error = 'Enter an amount';
      });
    } else if (type == 'spent' &&
        double.parse(_amount) >
            (widget.budget.amount -
                (widget.budget.amountUsed + widget.budget.amountSaved))) {
      setState(() {
        _error =
            "Goes over budget allocation GH¢${widget.budget.amount.toStringAsFixed(2)}\nAvailable: GH¢${(widget.budget.amount - (widget.budget.amountUsed + widget.budget.amountSaved)).toStringAsFixed(2)}";
      });
    } else if (type != 'spent' &&
        double.parse(_amount) >
            (widget.budget.amount -
                (widget.budget.amountUsed + widget.budget.amountSaved))) {
      setState(() {
        _error =
            "Insufficient funds\nAvailable: GH¢${(widget.budget.amount - widget.budget.amountUsed - widget.budget.amountSaved).toStringAsFixed(2)}";
      });
    } else if (type == 'spent' &&
        (widget.budget.amountUsed + double.parse(_amount)) < 0) {
      setState(() {
        _error =
            "Amount sums to less than 0\nSpent: GH¢${widget.budget.amountUsed.toStringAsFixed(2)}";
      });
    } else if (type == 'saved' &&
        (widget.budget.amountSaved + double.parse(_amount)) < 0) {
      setState(() {
        _error =
            "Amount sums to less than 0\nSaved: GH¢${widget.budget.amountSaved.toStringAsFixed(2)}";
      });
    } else {
      String uid = context.read<AuthService>().getCurrentUser().uid;
      setState(() {
        _error = '';
        widget.budget.updateLedger(_amount, type);
      });
      showLoadingDialog(context);

      await context.read<DatabaseService>().addToLedger(uid, widget.budget);
      await context
          .read<DatabaseService>()
          .updateAmountSaved(uid, widget.budget);
      await context
          .read<DatabaseService>()
          .updateAmountUsed(uid, widget.budget);
      hideLoadingDialog(context);
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) =>
              BudgetDetailsView(budget: widget.budget),
          transitionDuration: const Duration(seconds: 0),
        ),
      );
    }
  }

  List<Widget> setKeyboard() {
    List<Widget> keyboard = [];

    // 1 - 9
    List.generate(9, (index) {
      keyboard.add(_numberBtn('${index + 1}'));
    });

    keyboard.add(_decimalBtn());
    keyboard.add(_numberBtn('0'));
    keyboard.add(_deleteBtn());
    keyboard.add(_numberBtn(''));
    keyboard.add(_negativeBtn());

    return keyboard;
  }
}
