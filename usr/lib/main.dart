import 'package:flutter/material.dart';

void main() {
  runApp(const DogMealsApp());
}

// ==========================================
// STATE MANAGEMENT
// ==========================================

class AppState extends ChangeNotifier {
  // --- Prices (Per KG Raw) ---
  double mincedMeatPrice = 0.0;
  double chickenBreastPrice = 0.0;
  double liverPrice = 0.0;
  double potatoPrice = 0.0;

  // --- Packaging & Operations ---
  double bagPrice = 0.0;
  double craftBagPrice = 0.0;
  double packingSackPrice = 0.0;
  double stickerPrice = 0.0;
  double transportCost = 0.0;

  // --- CRM ---
  List<Customer> customers = [];

  void updatePrices({
    double? minced,
    double? chicken,
    double? liver,
    double? potato,
    double? bag,
    double? craft,
    double? sack,
    double? sticker,
    double? transport,
  }) {
    if (minced != null) mincedMeatPrice = minced;
    if (chicken != null) chickenBreastPrice = chicken;
    if (liver != null) liverPrice = liver;
    if (potato != null) potatoPrice = potato;
    if (bag != null) bagPrice = bag;
    if (craft != null) craftBagPrice = craft;
    if (sack != null) packingSackPrice = sack;
    if (sticker != null) stickerPrice = sticker;
    if (transport != null) transportCost = transport;
    notifyListeners();
  }

  void addCustomer(Customer c) {
    customers.add(c);
    notifyListeners();
  }
}

final appState = AppState();

class Customer {
  final String id;
  final String name;
  final String mealType;
  final DateTime lastOrderDate;
  final int cycleDays;

  Customer({
    required this.id,
    required this.name,
    required this.mealType,
    required this.lastOrderDate,
    required this.cycleDays,
  });

  bool get isDue {
    final nextOrderDate = lastOrderDate.add(Duration(days: cycleDays));
    return DateTime.now().isAfter(nextOrderDate) || DateTime.now().isAtSameMomentAs(nextOrderDate);
  }
  
  DateTime get nextOrderDate => lastOrderDate.add(Duration(days: cycleDays));
}

// ==========================================
// APP WIDGET
// ==========================================

class DogMealsApp extends StatelessWidget {
  const DogMealsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'إدارة وجبات الكلاب',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
        fontFamily: 'Roboto', // Fallback, standard works for Arabic
      ),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      initialRoute: '/',
      routes: {
        '/': (context) => const MainNavigationScreen(),
      },
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const CalculatorScreen(),
    const PricesScreen(),
    const CrmScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'الرئيسية'),
          NavigationDestination(icon: Icon(Icons.calculate), label: 'الحسابات'),
          NavigationDestination(icon: Icon(Icons.price_change), label: 'الأسعار'),
          NavigationDestination(icon: Icon(Icons.people), label: 'العملاء'),
        ],
      ),
    );
  }
}

// ==========================================
// SCREENS
// ==========================================

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('نظام الإدارة المالي - وجبات الكلاب')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.pets, size: 80, color: Colors.teal),
              const SizedBox(height: 24),
              const Text(
                'مرحباً بك في نظام الإدارة',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'يرجى البدء بتحديث أسعار الخامات من شاشة "الأسعار"،\nثم يمكنك استخدام حاسبة التكلفة أو إدارة عملائك.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PricesScreen extends StatefulWidget {
  const PricesScreen({super.key});

  @override
  State<PricesScreen> createState() => _PricesScreenState();
}

