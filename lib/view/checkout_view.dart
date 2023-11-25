import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodies_haven/res/components/checkout_row_session.dart';
import 'package:foodies_haven/utils/utils.dart';
import 'package:foodies_haven/viewModel/ordering_controller.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class CheckoutView extends StatefulWidget {
  final String imageUrl;
  final String name;
  final int count;
  final String amount;
  final String timeTake;
  final String id;
  const CheckoutView({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.count,
    required this.amount,
    required this.id,
    required this.timeTake,
  });

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  var _currentStep = 0;
  final _tableController = TextEditingController();
  final orderController = Get.put(OrderingController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    int amountValue = int.tryParse(widget.amount) ?? 0;

    // Determine the value to display based on the condition
    int displayValue =
        (widget.count == 1) ? amountValue : widget.count * amountValue;
    List<Step> getSteps() => [
          Step(
            isActive: _currentStep >= 0,
            title: Text(
              'Enter your table number',
              style: theme.textTheme.titleLarge!.copyWith(
                color: theme.colorScheme.onBackground,
              ),
            ),
            content: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: Get.height * .3,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/table.png',
                        ),
                      ),
                    ),
                    child: SizedBox(
                      height: Get.height * .1,
                      width: Get.width * .25,
                      child: TextFormField(
                        controller: _tableController,
                        style: theme.textTheme.titleLarge!.copyWith(
                          color: theme.colorScheme.onPrimary,
                        ),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        validator: (value) {
                          if (value!.isEmpty) {
                            Utils().showSnackBar('Error', 'Enter table number');
                            return '';
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(2),
                          hintText: '1',
                          hintStyle: theme.textTheme.titleLarge!.copyWith(
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Step(
            isActive: _currentStep >= 1,
            title: Text(
              'Order details',
              style: theme.textTheme.titleLarge!.copyWith(
                color: theme.colorScheme.onBackground,
              ),
            ),
            content: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      width: double.infinity,
                      height: Get.height * .3,
                      imageUrl: widget.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.black.withOpacity(0.2),
                        highlightColor: Colors.white54,
                        enabled: true,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  const Gap(20),
                  CheckoutRowSession(
                    name: widget.name,
                    title: 'Name:',
                  ),
                  const Divider(),
                  CheckoutRowSession(
                    name: widget.count.toString(),
                    title: 'Count:',
                  ),
                  const Divider(),
                  CheckoutRowSession(
                    name: _tableController.text.isEmpty
                        ? 'Enter table no:'
                        : _tableController.text,
                    title: 'Table:',
                  ),
                  const Divider(),
                  const Gap(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total:',
                        style: theme.textTheme.bodyLarge!.copyWith(
                          color: theme.colorScheme.onBackground,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '₹$displayValue',
                        style: theme.textTheme.bodyLarge!.copyWith(
                            color: theme.colorScheme.onBackground,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      )
                    ],
                  ),
                  const Gap(20),
                ],
              ),
            ),
          ),
        ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Stepper(
                currentStep: _currentStep,
                onStepContinue: () async {
                  final isLastStep = _currentStep == getSteps().length - 1;

                  if (isLastStep) {
                    orderController.showConfirmDailog(
                      id: widget.id,
                      name: widget.name,
                      url: widget.imageUrl,
                      date: DateTime.timestamp().toString(),
                      count: widget.count.toString(),
                      timeTake: widget.timeTake,
                      tableNo: _tableController.text,
                      total: displayValue.toString(),
                      theme: theme,
                      context: context,
                    );
                  } else {
                    setState(() {
                      if (_formKey.currentState!.validate()) {
                        _currentStep += 1;
                      }
                    });
                  }
                },
                controlsBuilder: (context, details) {
                  final isLastStep = _currentStep == getSteps().length - 1;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: details.onStepContinue,
                        child: Text(isLastStep ? 'Order' : 'Next'),
                      ),
                      if (_currentStep != 0)
                        ElevatedButton(
                          onPressed: details.onStepCancel,
                          child: const Text('Back'),
                        ),
                    ],
                  );
                },
                onStepCancel: () {
                  if (_currentStep != 0) {
                    setState(() {
                      _currentStep -= 1;
                    });
                  }
                },
                onStepTapped: (step) => setState(() {
                  _currentStep = step;
                }),
                steps: getSteps(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
