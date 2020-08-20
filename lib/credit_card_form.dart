import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

import 'credit_card_model.dart';
import 'credit_card_model.dart';
import 'credit_card_widget.dart';
import 'credit_card_widget.dart';
import 'credit_card_widget.dart';
import 'credit_card_widget.dart';

class CreditCardForm extends StatefulWidget {
  const CreditCardForm({
    Key key,
    this.cardNumber,
    this.expiryDate,
    this.cardHolderName,
    this.cvvCode,
    @required this.onCreditCardModelChange,
    this.themeColor,
    this.textColor = Colors.black,
    this.cursorColor,
  }) : super(key: key);

  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;
  final void Function(CreditCardModel) onCreditCardModelChange;
  final Color themeColor;
  final Color textColor;
  final Color cursorColor;

  @override
  _CreditCardFormState createState() => _CreditCardFormState();
}

class _CreditCardFormState extends State<CreditCardForm> {
  String cardNumber;
  String expiryDate;
  String cardHolderName;
  String cvvCode;
  bool isCvvFocused = false;
  Color themeColor;
  bool isAmex = false;
  FocusNode cardFocusNode = FocusNode();
  FocusNode expDateFocusNode = FocusNode();
  FocusNode cvvFocusNode = FocusNode();
  FocusNode cardNameFocusNode = FocusNode();

  void Function(CreditCardModel) onCreditCardModelChange;
  CreditCardModel creditCardModel;
  MaskedTextController _cardNumberController;
  /* MaskedTextController(mask: '0000 0000 0000 0000');*/
  final TextEditingController _expiryDateController =
      MaskedTextController(mask: '00/00');
  final TextEditingController _cardHolderNameController =
      TextEditingController();
  MaskedTextController _cvvCodeController;
  /*MaskedTextController(mask: '0000');*/

  void textFieldFocusDidChange() {
    creditCardModel.isCvvFocused = cvvFocusNode.hasFocus;
    onCreditCardModelChange(creditCardModel);
  }

  void createCreditCardModel() {
    cardNumber = widget.cardNumber ?? '';
    expiryDate = widget.expiryDate ?? '';
    cardHolderName = widget.cardHolderName ?? '';
    cvvCode = widget.cvvCode ?? '';

    creditCardModel = CreditCardModel(
        cardNumber, expiryDate, cardHolderName, cvvCode, isCvvFocused);
  }

  @override
  void initState() {
    super.initState();

    createCreditCardModel();

    _cardNumberController = MaskedTextController(mask: '0000 0000 0000 0000');
    _cvvCodeController = MaskedTextController(mask: '000');

    onCreditCardModelChange = widget.onCreditCardModelChange;

    cvvFocusNode.addListener(textFieldFocusDidChange);

    _cardNumberController.addListener(() {
      setState(() {
        cardNumber = _cardNumberController.text;
        creditCardModel.cardNumber = cardNumber;
        onCreditCardModelChange(creditCardModel);
        if (cardNumber.length > 2) {
          if (cardNumber.substring(0, 2) == '34' ||
              cardNumber.substring(0, 2) == '37') {
            _cardNumberController.updateMask('0000 000000 00000');
            isAmex = true;
          } else {
            _cardNumberController.updateMask('0000 0000 0000 0000');
            isAmex = false;
          }
        }
      });
    });

    _expiryDateController.addListener(() {
      setState(() {
        expiryDate = _expiryDateController.text;
        creditCardModel.expiryDate = expiryDate;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _cardHolderNameController.addListener(() {
      setState(() {
        cardHolderName = _cardHolderNameController.text;
        creditCardModel.cardHolderName = cardHolderName;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _cvvCodeController.addListener(() {
      setState(() {
        cvvCode = _cvvCodeController.text;
        creditCardModel.cvvCode = cvvCode;
        onCreditCardModelChange(creditCardModel);
        if (cardNumber.length > 2) {
          if (cardNumber.substring(0, 2) == '34' ||
              cardNumber.substring(0, 2) == '37') {
            _cvvCodeController.updateMask('0000');
          } else {
            _cvvCodeController.updateMask('000');
          }
        } else {
          _cvvCodeController.updateMask('000');
        }
      });
    });
  }

  @override
  void didChangeDependencies() {
    themeColor = widget.themeColor ?? Theme.of(context).primaryColor;
    super.didChangeDependencies();
  }

  void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: themeColor.withOpacity(0.8),
        primaryColorDark: themeColor,
      ),
      child: Form(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
              child: TextFormField(
                focusNode: cardFocusNode,
                onFieldSubmitted: (term) {
                  fieldFocusChange(context, cardFocusNode, expDateFocusNode);
                },
                controller: _cardNumberController,
                cursorColor: widget.cursorColor ?? themeColor,
                style: TextStyle(
                  color: widget.textColor,
                ),
                decoration: const InputDecoration(
                  labelText: 'Card number',
                  hintText: 'xxxx xxxx xxxx xxxx',
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(left: 16, right: 16),
              child: TextFormField(
                focusNode: expDateFocusNode,
                onFieldSubmitted: (term) {
                  fieldFocusChange(context, expDateFocusNode, cvvFocusNode);
                },
                controller: _expiryDateController,
                cursorColor: widget.cursorColor ?? themeColor,
                style: TextStyle(
                  color: widget.textColor,
                ),
                decoration: const InputDecoration(
                    labelText: 'Expired Date', hintText: 'MM/YY'),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(left: 16, right: 16),
              child: TextFormField(
                focusNode: cvvFocusNode,
                onFieldSubmitted: (term) {
                  fieldFocusChange(context, cvvFocusNode, cardNameFocusNode);
                },
                controller: _cvvCodeController,
                cursorColor: widget.cursorColor ?? themeColor,
                style: TextStyle(
                  color: widget.textColor,
                ),
                decoration: InputDecoration(
                  labelText: 'CVV',
                  hintText: isAmex ? 'XXXX' : 'XXX',
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onChanged: (String text) {
                  setState(() {
                    cvvCode = text;
                  });
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(left: 16, right: 16),
              child: TextFormField(
                focusNode: cardNameFocusNode,
                controller: _cardHolderNameController,
                cursorColor: widget.cursorColor ?? themeColor,
                style: TextStyle(
                  color: widget.textColor,
                ),
                decoration: const InputDecoration(
                  labelText: 'Card Holder',
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