class _PricesScreenState extends State<PricesScreen> {
  final _mincedController = TextEditingController();
  final _chickenController = TextEditingController();
  final _liverController = TextEditingController();
  final _potatoController = TextEditingController();
  final _bagController = TextEditingController();
  final _craftController = TextEditingController();
  final _sackController = TextEditingController();
  final _stickerController = TextEditingController();
  final _transportController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mincedController.text = appState.mincedMeatPrice.toString();
    _chickenController.text = appState.chickenBreastPrice.toString();
    _liverController.text = appState.liverPrice.toString();
    _potatoController.text = appState.potatoPrice.toString();
    _bagController.text = appState.bagPrice.toString();
    _craftController.text = appState.craftBagPrice.toString();
    _sackController.text = appState.packingSackPrice.toString();
    _stickerController.text = appState.stickerPrice.toString();
    _transportController.text = appState.transportCost.toString();
  }

  void _savePrices() {
    appState.updatePrices(
      minced: double.tryParse(_mincedController.text),
      chicken: double.tryParse(_chickenController.text),
      liver: double.tryParse(_liverController.text),
      potato: double.tryParse(_potatoController.text),
      bag: double.tryParse(_bagController.text),
      craft: double.tryParse(_craftController.text),
      sack: double.tryParse(_sackController.text),
      sticker: double.tryParse(_stickerController.text),
      transport: double.tryParse(_transportController.text),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم تحديث الأسعار بنجاح!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('أسعار الخامات والتشغيل')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text('أسعار الخامات (للكيلو الخام):', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildTextField('اللحم المفروم', _mincedController),
          _buildTextField('صدور الفراخ', _chickenController),
          _buildTextField('الكبدة', _liverController),
          _buildTextField('البطاطس', _potatoController),
          const Divider(height: 32),
          const Text('التغليف والتشغيل:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildTextField('الشنطة العادية', _bagController),
          _buildTextField('الشنطة الكرافت', _craftController),
          _buildTextField('كيس التعبئة', _sackController),
          _buildTextField('الاستيكر', _stickerController),
          _buildTextField('النقل (حق المشوار)', _transportController),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _savePrices,
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
            child: const Text('حفظ الأسعار', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _selectedMeal = 'مفروم';
  final _weightController = TextEditingController(text: '1.0');
  
  // Delivery Calc
  final _collectedController = TextEditingController();
  final _paidToDriverController = TextEditingController();

  double _calculateMealCost(double weightKg) {
    double meatCost = 0.0;
    double potatoCost = 0.0;

    // Cooking Shrinkage Cost Adjustments
    // Chicken: 1kg raw = 0.8kg cooked -> cost per cooked kg = raw price / 0.8
    double cookedChickenPrice = appState.chickenBreastPrice / 0.8;
    // Liver: 1kg raw = 0.6kg cooked -> cost per cooked kg = raw price / 0.6
    double cookedLiverPrice = appState.liverPrice / 0.6;
    // Minced & Potato assumed 100% yield
    double cookedMincedPrice = appState.mincedMeatPrice;
    double cookedPotatoPrice = appState.potatoPrice;

    if (_selectedMeal == 'مفروم') {
      meatCost = (cookedMincedPrice * 0.5) * weightKg;
      potatoCost = (cookedPotatoPrice * 0.5) * weightKg;
    } else if (_selectedMeal == 'فراخ') {
      meatCost = (cookedChickenPrice * 0.2) * weightKg;
      potatoCost = (cookedPotatoPrice * 0.8) * weightKg;
    } else if (_selectedMeal == 'كبدة') {
      meatCost = (cookedLiverPrice * 0.2) * weightKg;
      potatoCost = (cookedPotatoPrice * 0.8) * weightKg;
    }

    return meatCost + potatoCost;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('حاسبة التكلفة')),
      body: ListenableBuilder(
        listenable: appState,
        builder: (context, _) {
          double weight = double.tryParse(_weightController.text) ?? 1.0;
          double mealCost = _calculateMealCost(weight);
          double packagingCost = appState.bagPrice + appState.craftBagPrice + appState.packingSackPrice + appState.stickerPrice;
          double totalCost = mealCost + packagingCost + appState.transportCost;

          double collected = double.tryParse(_collectedController.text) ?? 0.0;
          double paidToDriver = double.tryParse(_paidToDriverController.text) ?? 0.0;
          double deliveryLoss = paidToDriver - collected;
          if (deliveryLoss < 0) deliveryLoss = 0; // If collected more than paid, it's not a loss.

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('حساب تكلفة الوجبة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedMeal,
                        decoration: const InputDecoration(labelText: 'نوع الوجبة', border: OutlineInputBorder()),
                        items: ['مفروم', 'فراخ', 'كبدة'].map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                        onChanged: (val) => setState(() => _selectedMeal = val!),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _weightController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'وزن الوجبة (كجم)', border: OutlineInputBorder()),
                        onChanged: (val) => setState(() {}),
                      ),
                      const Divider(height: 32),
                      Text('تكلفة الخامات (بعد الفقد): \$${mealCost.toStringAsFixed(2)}'),
                      Text('تكلفة التغليف: \$${packagingCost.toStringAsFixed(2)}'),
                      Text('تكلفة النقل: \$${appState.transportCost.toStringAsFixed(2)}'),
                      const SizedBox(height: 8),
                      Text('التكلفة الإجمالية: \$${totalCost.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('حساب خسائر الدليفري', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _collectedController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'المبلغ المحصل من العميل للدليفري', border: OutlineInputBorder()),
                        onChanged: (val) => setState(() {}),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _paidToDriverController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'المبلغ المدفوع للطيار', border: OutlineInputBorder()),
                        onChanged: (val) => setState(() {}),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'الخسارة التشغيلية (تُخصم من الربح): \$${deliveryLoss.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: deliveryLoss > 0 ? Colors.red : Colors.green),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}

class CrmScreen extends StatefulWidget {
  const CrmScreen({super.key});

  @override
  State<CrmScreen> createState() => _CrmScreenState();
}

class _CrmScreenState extends State<CrmScreen> {
  void _addCustomerDialog() {
    final nameCtrl = TextEditingController();
    String mealType = 'مفروم';
    final daysCtrl = TextEditingController(text: '10');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('إضافة عميل جديد'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'اسم العميل')),
              DropdownButtonFormField<String>(
                value: mealType,
                decoration: const InputDecoration(labelText: 'نوع الوجبة المعتاد'),
                items: ['مفروم', 'فراخ', 'كبدة'].map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                onChanged: (val) => mealType = val!,
              ),
              TextField(
                controller: daysCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'دورة الطلب (بالأيام)'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
            ElevatedButton(
              onPressed: () {
                if (nameCtrl.text.isNotEmpty) {
                  appState.addCustomer(Customer(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameCtrl.text,
                    mealType: mealType,
                    lastOrderDate: DateTime.now(),
                    cycleDays: int.tryParse(daysCtrl.text) ?? 10,
                  ));
                  Navigator.pop(context);
                }
              },
              child: const Text('حفظ'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة العملاء (CRM)')),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCustomerDialog,
        child: const Icon(Icons.add),
      ),
      body: ListenableBuilder(
        listenable: appState,
        builder: (context, _) {
          if (appState.customers.isEmpty) {
            return const Center(child: Text('لا يوجد عملاء بعد. اضغط + للإضافة.'));
          }
          return ListView.builder(
            itemCount: appState.customers.length,
            itemBuilder: (context, index) {
              final c = appState.customers[index];
              final isDue = c.isDue;
              return Card(
                color: isDue ? Colors.red.shade50 : Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Icon(Icons.person, color: isDue ? Colors.red : Colors.teal),
                  title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('الوجبة: ${c.mealType} | التجديد القادم: ${c.nextOrderDate.toString().split(' ')[0]}'),
                  trailing: isDue ? const Icon(Icons.warning, color: Colors.red) : const Icon(Icons.check_circle, color: Colors.green),
                ),
              );
            },
          );
        }
      ),
    );
  }
}
