import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- 데이터 모델 (임시) ---
class Execution {
  final double price;
  final double quantity;
  Execution({required this.price, required this.quantity});
}

// 포지션 방향을 나타내는 Enum
enum PositionSide { long, short }

// --- 새 매매 기록 화면 ---
class NewTradeScreen extends StatefulWidget {
  static const String routeName = 'add-trade';
  static const String routePath = '/add-trade';
  const NewTradeScreen({super.key});

  @override
  State<NewTradeScreen> createState() => _NewTradeScreenState();
}

class _NewTradeScreenState extends State<NewTradeScreen> {
  // --- 디자인 시스템 (임시) ---
  static const Color _backgroundColor = Color(0xFF0D0D0D);
  static const Color _surfaceColor = Color(0xFF1A1A1A);
  static const Color _borderColor = Color(0xFF2B3139);
  static const Color _primaryTextColor = Color(0xFFFFFFFF);
  static const Color _secondaryTextColor = Color(0xFF848E9C);
  static const Color _accentColor = Color(0xFFF7931A);
  static const Color _positiveColor = Color(0xFF0ECB81);
  static const Color _negativeColor = Color(0xFFF23645);

  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();

  final String _selectedAsset = 'BTC/USDT';
  PositionSide _positionSide = PositionSide.long; // 기본값은 Long

  final List<Execution> _entries = []; // 진입 내역
  final List<Execution> _exits = []; // 청산 내역

  void _addExecution() {
    final price = double.tryParse(_priceController.text);
    final quantity = double.tryParse(_quantityController.text);
    if (price != null && quantity != null) {
      setState(() {
        final newExecution = Execution(price: price, quantity: quantity);
        // 현재 선택된 탭(진입/청산)에 따라 내역 추가
        // 이 예제에서는 단순화를 위해 하나의 버튼으로 진입/청산 모두 처리하도록 가정
        // 실제 앱에서는 진입/청산 탭을 두어 구분할 수 있음
        _entries.add(newExecution);
        _priceController.clear();
        _quantityController.clear();
      });
    }
  }

  @override
  void dispose() {
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLong = _positionSide == PositionSide.long;

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Log Trade',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Save',
              style: GoogleFonts.montserrat(
                color: _accentColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // --- 자산 선택 ---
          _buildAssetSelector(),
          const SizedBox(height: 24),

          // --- Long/Short 포지션 방향 선택 ---
          _buildPositionSideSelector(),
          const SizedBox(height: 24),

          // --- 가격/수량 입력 ---
          _buildInputFields(),
          const SizedBox(height: 24),

          // --- 실행 버튼 ---
          _buildExecuteButton(),
          const SizedBox(height: 24),

          // --- 실행 내역 ---
          _buildExecutionsList(
            title: isLong ? 'Buy Entries (Long)' : 'Sell Entries (Short)',
            entries: _entries,
            isEntry: true,
          ),
          const SizedBox(height: 16),
          _buildExecutionsList(
            title: isLong ? 'Sell Exits' : 'Buy Exits',
            entries: _exits,
            isEntry: false,
          ),
        ],
      ),
    );
  }

  Widget _buildAssetSelector() {
    // ... (기존과 동일)
    return Container();
  }

  Widget _buildPositionSideSelector() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _positionSide = PositionSide.long),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: _positionSide == PositionSide.long
                      ? _positiveColor
                      : Colors.transparent,
                ),
                child: Center(
                  child: Text(
                    'Long',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _positionSide = PositionSide.short),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: _positionSide == PositionSide.short
                      ? _negativeColor
                      : Colors.transparent,
                ),
                child: Center(
                  child: Text(
                    'Short',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputFields() {
    // ... (기존과 유사)
    return Column(
      children: [
        TextField(
          controller: _priceController,
          decoration: _buildInputDecoration(hintText: 'Price (USDT)'),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _quantityController,
          decoration: _buildInputDecoration(
            hintText: 'Quantity (${_selectedAsset.split('/')[0]})',
          ),
        ),
      ],
    );
  }

  Widget _buildExecuteButton() {
    bool isLong = _positionSide == PositionSide.long;
    // 이 예제에서는 하나의 버튼으로 진입/청산을 모두 처리하도록 단순화
    // 실제 앱에서는 "Add Entry", "Add Exit" 두 개의 버튼을 둘 수 있음
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _addExecution,
        style: ElevatedButton.styleFrom(
          backgroundColor: isLong ? _positiveColor : _negativeColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          isLong ? 'Add Buy Entry' : 'Add Sell Entry',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildExecutionsList({
    required String title,
    required List<Execution> entries,
    required bool isEntry,
  }) {
    final totalValue = entries.fold<double>(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );
    final totalQty = entries.fold<double>(
      0,
      (sum, item) => sum + item.quantity,
    );
    final avgPrice = totalQty > 0 ? totalValue / totalQty : 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
              color: _primaryTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Avg. Price:',
                style: GoogleFonts.montserrat(color: _secondaryTextColor),
              ),
              Text(
                avgPrice.toStringAsFixed(2),
                style: GoogleFonts.robotoMono(
                  color: _primaryTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Qty:',
                style: GoogleFonts.montserrat(color: _secondaryTextColor),
              ),
              Text(
                totalQty.toString(),
                style: GoogleFonts.robotoMono(
                  color: _primaryTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          if (entries.isNotEmpty) ...[
            const Divider(color: _borderColor, height: 24),
            ...entries.map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '@ ${e.price}',
                      style: GoogleFonts.robotoMono(
                        color: _secondaryTextColor,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '${e.quantity}',
                      style: GoogleFonts.robotoMono(
                        color: _secondaryTextColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration({required String hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.montserrat(
        color: _secondaryTextColor.withOpacity(0.5),
      ),
      filled: true,
      fillColor: _surfaceColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _accentColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}
