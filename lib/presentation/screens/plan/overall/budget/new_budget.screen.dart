import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:provider/provider.dart';
import 'package:saving_app/data/models/category.model.dart';
// import 'package:saving_app/data/local/model_repos/records/category_repository.dart';
// import 'package:saving_app/data/local/model_repos/plan_transact/plan_transact_repo.dart';
// import 'package:saving_app/data/local/model_repos/records/transact_repo.dart';
import 'package:saving_app/domain/providers/category_provider.dart';
// import 'package:saving_app/data/local/model_repos/budget/budget_json_repo.dart';
// import 'package:saving_app/presentation/managers/category_manager.dart';
import 'package:saving_app/presentation/managers/plan_manager.dart';
import 'package:saving_app/presentation/screens/shared_widgets/category_picker.dart';
import 'package:saving_app/presentation/screens/style/styles.dart';

class NewBudgetScreen extends StatefulWidget {
  const NewBudgetScreen({super.key});

  @override
  State<NewBudgetScreen> createState() => _NewBudgetScreenState();
}

class _NewBudgetScreenState extends State<NewBudgetScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};
  late PlanController manager;
  int recommendAmount = 0;
  final TextEditingController _controller = TextEditingController();

  void _onSubmit() {
    _formKey.currentState!.save();
    if(_formKey.currentState!.validate()){
      final newBudget = Budget(
        amount: _formData["amount"],
        categoryId: (_formData["category"] as CustomCategory).id,
        period: _formData["period"],
      );
      // context.read<CategoryController>().putBudget(newBudget);
      context.read<CategoryProvider>().putBudget(newBudget);
      Navigator.of(context).pop();
    }
  }

  double _getRecAmount(String? id){
    if(id != null) {
      return manager.getRecommend(id);
    }
    return 0.0;
  }

  @override
  void initState() {
    _formData["period"] = BudgetPeriod.monthly;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      manager = context.read<PlanController>();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.black,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          "Ngân quỹ mới", 
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          Card(
            margin: const EdgeInsets.all(8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            color: Colors.blueAccent.shade400,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
              child: Row(
                children: [
                  const Expanded(
                    child: Icon(Boxicons.bx_bulb, color: Colors.white,),
                  ),
                  Expanded(
                    flex: 7,
                    child: Wrap(
                      children: [
                        recommendAmount > 0 
                        ? Text(
                          "Cho mục ${(_formData["category"] as CustomCategory).name}, bạn nên đặt quỹ với số tiền $recommendAmount VND",
                          style: const TextStyle(color: Colors.white),
                        )
                        : const Text(
                          "Hãy thêm thông tin về thu nhập để ứng dụng có thể gợi ý ngân quỹ cho bạn",
                          style: TextStyle(color: Colors.white),
                        ),
                      ]
                    ),
                  )
                ]
              ),
            )
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CategoryPicker(
                    allowGroup: true,
                    transactionType: TransactionType.expense, 
                    onCategoryChanged: (value) {
                      setState(() {
                        _formData["category"] = value;
                        recommendAmount = _getRecAmount(value.id).toInt();
                        _formData["amount"] = recommendAmount;
                        _controller.text = "$recommendAmount";
                      });
                    },
                  ),
                  inputLabelWithPadding("Số tiền"),
                  TextFormField(
                    controller: _controller,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: addRecordFormFieldStyle(
                      icon: const Icon(CupertinoIcons.money_dollar),
                      suffix: const Text("VND")
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if(value == null || value.isEmpty) {
                        return "Please input amount";
                      }
                      try {
                        int parsedAmount = int.parse(value);
                        if (parsedAmount < 0) {
                          return "Amount should be positive";
                        }
                        _formData["amount"] = parsedAmount;
                      } catch(e) {
                        return "Amount should be integer";
                      }
                      return null;
                    },
                  ),
                  inputLabelWithPadding("Loại kỳ hạn"),
                  DropdownMenu(
                    initialSelection: _formData["period"] as BudgetPeriod,
                    dropdownMenuEntries: const [
                      DropdownMenuEntry(value: BudgetPeriod.weekly, label: "Theo tuần"),
                      DropdownMenuEntry(value: BudgetPeriod.monthly, label: "Theo tháng"),
                      DropdownMenuEntry(value: BudgetPeriod.yearly, label: "Theo năm"),
                    ],
                    onSelected: (value) {
                      _formData["period"] = value;
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      onPressed: _onSubmit, 
                      child: const Text("Xác nhận"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]
      ),
    );
  }
}